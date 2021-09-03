test_that("Example R6 Accumulator class constructor is traced", {
  expect_silent(acc <- Accumulator$new(3L))  
  expect_true(acc$sum == 3L)
})

test_that("Example R6 Accumulator class methods are traced", {
  expect_silent(acc <- Accumulator$new(3L))  
  expect_true(acc$add(3L)$sum == 6L)
})

test_that("Example R6 Person class public methods are traced", {
  expect_silent(p <- Person$new("Doug"))  
  expect_output(p$print())
})

test_that("Example R6 Rando class active field functions are traced", {
  expect_silent(rand <- Rando$new())  
  expect_true(is.numeric(rand$random))
})
