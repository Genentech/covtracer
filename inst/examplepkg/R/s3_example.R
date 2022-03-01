#' An example of an S3 generic
#'
#' @param x An X
#' @param ... Ellipsis
#'
#' Used to ensure traces can be linked through s3 dispatch
#'
#' @export
#' @rdname s3_example_func
s3_example_func <- function(x, ...) {
  UseMethod("s3_example_func")
}

#' @rdname s3_example_func
s3_example_func.default <- function(x, ...) {
  "default"
}

#' @rdname s3_example_func
s3_example_func.list <- function(x, ...) {
  "list"
}
