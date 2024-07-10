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
  if (is.null(src)) {
    test_description(expr_str(x))
  } else {
    test_description(src)
  }
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

  is_describe_call <- vapply(test_calls, function(test_call) {
    identical(test_call, quote(describe)) ||
      identical(test_call, quote(testthat::describe))
  }, logical(1L))

  # only consider `it` calls within a `describe` call
  is_it_call <- cumsum(is_describe_call) > 0 &
    vapply(test_calls, identical, logical(1L), quote(it))

  # handle testthat::test_that tests
  if (any(is_test_that_call)) {
    descs <- lapply(x[which(is_test_that_call)], test_description_test_that)
    return(as_testthat_desc(paste(descs, collapse = "; ")))
  }

  # handle testthat::describe tests
  if (any(is_it_call)) {
    descs <- rep_len(NA_character_, length(test_calls))
    descs[which(is_describe_call)] <- lapply(
      x[which(is_describe_call)],
      test_description_test_that_describe
    )

    descs[which(is_it_call)] <- lapply(
      x[which(is_it_call)],
      test_description_test_that_describe_it
    )

    descs <- descs[!is.na(descs)]
    return(as_testthat_desc(paste(descs, collapse = ": ")))
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
  if (!is.character(x)) {
    try_result <- try(eval(x, envir = baseenv()), silent = TRUE)
    if (!inherits(try_result, "try-error")) {
      x <- try_result
    } else {
      return(as_test_desc(expr_str(x)))
    }
  }

  as_test_desc(x, type = "testthat")
}



#' Parse the test description from a `test_that` call
#'
#' @param x A test_that call object
#' @param ... Additional arguments unused
#' @return A `character` description, parsed from a `test_that::test_that` call
#'
test_description_test_that <- function(x, ...) {
  as_testthat_desc(match.call(testthat::test_that, x)$desc)
}



#' Parse the test description from a `describe` call
#'
#' @param x A `test_that::describe` call object
#' @param ... Additional arguments unused
#' @return A `character` description, parsed from a `test_that::describe` call
#'
test_description_test_that_describe <- function(x, ...) {
  as_testthat_desc(match.call(testthat::describe, x)$description)
}



#' Parse the test description from a `it` call
#'
#' @param x A `test_that::it` call object
#' @param ... Additional arguments unused
#' @return A `character` description, parsed from a `test_that::it` call
#'
test_description_test_that_describe_it <- function(x, ...) {
  # mock `it` function, defined in testthat::describe
  f <- function(it_description, it_code = NULL) {}
  as_testthat_desc(match.call(f, x)$it_description)
}



#' Parse the expression associated with a srcref
#'
#' @param ref a `srcref`
#' @return A parsed `srcref` object
#'
srcref_expr <- function(ref) {
  parse(text = srcref_str(ref))
}



#' Convert a srcref into a string
#'
#' @param ref a `srcref`
#' @return A string representing the `srcref`
#'
srcref_str <- function(ref) {
  paste0(as.character(ref), collapse = "\n")
}



#' Convert an expression, call or symbol to a single-line string
#'
#' @param ref a \code{srcref}
#' @return The given expression, formatted as a string with prefixes for
#'   symbols and generics.
#'
expr_str <- function(ref) {
  # used when description of the test is given by a variable
  # (see: inst/examplepkg/tests/testthat/test-complex-calls.R)
  if (is.symbol(ref)) {
    return(paste0("symbol: ", as.character(ref)))
  }
  # special case naked generic calls (see: inst/examplepkg/tests/non-testthat.R)
  if (inherits(ref[[1]], "standardGeneric")) {
    return(paste0("S4 Generic Call: ", format_standardGeneric_call(ref)))
  }

  if (is.expression(ref)) ref <- as.call(ref)
  gsub("\\s{2,}", " ", paste0(deparse(ref), collapse = "; "))
}
