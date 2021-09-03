#' Create an S3 list of srcref objects 
#' 
#' @param x A list or single srcref to coerce to a list_of_srcref
#' 
#' @rdname as_list_of_srcref
as_list_of_srcref <- function(x) {
  UseMethod("as_list_of_srcref")  
}

#' @rdname as_list_of_srcref
as_list_of_srcref.environment <- function(x) {
  l <- as.list(x)
  as_list_of_srcref(l)  
}

#' @rdname as_list_of_srcref
as_list_of_srcref.list <- function(x) {
  structure(x, class = c("list_of_srcref", class(x)))
}



#' @export
`[.list_of_srcref` <- function(x, ...) {
  old_class <- class(x)
  class(x) <- setdiff(class(x), "list_of_srcref")  
  x <- x[...]
  class(x) <- old_class
  x
}
