test_that("test_description can build a test descriptions a call with a srcref", {
  # parsing from an expression with src file
  parse_content <- parse(file = file.path(test_path(), "test_test_description.R"), keep.source = TRUE)
  x_list <- getSrcref(parse_content) # list of file expressions
  expect_equal(class(x_list), "list")
  x_srcref <- x_list[[1L]] # first expression (this test)
  expect_s3_class(x_srcref, "srcref")
  expect_match(test_description(parse_content), "test_description can build") # full expression
  expect_match(test_description(x_srcref), "\\[test_test_description.R#L\\d+\\]") # a single srcref
  expect_match(test_description(x_srcref), "test_that\\(\"test_description can build") # a single srcref

  # parsing from an expression without src file
  parse_content <- parse(file = file.path(test_path(), "test_test_description.R"), keep.source = FALSE)
  expect_equal(getSrcref(parse_content), NULL) # content without srcref
  expect_match(test_description(parse_content), "^[^[]") # does not start with file name
  expect_match(test_description(parse_content), "test_description can build")
})

# leave `testthat::` - used for this test
testthat::test_that("test_description can build a test description from testthat::test_that call", {
  # parsing from an expression with src file
  parse_content <- parse(file = file.path(test_path(), "test_test_description.R"), keep.source = TRUE)
  expr <- list(parse_content[[2L]]) # this test expression
  expect_match(test_description(expr), "^test_description can build a test")
})

test_that("test_description can extract test descriptions from a call stack containing a testthat call", {
  expr <- list(as.call(quote(test_that("example test", { }))))
  expect_equal(as.character(test_description(expr)), "example test")
  expect_equal(attr(test_description(expr), "type"), "testthat")
})

test_that("test_description can evaluate non-atomic test descriptions", {
  expr <- list(as.call(quote(test_that(paste("example test", "again"), { }))))
  expect_equal(as.character(test_description(expr)), "example test again")
  expect_equal(attr(test_description(expr), "type"), "testthat")
})

test_that("test_description handles errors while evaluating non-atomic test descriptions", {
  expr <- list(as.call(quote(test_that(1L + "test", { }))))
  expect_equal(as.character(test_description(expr)), "1L + \"test\"")
  expect_equal(attr(test_description(expr), "type"), "testthat")
})

test_that("test_description can extract test descriptions from a non-testthat call", {
  expr <- list(as.call(quote(testr("example test", { }))))
  expect_match(test_description(expr), "^testr\\(")
  expect_match(test_description(expr), "example test")
  expect_equal(attr(test_description(expr), "type"), "call")
})

test_that("test_description safely handles non-standard input by returning NA", {
  expr <- NULL
  expect_equal(test_description(expr), NA_character_)
  expect_null(attr(test_description(expr), "type"))
})

test_that("test_description can extract testthat describe-it style test descriptions", {
  n_calls <- length(sys.calls())
  log_call_stack <- function() utils::head(utils::tail(sys.calls(), -n_calls), -1L)

  # mock `describe` and `it` to spoof a captured call stack
  describe <- function(desc, expr) eval(expr)
  it <- function(desc, expr) eval(expr)

  # clean up our mocked versions of these functions on test completion
  withr::defer(rm(list = c("describe", "it")))

  # base case, single describe-it
  call_stack <- describe("abc", {
    it("does the thing", log_call_stack())
  })

  expect_silent(desc <- test_description(call_stack))
  expect_s3_class(desc, "test_description")
  expect_equal(as.character(desc), "abc: does the thing")
  expect_equal(attr(desc, "type"), "testthat")

  # add outer wrapping function, multiple describe calls
  call_stack <- with(list(), {
    describe("abc", {
      describe("def", {
        it("ghi", log_call_stack())
      })
    })
  })

  expect_silent(desc <- test_description(call_stack))
  expect_s3_class(desc, "test_description")
  expect_equal(as.character(desc), "abc: def: ghi")
  expect_equal(attr(desc, "type"), "testthat")

  # even if using bdd in unorthodox way, we want reasonable test names
  call_stack <- describe("abc", {
    it("does the thing", {
      describe("... and this behavior", {
        it("does another thing", log_call_stack())
      })
    })
  })

  expect_silent(desc <- test_description(call_stack))
  expect_s3_class(desc, "test_description")
  expect_equal(as.character(desc), "abc: does the thing: ... and this behavior: does another thing")
  expect_equal(attr(desc, "type"), "testthat")
})

test_that("test descriptions can be extracted from implicit generic calls", {
  # expect that we have a test for a standardGeneric
  expect_silent({
    s4generic_test <- Find(
      function(i) class(i[[1]][[1]]) == "standardGeneric",
      attr(examplepkg_cov, "tests")
    )

    s4generic_test_desc <- test_description(s4generic_test)
  })

  # for reasons unknown, a call stack originating from an S4 generic call is not
  # found on R-devel image actions
  skip_if(is.null(s4generic_test), "S4 standardGeneric not found.")

  expect_equal(attr(s4generic_test_desc, "type"), "call")
  expect_equal(as.character(s4generic_test_desc), "S4 Generic Call: show(<myS4Example>)")
})
