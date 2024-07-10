#' Create an S3 list of srcref objects
#'
#' @param x A list or single srcref to coerce to a `list_of_srcref`
#' @return A `list_of_srcref` class object
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



#' Format a list_of_srcref object
#'
#' Format list_of_srcref as character
#'
#' @param x A \code{list_of_srcref} object
#' @param ... Additional arguments unused
#' @param full.names A \code{logical} value indicating whether to use full file
#'   paths when formatting `srcref`s.
#' @param full.num A \code{logical} value indicating whether to use all numeric
#'   `srcref` components when formatting `srcref`s.
#' @return A `character` vector of formatted strings
#'
#' @export
format.list_of_srcref <- function(x, ..., full.names = FALSE, full.num = FALSE) {
  out <- rep_len(NA_character_, length(x))
  if (!length(x)) {
    return(out)
  }
  xnull <- vapply(x, is.null, logical(1L))
  srcnull <- vapply(x, function(i) is.null(getSrcref(i)), logical(1L))
  isnull <- xnull | srcnull
  if (all(isnull)) {
    return(out)
  }
  fps <- if (full.names) getSrcFilepath(x[!isnull]) else vapply(x[!isnull], getSrcFilename, character(1L))
  srcref_num_rep_len <- length(as.numeric(x[!isnull][[1]]))
  nums <- t(vapply(x[!isnull], as.numeric, numeric(srcref_num_rep_len)))
  cols <- c(1L, 5L, 3L, 6L)
  cols <- cols[which(cols < ncol(nums))]
  nums <- if (full.num) nums else nums[, cols, drop = FALSE]
  out[!isnull] <- apply(cbind(fps, nums), 1L, paste0, collapse = ":")
  out
}



#' @export
print.list_of_srcref <- function(x, ...) {
  if (is.null(names(x))) names(x) <- rep_len("", length(x))
  xnames <- ifelse(
    names(x) == "",
    sprintf("[[%d]]", seq_along(x)),
    sprintf("$%s", ifelse(
      grepl("^[a-zA-Z0-9_.]*$", names(x)),
      names(x),
      sprintf("`%s`", names(x))
    ))
  )
  xfmt <- sprintf(
    "%s\n%s\n\n",
    xnames,
    lapply(x, function(xi) paste0(collapse = "\n", format(xi)))
  )
  cat(paste0(collapse = "", xfmt))
}
