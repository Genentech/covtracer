test_that("s3_example_func works using default dispatch", {
  expect_equal(s3_example_func(1L), "default")  
})

test_that("s3_example_func works using list dispatch", {
  expect_equal(s3_example_func(list(1, 2, 3)), "list")  
})
