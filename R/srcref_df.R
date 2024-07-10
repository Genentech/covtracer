#' Coerce a list_of_srcref object to a data.frame
#'
#' @param x A \code{list_of_srcref} object
#' @param ... Additional arguments unused
#' @param use.names A \code{logical} indicating whether the names of \code{x}
#'   should be used to create a \code{name} column.
#' @param expand.srcref A \code{logical} indicating whether to expand the
#'   components of \code{srcref} objects into separate columns.
#' @inheritParams base::data.frame
#' @return A \code{data.frame} with one record per \code{srcref} and variables:
#' \describe{
#' \item{name}{Names of the \code{srcref} objects, passed using the names of
#'   \code{x} if \code{use.names = TRUE}}
#' \item{srcref}{\code{srcref} objects if \code{expand.srcrefs = FALSE}}
#' \item{srcfile, line1, byte1, line2, col1, col2, parsed1, parsed2}{The
#'   \code{srcref} file location if it can be determined. If an absolute path
#'   can't be found, only the base file name provided in the `srcref` object and
#'   the numeric components of the \code{srcref} objects if \code{expand.srcrefs
#'   = TRUE}}
#' }
#'
#' @examples
#' pkg <- system.file("examplepkg", package = "covtracer")
#' install.packages(
#'   pkg,
#'   type = "source",
#'   repos = NULL,
#'   quiet = TRUE,
#'   INSTALL_opts = "--with-keep.source"
#' )
#' as.data.frame(pkg_srcrefs("examplepkg"))
#' @export
as.data.frame.list_of_srcref <- function(
    x, ..., use.names = TRUE,
    expand.srcref = FALSE, row.names = NULL) {
  if (expand.srcref) {
    df <- data.frame(
      srcfile = getSrcFilepath(x),
      matrix(
        t(vapply(lapply(x, as.numeric), `[`, numeric(8L), 1:8)),
        ncol = 8L,
        dimnames = list(c(), c(
          "line1", "byte1", "line2",
          "byte2", "col1", "col2", "parsed1", "parsed2"
        ))
      ),
      stringsAsFactors = FALSE,
      row.names = row.names,
      ...
    )
  } else {
    df <- data.frame(
      srcref = I(x),
      stringsAsFactors = FALSE,
      row.names = row.names,
      ...
    )
    class(df$srcref) <- setdiff(class(df$srcref), "AsIs")
  }

  if (use.names) {
    df <- cbind(name = names(x), df, stringsAsFactors = FALSE)
  }

  df
}



#' Create a data.frame of package srcref objects
#'
#' @inheritParams pkg_srcrefs
#' @return A \code{data.frame} with a record for each source code block with
#'   variables:
#'
#' \describe{
#'   \item{name}{A \code{character} Rd alias for the package object}
#'   \item{srcref}{The \code{srcref} of the associated package source code}
#' }
#'
#' @examples
#' pkg <- system.file("examplepkg", package = "covtracer")
#' install.packages(
#'   pkg,
#'   type = "source",
#'   repos = NULL,
#'   quiet = TRUE,
#'   INSTALL_opts = "--with-keep.source"
#' )
#' pkg_srcrefs_df("examplepkg")
#'
#' @family srcrefs_df
#' @seealso srcrefs test_trace_mapping
#'
#' @export
pkg_srcrefs_df <- function(x) {
  srcs <- pkg_srcrefs(x)
  df <- as.data.frame(srcs)
  has_srcref <- vapply(df$srcref, inherits, logical(1L), "srcref")
  df$namespace <- rep_len(NA_character_, nrow(df))

  df[has_srcref, "namespace"] <- vapply(
    srcs[has_srcref],
    attr,
    character(1L),
    "namespace"
  )

  df[!has_srcref, "namespace"] <- vapply(
    df$name[!has_srcref],
    obj_namespace_name,
    character(1L),
    ns = x
  )

  # filter srcrefs pulled from other files (often through class constructors)
  df <- df[is.na(df$srcref) | !is.na(df$namespace), , drop = FALSE]

  df
}



