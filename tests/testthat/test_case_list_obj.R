test_that("A list containint a function is not traceable", {
  aliases <- traceable_aliases(
    "list.obj", list.obj_ns
  )

  expect_true(is_alias_traceable("fn", list.obj_ns, aliases))

  expect_true("objs" %in% aliases)
  expect_false(is_alias_traceable("objs", list.obj_ns, aliases))
})
