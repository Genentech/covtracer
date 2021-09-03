test_that("pkg_srcrefs builds a list_of_srcref of a package namespace", {
  expect_s3_class(srcs <- pkg_srcrefs(examplepkg_ns), "list_of_srcref")
  expect_true(length(srcs) > 5L)
  expect_true(all(lapply(srcs, class) == "srcref"))
  expect_s3_class(as.data.frame(srcs), "data.frame")
})

test_that("pkg_srcrefs builds a list_of_srcref of a package namespace name", {
  expect_s3_class(srcs <- pkg_srcrefs("examplepkg"), "list_of_srcref")
  expect_true(length(srcs) > 5L)
  expect_true(all(lapply(srcs, class) == "srcref"))
  expect_s3_class(as.data.frame(srcs), "data.frame")
})

test_that("pkg_srcrefs builds a list_of_srcref of a coverage object", {
  expect_s3_class(srcs <- pkg_srcrefs(examplepkg_cov), "list_of_srcref")
  expect_true(length(srcs) > 5L)
  expect_true(all(lapply(srcs, class) == "srcref"))
  expect_s3_class(as.data.frame(srcs), "data.frame")
})
