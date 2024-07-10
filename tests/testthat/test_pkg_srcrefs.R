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
})

test_that("pkg_srcrefs distinguish namespaces of reexported object srcrefs", {
  skip_on_cran()
  expect_s3_class(srcs <- pkg_srcrefs(reexport.srcref_ns), "list_of_srcref")
  expect_true("examplepkg" %in% lapply(srcs, attr, "namespace"))
})

test_that("pkg_srcrefs names of list objects track originating srcrefs", {
  expect_silent(list.obj_srcs <- pkg_srcrefs(list.obj_ns))
  expect_true("fn" %in% names(list.obj_srcs))
  expect_true(!"obj_fn" %in% names(list.obj_srcs))
})
