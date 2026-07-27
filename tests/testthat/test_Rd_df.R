test_that("Rd_df can build a documentation data.frame from package path", {
  expect_silent(rddf <- Rd_df(system.file("examplepkg", package = "covtracer")))
  expect_true(any(rddf$is_exported))
  expect_true(any(!rddf$is_exported))
  expect_true(any(rddf$doctype == "class"))
  expect_true(any(rddf$doctype == "data"))
  expect_true(any(grepl("names,.*-method", rddf$alias)))
  expect_true(all(grepl("\\.Rd$", rddf$file)))
  expect_true(all(is.logical(rddf$is_traceable)))
})

test_that("Rd_df identifies S4 methods as traceable", {
  expect_silent(rddf <- Rd_df(system.file("examplepkg", package = "covtracer")))
  expect_false(anyNA(rddf$is_traceable))
  
  methods <- grepl("-method$", rddf$alias)
  expect_true(any(methods))
  expect_all_true(rddf$is_traceable[methods])
})
