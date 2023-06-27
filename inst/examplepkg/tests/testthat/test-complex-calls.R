test_that("Calling a deeply nested series of functions.", {
  expect_equal(complex_call_stack("test"), "test")
})

test_that("Calling a function halfway through call stack.", {
  expect_equal(deeper_nested_function("test"), "test")
})

local({
  descriptions <- as.character(1:10)
  for (i in seq_along(descriptions)) {
    desc <- descriptions[i]
    
    test_that(desc, {
      expect_equal(complex_call_stack("test"), "test")
    })
  }
})