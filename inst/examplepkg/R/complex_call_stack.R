#' Example of a function that calls down into a deeply nested call stack
#' @export
complex_call_stack <- function(x) {
  nested_function(x)
}

#' An example of a non-exported function in a deep call stack
#'
nested_function <- function(x) {
  deeper_nested_function(x)
}

#' Example of a function within a deeply nested call stack
#' @export
deeper_nested_function <- function(x) {
  recursive_function(x)
}

#' An example of an internal recursive function
#'
recursive_function <- function(x, i = 3L) {
  if (i <= 0L) return(x)
  recursive_function(x, i - 1L)
}
