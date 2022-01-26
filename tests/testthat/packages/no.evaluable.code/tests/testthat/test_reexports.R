test_that("reexports make it into package namespace.", {
  expect_true("person" %in% getNamespaceExports("no.evaluable.code"))
})
