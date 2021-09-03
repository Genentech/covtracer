test_that("test_description can build a test descriptions a call with a srcref", {
  # parsing from an expression with src file
  parse_content <- parse(file = file.path(test_path(), "test_test_description.R"), keep.source = TRUE)
  x_list <- getSrcref(parse_content)  # list of file expressions
  expect_equal(class(x_list), "list")
  x_srcref <- x_list[[1L]]  # first expression (this test)
  expect_s3_class(x_srcref, "srcref")
  expect_match(test_description(parse_content), "test_description can build")  # full expression
  expect_match(test_description(x_srcref), "\\[test_test_description.R#L1\\]")  # a single srcref
  expect_match(test_description(x_srcref), "test_that\\(\"test_description can build")  # a single srcref

  # parsing from an expression without src file
  parse_content <- parse(file = file.path(test_path(), "test_test_description.R"), keep.source = FALSE)
  expect_equal(getSrcref(parse_content), NULL)  # content without srcref
  expect_match(test_description(parse_content), "^[^[]")  # does not start with file name 
  expect_match(test_description(parse_content), "test_description can build")
})

test_that("test_description can extract test descriptions from a call stack containing a testthat call", {
  expr <- list(as.call(quote(test_that("example test", { }))))
  expect_equal(test_description(expr), "example test")
})

test_that("test_description can evaluate non-atomic test descriptions", {
  expr <- list(as.call(quote(test_that(paste("example test", "again"), { }))))
  expect_equal(test_description(expr), "example test again")
})

test_that("test_description handles errors while evaluating non-atomic test descriptions", {
  expr <- list(as.call(quote(test_that(1L + "test", { }))))
  expect_equal(test_description(expr), "1L + \"test\"")
})

test_that("test_description can extract test descriptions from a non-testthat call", {
  expr <- list(as.call(quote(testr("example test", { }))))
  expect_match(test_description(expr), "^testr\\(")
  expect_match(test_description(expr), "example test")
})

test_that("test_description safely handles non-standard input by returning NA", {
  expr <- NULL
  expect_equal(test_description(expr), NA_character_)
})

