test_that("get_namespace_object_names filters hidden method and class tables", {
  ex <- getNamespaceExports(examplepkg_ns)
  expect_true(any(grepl("^.__T__", ex)))
  expect_true(any(grepl("^.__C__", ex)))
  expect_true(!any(grepl("^.__T__", get_namespace_object_names(examplepkg_ns))))
  expect_true(!any(grepl("^.__C__", get_namespace_object_names(examplepkg_ns))))
  expect_equal(
    length(get_namespace_object_names(examplepkg_ns)),
    length(ex) - sum(grepl("^\\.__(T|C)__", ex))
  )
})

test_that("obj_namespace_name extracts reexport namespace names", {
  ex <- getNamespaceExports(examplepkg_ns)
  names(ex) <- ex
  ns_names <- lapply(ex, obj_namespace_name, ns = "examplepkg")
  expect_equal(ns_names[["help"]], "utils")
  expect_equal(ns_names[["reexport_example"]], "utils")
  expect_equal(ns_names[["hypotenuse"]], "examplepkg")
})
