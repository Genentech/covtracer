test_that("match_containing_srcrefs matches tests to appropriate code by file", {
  traces <- trace_srcrefs_df(examplepkg_cov)
  pkgsrcs <- pkg_srcrefs_df("examplepkg")

  expect_silent(m <- match_containing_srcrefs(traces$srcref, pkgsrcs$srcref))

  # match all the example code, and ensure that the trace srcrefs individually
  # fall within the matched srcref from the package
  expect_true(all(mapply(
    traces$srcref,
    pkgsrcs$srcref[m],
    FUN = function(trace, pkgsrc) {
      trace_beg_line <- getSrcLocation(trace, "line", first = TRUE)
      trace_beg_byte <- getSrcLocation(trace, "byte", first = TRUE)
      trace_end_line <- getSrcLocation(trace, "line", first = FALSE)
      trace_end_byte <- getSrcLocation(trace, "byte", first = FALSE)

      pkgsrc_beg_line <- getSrcLocation(pkgsrc, "line", first = TRUE)
      pkgsrc_beg_byte <- getSrcLocation(pkgsrc, "byte", first = TRUE)
      pkgsrc_end_line <- getSrcLocation(pkgsrc, "line", first = FALSE)
      pkgsrc_end_byte <- getSrcLocation(pkgsrc, "byte", first = FALSE)

      # trace begins at or after beginning of srcref region
      (trace_beg_line > pkgsrc_beg_line ||
        trace_beg_line == pkgsrc_beg_line && trace_beg_byte >= pkgsrc_beg_byte) &&

        # and trace ends at or before end of srcref region
        (trace_end_line < pkgsrc_end_line ||
          trace_end_line == pkgsrc_end_line && trace_end_byte <= pkgsrc_end_byte)
    }
  )))
})

test_that("match_containing_srcrefs matches tests even when some objects have no srcrefs", {
  # may be the case for reexports from packages built --without-keep.source"

  traces <- as_list_of_srcref.list(list(
    "a" = srcref(srcfile = srcfile("a"), c(1, 0, 1, 10, 0, 10, 0, 0)), # from a file not in the package
    "c" = srcref(srcfile = srcfile("c"), c(2, 0, 2, 10, 0, 10, 0, 0))
  ))

  # spoof a package with missing srcrefs
  pkgsrcs <- as_list_of_srcref.list(list(
    NA,
    "b" = srcref(srcfile = srcfile("b"), c(1, 0, 1, 10, 0, 10, 0, 0)),
    "c" = srcref(srcfile = srcfile("c"), c(1, 0, 3, 1, 0, 1, 0, 0)),
    NA
  ))

  expect_silent(m <- match_containing_srcrefs(traces, pkgsrcs))
  expect_equal(m, c(NA, 3))
})
