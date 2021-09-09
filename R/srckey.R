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
#'
#' @export
format.list_of_srcref <- function(x, ..., full.names = FALSE, full.num = FALSE) {
  out <- rep_len(NA_character_, length(x))
  if (!length(x)) return(out)
  xnull <- vapply(x, is.null, logical(1L))
  srcnull <- vapply(x, function(i) is.null(getSrcref(i)), logical(1L))
  isnull <- xnull | srcnull
  if (all(isnull)) return(out)
  fps <- if (full.names) getSrcFilepath(x[!isnull]) else vapply(x[!isnull], getSrcFilename, character(1L))
  nums <- t(vapply(x[!isnull], as.numeric, numeric(length(as.numeric(x[[1]])))))
  cols <- c(1L, 5L, 3L, 6L)
  cols <- cols[which(cols < ncol(nums))]
  nums <- if (full.num) nums else nums[, cols, drop = FALSE]
  out[!isnull] <- apply(cbind(fps, nums), 1L, paste0, collapse = ":")
  out
}




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



#' Get the full path to the srcref file
#'
#' @param x A \code{srcref} or \code{list_of_srcref} object
#' @return A \code{character} vector of source file paths.
#'
getSrcFilepath <- function(x) {
  UseMethod("getSrcFilepath")
}

#' @importFrom utils getSrcFilename getSrcref
getSrcFilepath.default <- function(x) {
  path <- getSrcFilename(x, full.names = TRUE)
  wd <- attr(getSrcref(x), "srcfile")$wd
  if (!is.null(wd)) path <- file.path(wd, path)
  if (!length(path)) return(NA_character_)
  normalizePath(path, winslash = "/", mustWork = FALSE)
}

#' @importFrom utils getSrcref
getSrcFilepath.list_of_srcref <- function(x) {
  paths <- rep_len(NA_character_, length(x))
  wds <- lapply(x, function(i) attr(getSrcref(i), "srcfile")$wd)
  fns <- lapply(x, function(i) attr(getSrcref(i), "srcfile")$filename)
  has_wd <- !vapply(wds, is.null, logical(1L))
  has_fp <- !vapply(fns, is.null, logical(1L))
  paths[has_wd & has_fp] <- file.path(wds[has_wd & has_fp], fns[has_wd & has_fp])
  paths[!has_wd & has_fp] <- as.character(fns[!has_wd & has_fp])
  paths
}
