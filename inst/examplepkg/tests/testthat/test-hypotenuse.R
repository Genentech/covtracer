test_that("hypotenuse is calculated correctly", {
  expect_equal(hypotenuse(3, 4), 5)

  test_that("with negative lengths", {
    expect_equal(hypotenuse(-3, -4), 5)  
  })
})
