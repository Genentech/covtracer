test_that("pkg_srcrefs builds a list_of_srcref of a package namespace", {
  expect_s3_class(srcs <- pkg_srcrefs(examplepkg_ns), "list_of_srcref")
  expect_true(length(srcs) > 5L)
  expect_true(length(srcs[!is.na(srcs)]) > 5L)
  expect_true(length(srcs[is.na(srcs)]) > 0L)
  expect_true(all(lapply(srcs[!is.na(srcs)], class) == "srcref"))
  expect_s3_class(as.data.frame(srcs), "data.frame")
})

test_that("pkg_srcrefs builds a list_of_srcref of a package namespace name", {
  expect_s3_class(srcs <- pkg_srcrefs("examplepkg"), "list_of_srcref")
  expect_true(length(srcs) > 5L)
  expect_true(all(lapply(srcs[!is.na(srcs)], class) == "srcref"))
  expect_s3_class(as.data.frame(srcs), "data.frame")
})

test_that("pkg_srcrefs builds a list_of_srcref of a coverage object", {
  expect_s3_class(srcs <- pkg_srcrefs(examplepkg_cov), "list_of_srcref")
  expect_true(length(srcs) > 5L)
  expect_true(all(lapply(srcs[!is.na(srcs)], class) == "srcref"))
  expect_s3_class(as.data.frame(srcs), "data.frame")
})

test_that("pkg_srcrefs discovers namespace of package objects", {
  expect_s3_class(srcs <- pkg_srcrefs(examplepkg_cov), "list_of_srcref")
  expect_true("examplepkg" %in% lapply(srcs, attr, "namespace"))

  # reexport from utils, without assignment
  expect_true(is.null(attr(srcs$help, "namespace")))

  # reexport from utils, with assignment to a new name
  expect_true(is.null(attr(srcs$reexport_example, "namespace")))

  # reexport from utils with a `NULL` object
  expect_true(is.null(attr(srcs$person, "namespace")))

  # reexport from a package which also has srcrefs available
  skip_if_not(is_srcref(srcs$reexport_pkg_srcrefs), paste0(
    "`examplepkg` must be built after `covtracer` is installed with ",
    "options(keep.source = TRUE) to test reexported functions with source."
  ))

  expect_true(attr(srcs$reexport_pkg_srcrefs, "namespace") == "covtracer")
})
