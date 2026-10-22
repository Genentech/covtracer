#' Add one
#'
#' @param x A number.
#' @return `x + 1`
#' @export
b <- function(x) {
  x + 1
}

#' @rdname b
#' @export
a <- b

#' @rdname b
#' @export
v <- Vectorize(b)

with_default_x <- function(fun, x) {
  formals(fun)$x <- x
  fun
}

#' @rdname b
#' @export
b1 <- with_default_x(b, 1)
