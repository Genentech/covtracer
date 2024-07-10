#' Build a traceability matrix that links documented behaviors to unit tests
#'
#' Intercept unit test coverage reports and process results to link evaluated
#' functions to the unit tests which trigger their evaluation. In doing so,
#' we can then link the associated function documentation of each object to
#' the tests that triggered their evaluation as a way of reusing existing
#' documentation to generate specifications.
#'
#' @param x A package object, name, source code path or coverage result to use
#'   as the bases of tracing tests. Coverage results must have been produced
#'   using `options(covr.record_tests = TRUE)`.
#' @param ... Additional arguments unused
#' @return A `data.frame` of tests and corresponding traces
#'
#' @export
#' @rdname test_trace_df
test_trace_df <- function(x, ...) {
  UseMethod("test_trace_df")
}

#' @param pkg A `package` object as produced by `as.package`, if a specific
#'   package object is to be used for inspecting the package namespace.
#' @param aggregate_by `NULL` or a function by which to aggregate recurring hits
#' `counts` and `direct` columns from a test to a trace. If `NULL`, no
#' aggregation will be applied. (Default `sum`)
#'
#' @importFrom stats aggregate
#' @export
#' @rdname test_trace_df
test_trace_df.coverage <- function(
    x, ...,
    pkg = as.package(attr(x, "package")$path),
    aggregate_by = sum) {
  coverage_check_has_recorded_tests(x)
  pkgname <- pkg$package

  # I. Collect source data
  #    1. build data frame of test trace "srcrefs", attempt to extract test
  #         description
  #    2. build data frame of coverage trace srcrefs
  #    3. build data frame of package namespace object srcrefs
  #    4. build data frame of documentation data
  #    5. build mapping of test traces to coverage traces
  # II. Join source data
  #    1. join coverage traces (I.2) against package namespace object srcrefs
  #         that contain each (I.3)
  #    2. join test-trace mapping (I.5) against test trace srcrefs (I.1)
  #    3. join coverage+package srcrefs (II.1) against tests+mapping (II.2)
  #    4. join aliases against docs (I.5)

  # I.1 build test traces
  tests_df <- test_srcrefs_df(x)
  names(tests_df) <- paste("test", names(tests_df), sep = "_")

  # I.2 build namespace srcref data.frame
  pkg_df <- pkg_srcrefs_df(pkgname)
  names(pkg_df)[match("name", names(pkg_df))] <- "alias"

  # I.3 build coverage traces
  trace_df <- trace_srcrefs_df(x)
  names(trace_df) <- paste("trace", names(trace_df), sep = "_")

  # I.4 build documentation data.frame (and rename to remove ambiguity)
  docs_df <- Rd_df(pkg$path)
  docs_df <- merge(
    docs_df,
    unique(pkg_df[, c("alias", "namespace"), drop = FALSE]),
    by = "alias",
    all.x = TRUE,
    all.y = TRUE
  )

  # I.5 build test-to-trace matrix, summarizing by trace hits
  test_mat <- test_trace_mapping(x)
  test_mat <- cbind(
    test_mat,
    count = rep(1L, nrow(test_mat)),
    direct = test_mat[, "i"] == 1L
  )

  if (nrow(test_mat)) {
    if (!is.null(aggregate_by)) {
      test_mat <- stats::aggregate(
        cbind(count, direct) ~ test + trace,
        test_mat,
        aggregate_by
      )
    }
    test_mat[, "direct"] <- ifelse(test_mat[, "direct", drop = FALSE] > 0L, 1L, 0L)
  }

  # II.1 merge traces against namespace srcrefs to link objects and docs
  trace_df <- join_on_containing_srcrefs(
    trace_df,
    pkg_df[, setdiff(names(pkg_df), "namespace"), drop = FALSE],
    by = c("trace_srcref" = "srcref")
  )

  trace_df$trace <- seq_len(nrow(trace_df))

  # II.2 merge tests against traces to link test num, hash and description to
  # trace
  tests_df <- cbind(test_mat, tests_df[test_mat[, "test"], ])

  # II.3 merge coverage+package traces against test traces
  df <- merge(tests_df, trace_df, by = "trace", all.x = TRUE, all.y = TRUE)

  # II.4 merge pkg objects against their documentation by documentation alias,
  # keeping untested objects
  df <- merge(df, docs_df, by = "alias", all.x = TRUE, all.y = TRUE)

  # Reorder columns
  df$is_reexported <- !(is.na(df$namespace) | df$namespace == pkgname)
  cols <- setdiff(names(df), c("trace_name", "trace", "test", "depth"))
  col_order <- c(
    "alias", "srcref", "test_name", "test_srcref", "trace_srcref",
    "count", "direct", "is_exported", "is_reexported"
  )
  col_order <- c(col_order, setdiff(cols, col_order))
  df <- df[, col_order]

  df
}



#' Retrieve test traces from a coverage object
#'
#' Assumes the coverage object was produced while
#' \code{option(covr.record_tests = TRUE)}.
#'
#' @param coverage a \code{\link[covr]{covr}} coverage object
#' @return A `list` of tests evaluated when using `covr`
#'
#' @family coverage_tests
coverage_get_tests <- function(coverage) {
  attr(coverage, "tests")
}



#' Test that the coverage object retains testing information
#'
#' Test whether the coverage object has expected fields produced when coverage
#' was captured with \code{option(covr.record_tests = TRUE)}.
#'
#' @param coverage a \code{\link[covr]{covr}} coverage object
#' @return A `logical` value, indicating whether the coverage object has
#'   recorded tests, or `NA` when it does not appear to have traced any test
#'   code.
#'
#' @family coverage_tests
#' @importFrom utils getSrcDirectory
coverage_has_recorded_tests <- function(coverage) {
  has_tests_attr <- !is.null(attr(coverage, "tests"))

  has_r_dir_traces <- !is.na(Position(
    function(trace) basename(getSrcDirectory(trace$srcref)) == "R",
    coverage
  ))

  has_trace_tests <- !is.na(Position(
    function(trace) !is.null(trace[["tests"]]),
    coverage
  ))

  if (has_tests_attr || has_trace_tests) {
    return(TRUE)
  } else if (!has_r_dir_traces) {
    return(NA)
  } else {
    return(FALSE)
  }
}



#' Check that the coverage object retains testing information
#'
#' Check whether the coverage object has expected fields produced when coverage
#' was captured with \code{option(covr.record_tests = TRUE)}, throwing an error
#' if it was not.
#'
#' @param coverage a \code{\link[covr]{covr}} coverage object
#' @param warn Whether to warn when it is uncertain whether the tests were
#'   recorded. It may be uncertain if tests were recorded if there are no tested
#'   R code traces.
#' @return Used for side-effects of emitting an error when a coverage object
#'   does not contain recorded traces, or a warning when a coverage object
#'   appears to have no tests.
#'
#' @family coverage_tests
coverage_check_has_recorded_tests <- function(coverage, warn = TRUE) {
  has_recorded_tests <- coverage_has_recorded_tests(coverage)

  if (identical(has_recorded_tests, FALSE)) {
    stop(
      "Coverage object does not include recorded test information.\n\n",
      "  Expecting non-null `cov[[n]]$tests` for each trace\n\n",
      "  Ensure `options(covr.record_tests = TRUE)` was set during coverage ",
      "execution.\n\n"
    )
  } else if (warn && is.na(has_recorded_tests)) {
    warning(
      "Coverage object does not appear to contain traced R code, and ",
      "therefore has no logged test information."
    )
  }
}
