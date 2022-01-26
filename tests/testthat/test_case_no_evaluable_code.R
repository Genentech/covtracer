test_that("Packages with no evaluable code produce empty traceability matrix without error (#20)", {
  expect_silent(no_evaluable_code_ttdf <- covtracer::test_trace_df(no_evaluable_code_pkg_cov))
  expect_true(nrow(no_evaluable_code_ttdf) == 0L)
})
