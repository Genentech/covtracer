#' Parse a test description from the calling expression
#'
#' In the general case, a simple indicator of the source file and line number is
#' used as a test description. There are some special cases where more
#' descriptive information can be extracted:
#'
#' \describe{
#'   \item{\code{testthat}}{If the test used \code{\link[testthat]{test_that}},
#'     then the description (\code{desc} parameter) is extracted and evaluated if
#'     need be to produce a descriptive string. Nested calls to
#'     \code{\link[testthat]{test_that}} currently return the outermost test
#'     description, although this behavior is subject to change.
#'   }
#' }
#'
#' @param x a unit test call stack or expression.
#' @return A string that describes the test. If possible, this will be a written
#'   description of the test, but will fall back to the test call as a string in
#'   cases where no written description can be determined.
#'
test_description <- function(x) {
  UseMethod("test_description")
}

#' @exportS3Method
test_description.default <- function(x) {
  NA_character_
}

#' @exportS3Method
test_description.srcref <- function(x) {
  keystr <- paste0("[", getSrcFilename(x), "#L", as.numeric(x)[1], "] ")
  test_description(paste0(keystr, srcref_str(x)))
}

#' @exportS3Method
test_description.expression <- function(x) {
  test_description(as.list(x))
}

#' @exportS3Method
#' @importFrom utils getSrcref
test_description.call <- function(x) {
  src <- getSrcref(x)
  if (is.null(src)) test_description(expr_str(x))
  else test_description(src)
}

#' @exportS3Method
test_description.character <- function(x) {
  as_test_desc(substring(x, 1L, 120L))
}

#' @exportS3Method
test_description.list <- function(x) {
  # check if the call stack contains a test_that call
  test_calls <- lapply(x, `[[`, 1L)
  is_test_that_call <- vapply(test_calls, function(test_call) {
    identical(test_call, quote(test_that)) ||
    identical(test_call, quote(testthat::test_that))
  }, logical(1L))

  if (any(is_test_that_call)) {
    descs <- lapply(x[which(is_test_that_call)], test_description_test_that)
    return(as_testthat_desc(paste(descs, collapse = "; ")))
  }

  test_description(x[[length(x)]])
}



#' Wrap object in test description derivation data
#'
#' @param x A test description string to bind style data to
#' @param type A type class to attribute to the test description. Defaults to
#'   \code{"call"}.
#' @return A \code{test_description} subclass object with additional
#'   \code{style} attribute indicating how the test description was derived.
#'
#' @rdname as_test_desc
as_test_desc <- function(x, type = "call") {
  structure(x, type = type, class = "test_description")
}

#' Adds "testthat" style
#'
#' @rdname as_test_desc
as_testthat_desc <- function(x) {
  as_test_desc(x, type = "testthat")
}



#' Parse the test_that description from a test_that call
#'
#' @param x A test_that call object
#' @param ... Additional arguments unused
#'
test_description_test_that <- function(x, ...) {
  expr <- match.call(testthat::test_that, x)$desc
  if (is.character(expr)) return(as_testthat_desc(expr))
  try_expr <- try(eval(expr, envir = baseenv()), silent = TRUE)
  if (!inherits(try_expr, "try-error")) return(as_testthat_desc(try_expr))
  as_test_desc(expr_str(expr))
}



#' Parse the expression associated with a srcref
#'
#' @param ref a \code{srcref}
#'
srcref_expr <- function(ref) {
  parse(text = srcref_str(ref))
}



#' Parse the expression associated with a srcref
#'
#' @param ref a \code{srcref}
#'
srcref_str <- function(ref) {
  paste0(as.character(ref), collapse = "\n")
}



#' Convert an expression or call to a single-line string
#'
#' @param ref a \code{srcref}
#'
expr_str <- function(ref) {
  if (is.expression(ref)) ref <- as.call(ref)
  gsub("\\s{2,}", " ", paste0(deparse(ref), collapse = "; "))
}
