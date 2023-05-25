test_that("S4Example names method works", {
  expect_silent(s4ex <- S4Example(data = list(a = 1, b = 2)))
  expect_equal(names(s4ex), c("a", "b"))
})

test_that("S4Example increment generic method works", {
  expect_equal(increment(1), 2)
})