#' Create a data.frame of coverage trace srcref objects
#'
#' Extract \code{\link[covr:package_coverage]{coverage}} traces. Traces are the
#' traced lines of code counted when evaluating code coverage, which are used
#' for counting expression evaluation. Each traced is a unique expression within
#' a package's source code.
#'
#' @inheritParams pkg_srcrefs
#' @return A \code{data.frame}, where each record it a trace \code{srcref} with
#'   variables:
#'
#' \describe{
#'   \item{name}{A \code{character} identifier. This will use the names of the
#'      elements of a \code{\link[covr:package_coverage]{coverage}} object,
#'      which are \code{srcref} "keys".}
#'   \item{srcref}{A \code{srcref} object of the trace source code location}
#' }
#'
#' @examples
#' options(covr.record_tests = TRUE)
#' pkg_path <- system.file("examplepkg", package = "covtracer")
#' cov <- covr::package_coverage(pkg_path)
#' trace_srcrefs_df(cov)
#'
#' @family srcrefs_df
#' @seealso srcrefs test_trace_mapping
#'
#' @export
trace_srcrefs_df <- function(x) {
  as.data.frame(trace_srcrefs(x))
}



#' Create a data.frame of coverage test srcref objects
#'
#' Extract unit test \code{srcref}s from a
#' \code{\link[covr:package_coverage]{coverage}} object. A test name will be
#' derived from the test source code, preferrably from a written annotation, but
#' otherwise falling back to using a code snippet. \code{srcrefs} are unique for
#' each expression executed within a testing suite.
#'
#' @inheritParams pkg_srcrefs
#' @return A \code{data.frame} of test \code{srcrefs} extracted from a
#'   \code{coverage} object. Contains one record for each \code{srcref} with
#'   variables:
#'
#' \describe{
#'   \item{name}{
#'     A \code{character} test description. For \code{testthat} tests, the
#'     \code{desc} parameter will be used, otherwise a snippet of code will be
#'     used for the test name
#'   }
#'   \item{srcref}{
#'     A \code{srcref} object describing the location of the test
#'   }
#'   \item{test_type}{
#'     A \code{character} indicating the structure of the test.  One of
#'     \code{"testthat"}, \code{"call"} or \code{NULL}
#'   }
#' }
#'
#' @examples
#' options(covr.record_tests = TRUE)
#' pkg_path <- system.file("examplepkg", package = "covtracer")
#' cov <- covr::package_coverage(pkg_path)
#' test_srcrefs_df(cov)
#'
#' @family srcrefs_df
#' @seealso srcrefs test_trace_mapping
#'
#' @export
test_srcrefs_df <- function(x) {
  UseMethod("test_srcrefs_df")
}

#' @importFrom utils tail
#' @export
test_srcrefs_df.coverage <- function(x) {
  cov_tests <- attr(x, "tests")

  # extract tests srcrefs and descriptions and structure as data.frame
  test_srcs <- test_srcrefs(x)
  test_desc <- lapply(cov_tests, test_description)
  names(test_srcs) <- as.character(test_desc)
  df <- as.data.frame(test_srcs)

  # extract test description style attribute and structure as column
  test_type <- lapply(test_desc, attr, "type")
  test_type_isnull <- vapply(test_type, is.null, logical(1L))
  df$type <- ifelse(test_type_isnull, NA_character_, as.character(test_type))

  df
}



#' Create a data.frame mapping tests to coverage traces
#'
#' Extract a matrix used to relate test code to the traces that each test
#' evaluates.
#'
#' @param x A `coverage` object produced with
#'   `options(covr.record_tests = TRUE)`.
#' @return A `data.frame` with one record for each line of code executed, with
#'   variables:
#'
#' \describe{
#'   \item{test}{The index of the test that was executed, reflecting the order
#'      in which tests are executed}
#'   \item{depth}{The call stack depth when the coverage trace was evaluated}
#'   \item{i}{The index of the expression evaluated by each test. This can be
#'      used to recover an order of trace execution for a given test index}
#'   \item{trace}{The index of the coverage trace that was evaluated}
#' }
#'
#' @examples
#' options(covr.record_tests = TRUE)
#' pkg_path <- system.file("examplepkg", package = "covtracer")
#' cov <- covr::package_coverage(pkg_path)
#' test_trace_mapping(cov)
#'
#' @seealso srcrefs_df srcrefs
#'
#' @export
test_trace_mapping <- function(x) {
  has_tests <- vapply(
    x,
    function(i) !is.null(i[["tests"]]) && nrow(i[["tests"]]) > 0L,
    logical(1L)
  )

  if (!any(has_tests)) {
    return(new_empty_test_trace_tally())
  }

  mat <- do.call(
    rbind,
    mapply(
      function(i, covi) cbind(covi$tests, trace = i),
      seq_along(x)[has_tests],
      x[has_tests],
      SIMPLIFY = FALSE
    )
  )

  mat <- mat[order(mat[, "test"], mat[, "i"]), , drop = FALSE]
  mat
}



