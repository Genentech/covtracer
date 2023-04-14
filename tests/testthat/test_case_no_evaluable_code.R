test_that("Packages with no evaluable code produce empty traceability matrix without error (#20)", {
  expect_warning(no_evaluable_code_ttdf <- test_trace_df(no.evaluable.code_cov))
  expect_true(sum(!no_evaluable_code_ttdf$is_reexported) == 0L)
})
