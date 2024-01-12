test_that("Packages with no exports produce empty traceability matrix without error (#73)", {
  expect_warning(no_exports_ttdf <- test_trace_df(no.exports_cov))
  expect_true(sum(!no_exports_ttdf$is_reexported) == 0L)
})
