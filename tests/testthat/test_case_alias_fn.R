test_that("test_trace_df links tests to every name sharing the same code", {
  ttdf <- test_trace_df(alias.fn_cov)

  tests_a <- ttdf$test_name[ttdf$alias %in% "a"]
  tests_b <- ttdf$test_name[ttdf$alias %in% "b"]
  tests_v <- ttdf$test_name[ttdf$alias %in% "v"]
  tests_b1 <- ttdf$test_name[ttdf$alias %in% "b1"]
  expect_true(any(!is.na(tests_b)))
  expect_setequal(tests_a, tests_b)
  expect_setequal(tests_v, tests_b)
  expect_setequal(tests_b1, tests_b)

  # each name keeps its own documentation
  expect_true(all(ttdf$file[ttdf$alias %in% c("a", "b", "v", "b1")] == "b.Rd"))
})

test_that("pkg_srcrefs gives a wrapper the srcref of the function it wraps", {
  srcs <- pkg_srcrefs(alias.fn_ns)

  expect_true("v" %in% names(srcs))
  expect_identical(
    srcref_span_key(srcs[names(srcs) == "v"]),
    srcref_span_key(srcs[names(srcs) == "b"])
  )
  expect_identical(attr(srcs$v, "namespace"), "alias.fn")
})

test_that("pkg_srcrefs gives a copied function the srcref of the original", {
  srcs <- pkg_srcrefs(alias.fn_ns)

  expect_true("b1" %in% names(srcs))
  expect_identical(
    srcref_span_key(srcs[names(srcs) == "b1"]),
    srcref_span_key(srcs[names(srcs) == "b"])
  )
  expect_identical(attr(srcs$b1, "namespace"), "alias.fn")
})
