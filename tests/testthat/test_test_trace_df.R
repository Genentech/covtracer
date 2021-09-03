test_that("test_trace_df produces a data.frame of test, trace and doc data", {
  expect_silent(ttdf <- test_trace_df(examplepkg_cov))
  expect_true(any(ttdf$is_exported))
  expect_true(any(!ttdf$is_exported))
  expect_true(any(duplicated(ttdf$test_name)))
  expect_true(any(duplicated(ttdf$file)))
  expect_true(any(gsub("\\.Rd$", "", ttdf$file) == ttdf$alias))
})
