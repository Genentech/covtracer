test_that("Packages with no evaluable code produce empty traceability matrix without error (#20)", {
  expect_silent(no_evaluable_code_ttdf <- test_trace_df(no_evaluable_code_pkg_cov))
  expect_true(sum(!no_evaluable_code_ttdf$is_reexported) == 0L)
})
