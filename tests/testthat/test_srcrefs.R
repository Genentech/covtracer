test_that("srcrefs accepts a package namespace", {
  expect_silent(srcs <- srcrefs(examplepkg_ns))
  expect_true(length(srcs) > 5L)
  expect_true(all(vapply(srcs, class, character(1L)) == "srcref"))
})


test_that("srcrefs accepts an environment", {
  env <- new.env(parent = emptyenv())
  env$a <- env$b <- examplepkg_ns$hypotenuse
  expect_silent(srcs <- srcrefs(env))
  expect_true(length(srcs) == 2L)
  expect_true(all(names(srcs) == c("a", "b")))
  expect_true(all(vapply(srcs, class, character(1L)) == "srcref"))
})


test_that("srcrefs can process S4 methods tables", {
  # extract S3 methods tables and class definitions
  s3_objs <- as.list(examplepkg_ns, all.names = TRUE)
  s3_objs_env <- as.environment(s3_objs[grepl("^.__(T|C)__", names(s3_objs))])

  expect_silent(srcs <- srcrefs(s3_objs_env))
  expect_true(length(srcs) > 1L)

  # expect that the names are reflective of Rd names
  expect_true("names,S4Example-method" %in% names(srcs))
  expect_true(all(vapply(srcs, class, character(1L)) == "srcref"))
})


test_that("srcrefs can process R6 public class methods & fields", {
  # extract Accumulator R6 object, which contains top level public methods & fields
  objs <- as.list(examplepkg_ns, all.names = TRUE)
  expect_true("Accumulator" %in% names(objs))
  r6_objs_env <- as.environment(objs["Accumulator"])

  expect_silent(srcs <- srcrefs(r6_objs_env))
  expect_true(length(srcs) > 0L)

  # expect that all methods have been picked up in srcrefs
  expect_true(any(grepl("# Accumulator\\$initialize", capture.output(srcs))))
  expect_true(any(grepl("# Accumulator\\$add", capture.output(srcs))))

  # expect that the names are reflective of R6 class Rd name
  expect_true(all(names(srcs) == "Accumulator"))
  expect_true(all(vapply(srcs, class, character(1L)) == "srcref"))
})


test_that("srcrefs can process R6 private class methods & fields", {
  # extract Accumulator R6 object, which contains top level public methods & fields
  objs <- as.list(examplepkg_ns, all.names = TRUE)
  expect_true("Person" %in% names(objs))
  r6_objs_env <- as.environment(objs["Person"])

  expect_silent(srcs <- srcrefs(r6_objs_env))
  expect_true(length(srcs) > 0L)

  # expect that all methods have been picked up in srcrefs
  expect_true(any(grepl("# Person\\$initialize", capture.output(srcs))))
  expect_true(any(grepl("# Person\\$print", capture.output(srcs))))

  # expect that the names are reflective of R6 class Rd name
  expect_true(all(names(srcs) == "Person"))
  expect_true(all(vapply(srcs, class, character(1L)) == "srcref"))
})


test_that("srcrefs can process R6 active fields", {
  # extract Accumulator R6 object, which contains top level public methods & fields
  objs <- as.list(examplepkg_ns, all.names = TRUE)
  expect_true("Rando" %in% names(objs))
  r6_objs_env <- as.environment(objs["Rando"])

  expect_silent(srcs <- srcrefs(r6_objs_env))
  expect_true(length(srcs) > 0L)

  # expect that all methods have been picked up in srcrefs
  expect_true(any(grepl("# Rando\\$random", capture.output(srcs))))

  # expect that the names are reflective of R6 class Rd name
  expect_true(all(names(srcs) == "Rando"))
  expect_true(all(vapply(srcs, class, character(1L)) == "srcref"))
})


test_that("srcrefs return lists uses names which can be linked to object docs", {
  srcs <- srcrefs(examplepkg_ns)
  srcnames <- names(as.list(srcs))
  aliases <- unlist(lapply(tools::Rd_db("examplepkg"), tools:::.Rd_get_metadata, "alias"))

  # most object names should be retained (some class objects may not)
  expect_true(any(names(srcs) %in% names(as.list(getNamespace("examplepkg")))))

  # all objects should map to a documented alias (only true if methods redirect to generic)
  expect_true(all(names(srcs) %in% aliases))
})

test_that("srcrefs does not recursve into self-referential envs", {
  env <- new.env()
  env$self <- env
  env$fn <- function(a = 1) {
    print(a)
  }
  expect_length(names(srcrefs(env)), 1L)
})
