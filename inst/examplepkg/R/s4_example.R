#' @import methods
NULL


#' An example S4 class
#'
#' @slot data Some data
#'
#' @export
#' @exportClass S4Example
S4Example <- setClass("S4Example", representation(data = "list"))

#' Provide names of the data slot in an S4Example object
#'
#' @param x An x
#'
setMethod("names", signature("S4Example"), function(x) {
  names(x@data)
})

#' Provide show of the data slot in an S4Example object
#'
#' @param x An x
#'
setMethod("show", signature("S4Example"), function(object) {
  print(object@data)
})


#' Another example S4 class
#'
#' @slot data Some data
#'
#' @export
#' @exportClass S4Example2
S4Example2 <- setClass("S4Example2", representation(data = "list"))

#' Provide names of the data slot in an S4Example2 object, to ensure we can
#' distinguish methods
#'
#' @param x An x
#'
setMethod("names", signature("S4Example2"), function(x) {
  names(x@data)
})


#' Example S4 generic registered by a package
#'
#' @param x An x
#'
#' @export
setGeneric("increment", function(x) {
  standardGeneric("increment")
})

#' @exportMethod increment
setMethod("increment", "numeric", function(x) {
  x + 1
})
