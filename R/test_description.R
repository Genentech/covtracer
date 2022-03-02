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
  test_description(paste0(keystr, expr_str(srcref_expr(x))))
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
  substring(x, 1L, 120L)
}

#' @exportS3Method
#' @importFrom utils head
test_description.list <- function(x) {
  # check if the call stack contains a test_that call
  is_test_that_call <- lapply(x, `[[`, 1L) == quote(test_that)
  if (any(is_test_that_call)) {
    descs <- lapply(x[which(is_test_that_call)], test_description_test_that)
    return(paste(descs, collapse = "; "))
  }

  test_description(x[[length(x)]])
}



#' Parse the test_that description from a test_that call
#'
#' @param x A test_that call object
#' @param ... Additional arguments unused
#'
test_description_test_that <- function(x, ...) {
  expr <- match.call(testthat::test_that, x)$desc
  if (is.character(expr)) return(expr)
  try_expr <- try(eval(expr, envir = baseenv()), silent = TRUE)
  if (!inherits(try_expr, "try-error")) return(try_expr)
  expr_str(expr)
}



#' Parse the expression associated with a srcref
#'
#' @param ref a \code{srcref}
#'
srcref_expr <- function(ref) {
  parse(text = as.character(ref))
}



#' Convert an expression or call to a single-line string
#'
#' @param ref a \code{srcref}
#'
expr_str <- function(ref) {
  if (is.expression(ref)) ref <- as.call(ref)
  gsub("\\s{2,}", " ", paste0(deparse(ref), collapse = "; "))
}
