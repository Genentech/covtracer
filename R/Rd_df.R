#' Create a tabular representation of man file information
#'
#' Provides Rd index info with a few additional columns of information about
#' each exported object. Returns one record per documented object, even if
#' multiple objects alias to the same documentation file.
#'
#' @inheritParams as.package
#' @return A \code{data.frame} of documented object information with variables:
#' \describe{
#' \item{index}{A \code{numeric} index of documentation files associated with
#'   documentation objects}
#' \item{file}{A \code{character} filename of the Rd file in the "man" directory}
#' \item{filepath}{A \code{character} file path of the Rd file in the "man"
#'   directory}
#' \item{alias}{\code{character} object names which are aliases for the
#'   documentation in \code{filepath}}
#' \item{is_exported}{A \code{logical} indicator of whether the aliased object
#'   is exported from the package namespace}
#' \item{doctype}{A \code{character} representing the Rd docType field.}
#' }
#'
#' @examples
#' package_source_dir <- system.file("examplepkg", package = "covtracer")
#' Rd_df(package_source_dir)
#'
#' @export
Rd_df <- function(x) {
  x <- as.package(x)
  db <- tools::Rd_db(dir = x$path)
  exports <- parseNamespaceFile(basename(x$path), dirname(x$path))$exports

  # as suggested in ?tools::Rd_db examples
  aliases <- lapply(db, .tools$.Rd_get_metadata, "alias")
  keywords <- lapply(db, .tools$.Rd_get_metadata, "keyword")
  doctype <- vapply(db, function(i) {
    doctype <- attr(i, "meta")$docType
    if (length(doctype)) doctype else NA_character_
  }, character(1L))

  aliases <- aliases[sort(names(aliases))] # avoid OS-specific file sorting
  naliases <- vapply(aliases, length, integer(1L))
  files <- rep(names(db), times = naliases)
  doctype <- rep(doctype, times = naliases)
  filepaths <- file.path(normalizePath(x$path), "man", files)
  aliases <- unlist(aliases, use.names = FALSE)

  data.frame(
    file = files %||% character(0L),
    filepath = filepaths %||% character(0L),
    alias = aliases %||% character(0L),
    is_exported = aliases %in% exports,
    doctype = doctype %||% character(0L),
    stringsAsFactors = FALSE
  )
}
