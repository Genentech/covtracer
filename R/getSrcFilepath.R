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
  if (!length(path)) {
    return(NA_character_)
  }
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
