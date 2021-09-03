test_that("get_namespace_object_names filters hidden method and class tables", {
  ex <- getNamespaceExports(examplepkg_ns)
  expect_true(any(grepl("^.__T__", ex)))
  expect_true(!any(grepl("^.__T__", get_namespace_object_names(examplepkg_ns))))
  expect_true(length(get_namespace_object_names(examplepkg_ns)) == length(ex) - sum(grepl("^.__T__", ex)))
})
