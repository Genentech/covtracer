test_that("Direct aliases take precedence over indirect", {
  aliases <- traceable_aliases(
    "examplepkg", examplepkg_ns
  )

  # Direct alias
  expect_true(is_alias_traceable("rd_sampler", examplepkg_ns, aliases))

  # Direct alias for data object
  expect_false(is_alias_traceable("rd_sampler_data", examplepkg_ns, aliases))

  # Indirect alias resolved with list of aliases
  expect_true(
    is_alias_traceable("names,S4Example-method", examplepkg_ns, aliases)
  )

  # Unresolved objects are not traceable
  expect_false(is_alias_traceable("nonexistent", examplepkg_ns, aliases))
})

test_that("S4 class documentation resolved to namespece binding", {
  aliases <- traceable_aliases(
    "examplepkg", examplepkg_ns
  )

  expect_false(
    exists("S4Example-class", envir = examplepkg_ns, inherits = FALSE)
  )
  expect_true(
    exists("S4Example", envir = examplepkg_ns, inherits = FALSE)
  )

  expect_true(
    is_alias_traceable("S4Example-class", examplepkg_ns, aliases)
  )

  # S4 generic are traceable
  expect_true(
    is_alias_traceable("increment", examplepkg_ns, aliases)
  )
})

test_that("is_covr_traceable recognizes regular functions", {
  expect_true(is_covr_traceable(function() NULL))
  expect_false(is_covr_traceable(base::sum))
  expect_false(is_covr_traceable(list()))
  expect_false(is_covr_traceable(c()))
  expect_false(is_covr_traceable(data.frame()))
})

test_that("is_covr_traceable recognizes covr supported containers", {
  expect_true(
    is_covr_traceable(structure(list(), class = "R6ClassGenerator"))
  )
  expect_true(
    is_covr_traceable(structure(list(), class = "refObjectGenerator"))
  )
  expect_true(
    is_covr_traceable(structure(list(), class = "S7_generic"))
  )
  expect_true(
    is_covr_traceable(structure(list(), class = "S7_class"))
  )
  expect_true(
    is_covr_traceable(structure(list(), spec = structure(
      list(), class = "box$mod_spec"
    )))
  )
})
