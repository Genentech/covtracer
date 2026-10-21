test_that("test_trace_df links tests to every name sharing the same code", {
  ttdf <- test_trace_df(alias.fn_cov)

  tests_a <- ttdf$test_name[ttdf$alias %in% "a"]
  tests_b <- ttdf$test_name[ttdf$alias %in% "b"]
  expect_true(any(!is.na(tests_b)))
  expect_setequal(tests_a, tests_b)

  # each name keeps its own documentation
  expect_true(all(ttdf$file[ttdf$alias %in% c("a", "b")] == "b.Rd"))
})
