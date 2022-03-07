test_that("hypotenuse is calculated correctly", {
  expect_equal(reexport_hypotenuse(3, 4), 5)

  test_that("with negative lengths", {
    expect_equal(reexport_hypotenuse(-3, -4), 5)
  })
})