#' Match srcrefs against srcrefs that contain them
#'
#' Provided two lists of `srcref` objects, find the first `srcrefs` in `r` that
#' entirely encapsulate each respective `srcref` in `l`, returning a list of
#' indices of `srcref`s in `r` for each `srcref` in `l`.
#'
#' @param l A `list_of_srcref` object
#' @param r A `list_of_srcref` object
#' @return A `integer` vector of the first index in `r` that fully encapsulate
#'   the respective element in `l`
#'
match_containing_srcrefs <- function(l, r) {
  # NOTE:
  #   srcrefs are matched due to filenames, as full file paths are often
  #   different. Trace srcrefs srcfiles will point to a temporary installation
  #   when running covr, whereas package namespace srcrefs srcfiles will point
  #   to the package install location.
  #
  # TODO:
  #   more comprehensive path comparisons (perhaps pkgname/R/file.R)

  ldf <- as.data.frame(l, expand.srcref = TRUE)
  rdf <- as.data.frame(r, expand.srcref = TRUE)

  # store ordering, we'll reverse ordering for return
  ldf <- ldf[orderl <- with(ldf, order(srcfile, line1, col1, -line2, -col2)), ]
  rdf <- rdf[orderr <- with(rdf, order(srcfile, line1, col1, -line2, -col2)), ]

  idx <- rep(NA_integer_, nrow(ldf))
  li <- ri <- 1L

  while (li <= nrow(ldf) && ri <= nrow(rdf)) {
    # if filenames don't match, jump to filename
    if (!identical(t <- basename(ldf[[li, "srcfile"]]), basename(rdf[[ri, "srcfile"]]))) {
      p <- Position(function(i) identical(i, t), basename(rdf[ri:nrow(rdf), "srcfile"]))
      if (is.na(p)) {
        # no srcrefs from the same file, no chance of being contained, iterate
        idx[[li]] <- NA_integer_
        li <- li + 1L
      } else {
        # jump to srcrefs from the same file
        ri <- ri + p - 1L
      }
      next
    }

    l_start_gte_r_start <- (ldf[[li, "line1"]] > rdf[[ri, "line1"]]) ||
      (ldf[[li, "line1"]] == rdf[[ri, "line1"]] &&
        ldf[[li, "col1"]] >= rdf[[ri, "col1"]])

    l_end_lte_r_end <- (ldf[[li, "line2"]] < rdf[[ri, "line2"]]) ||
      (ldf[[li, "line2"]] == rdf[[ri, "line2"]] &&
        ldf[[li, "col2"]] <= rdf[[ri, "col2"]])

    if (!is.na(l_start_gte_r_start) && l_start_gte_r_start) {
      if (!is.na(l_end_lte_r_end) && l_end_lte_r_end) {
        # left starts after and ends before right - is contained entirely within right
        idx[[li]] <- ri
        li <- li + 1L
      } else {
        # left starts after right, but ends after right also - not contained within right
        ri <- ri + 1L
      }
    } else {
      # left starts after right - not contained within right
      idx[[li]] <- NA_integer_
      li <- li + 1L
    }
  }

  # unsort our index so it reflects unsorted l & r matching
  idx[orderl] <- orderr[idx]
  idx
}



#' Join srcref data.frames by intersection of srcref spans
#'
#' References to source code are defined by the source code line and column span
#' of the relevant source code. This function takes data frames containing that
#' information to pair source code in one data frame to source code from
#' another. In this case, source code from the left hand data frame is paired if
#' it is entirely contained within a record of source code in the right hand
#' data frame.
#'
#' @param x A `data.frame`, as produced by `as.data.frame` applied to a
#'   `list_of_srcref`, against which `y` should be joined.
#' @param y A `data.frame`, as produced by `as.data.frame` applied to a
#'   `list_of_srcref`, joining data from srcrefs data which encompasses srcrefs
#'   from `x`.
#' @param by A named `character` `vector` of column names to use for the merge.
#'   The name should be the name of the column from the left `data.frame`
#'   containing a `list_of_srcref` column, and the value should be the name of a
#'   column from the right `data.frame` containing a `list_of_srcref` column.
#' @return A `data.frame` of `x` joined on `y` by spanning `srcref`
#'
#' @export
join_on_containing_srcrefs <- function(x, y, by = c("srcref" = "srcref")) {
  by <- by[1L]
  if (!names(by) %in% names(x) || !by %in% names(y)) {
    stop("joining columns defined in `by` not found in provided data.frames")
  }

  idx <- match_containing_srcrefs(x[[names(by)[[1L]]]], y[[by[[1L]]]])
  if (any(names(y) %in% names(x))) {
    names(x) <- paste(names(x), "x", sep = ".")
    names(y) <- paste(names(y), "y", sep = ".")
  }

  x[names(y)] <- y[idx, ]
  x
}
