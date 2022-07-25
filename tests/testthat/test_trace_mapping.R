test_that("test trace mapping", {
  cases <- list(
    "combines coverage trace matrices" = examplepkg_cov,
    "produces a matrix from a single trace" = examplepkg_cov[1L],
    "produces an empty matrix from no traces" = examplepkg_cov[c()]
  )

  expect_true(all(vapply(cases, inherits, logical(1L), "coverage")))

  for (i in seq_along(cases)) {
    expect_true(nchar(names(cases)[[i]]) > 0L)
    test_that(names(cases)[[i]], {
      cov_data <- cases[[i]]
      expect_silent(ttmat <- test_trace_mapping(cov_data))
      expect_type(ttmat, "integer")
      expect_true(length(dim(ttmat)) == 2L)
      expect_true(ncol(ttmat) == ncol(examplepkg_cov[[1L]]$tests) + 1L)
      expect_true(all(colnames(ttmat) == c(colnames(examplepkg_cov[[1L]]$tests), "trace")))
    })
  }
})
