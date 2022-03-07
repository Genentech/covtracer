#' For consistency, stub calls with srcref-like attributes
#'
#' Most relevant data can be traced to an existing srcref. However, some data,
#' such as test traces from coverage objects, are likely cleaned up and their
#' srcfiles deleted, causing a barrage of warnings any time these objects are
#' printed.
#'
#' A `pseudo_srcref` adds in the `srcref` data but continues to preserve the
#' expression content. This allows these expression objects to be pretty-printed
#' like `srcref`s when included as a `list_of_srcref` `data.frame` column.
#'
#' @param call Any code object, most often a `call` object
#' @param file A filepath to bind as a `srcfile` object
#' @param lloc A `srcef`-like `lloc` numeric vector
#'
with_pseudo_srcref <- function(call, file, lloc) {
  if (!is.null(srcfile) && !is.null(lloc))
    attr(call, "srcref") <- structure(lloc, srcfile = srcfile(file), class = "pseudo_srcref")
  structure(call, class = c("with_pseudo_srcref", class(call)))
}

#' @export
as.double.with_pseudo_srcref <- function(x, ...) {
  as.numeric(getSrcref(x))
}

#' @export
format.with_pseudo_srcref <- function(x, ...) {
  format(unclass(x), ...)
}
