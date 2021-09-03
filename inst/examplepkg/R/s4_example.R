#' @import methods
NULL

#' An example S4 class
#'
#' @slot data Some data
#' @export
#'
S4Example <- setClass("S4Example", representation(data = "list"))

#' Provide names of the data slot in an S4Example object
#'
#' @param x An x
#'
setMethod("names", signature("S4Example"), function(x) {
  names(x@data)  
})


#' Another example S4 class
#'
#' @slot data Some data
#' @export
#'
S4Example2 <- setClass("S4Example2", representation(data = "list"))

#' Provide names of the data slot in an S4Example2 object, to ensure we can
#' distinguish methods
#'
#' @param x An x
#'
setMethod("names", signature("S4Example2"), function(x) {
  names(x@data)  
})

