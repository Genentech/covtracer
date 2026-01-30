# Package index

## Mapping Tests to Documentation

The primary user-facing functionality provided by the package.

- [`test_trace_df()`](test_trace_df.md) : Build a traceability matrix
  that links documented behaviors to unit tests

## Working with `srcrefs`

Want to dig deeper? This functions will help you tease apart the
internals of package objects, documentation and tests.

- [`pkg_srcrefs()`](pkg_srcrefs.md) : Extract all the srcref objects of
  objects within a package namespace
- [`test_srcrefs()`](test_srcrefs.md) : Extract test srcref objects
- [`trace_srcrefs()`](trace_srcrefs.md) : Extract srcref objects from
  coverage object traces
- [`as.data.frame(`*`<list_of_srcref>`*`)`](as.data.frame.list_of_srcref.md)
  : Coerce a list_of_srcref object to a data.frame
- [`match_containing_srcrefs()`](match_containing_srcrefs.md) : Match
  srcrefs against srcrefs that contain them
- [`join_on_containing_srcrefs()`](join_on_containing_srcrefs.md) : Join
  srcref data.frames by intersection of srcref spans
- [`Rd_df()`](Rd_df.md) : Create a tabular representation of man file
  information

## Extracting Unit Test Descriptions

An extensible interface for extracting test information from test calls.

- [`test_description()`](test_description.md) : Parse a test description
  from the calling expression

## Miscellaneous Internals

Everthing that happens behind-the-scenes.

- [`Rd_df()`](Rd_df.md) : Create a tabular representation of man file
  information

- [`as.data.frame(`*`<list_of_srcref>`*`)`](as.data.frame.list_of_srcref.md)
  : Coerce a list_of_srcref object to a data.frame

- [`as.package()`](as.package.md) :

  A simple alternative to `devtools::as.package`

- [`as_list_of_srcref()`](as_list_of_srcref.md) : Create an S3 list of
  srcref objects

- [`as_test_desc()`](as_test_desc.md)
  [`as_testthat_desc()`](as_test_desc.md) : Wrap object in test
  description derivation data

- [`coverage_check_has_recorded_tests()`](coverage_check_has_recorded_tests.md)
  : Check that the coverage object retains testing information

- [`coverage_get_tests()`](coverage_get_tests.md) : Retrieve test traces
  from a coverage object

- [`coverage_has_recorded_tests()`](coverage_has_recorded_tests.md) :
  Test that the coverage object retains testing information

- [`expr_str()`](expr_str.md) : Convert an expression, call or symbol to
  a single-line string

- [`flat_map_srcrefs()`](flat_map_srcrefs.md) :

  Map `srcrefs` over an iterable object, Filtering non-srcref results

- [`format(`*`<list_of_srcref>`*`)`](format.list_of_srcref.md) : Format
  a list_of_srcref object

- [`getSrcFilepath()`](getSrcFilepath.md) : Get the full path to the
  srcref file

- [`get_namespace_object_names()`](get_namespace_object_names.md) : Get
  namespace exports, filtering methods tables and definitions

- [`is_srcref()`](is_srcref.md) :

  Test whether an object is a `srcref` object

- [`join_on_containing_srcrefs()`](join_on_containing_srcrefs.md) : Join
  srcref data.frames by intersection of srcref spans

- [`match_containing_srcrefs()`](match_containing_srcrefs.md) : Match
  srcrefs against srcrefs that contain them

- [`new_empty_test_trace_tally()`](new_empty_test_trace_tally.md) :
  Build an empty covr-style test trace mapping

- [`obj_namespace_name()`](obj_namespace_name.md) : Get namespace export
  namespace name

- [`package_check_has_keep_source()`](package_check_has_keep_source.md)
  : Verify that the package collection contains srcref information

- [`pkg_srcrefs()`](pkg_srcrefs.md) : Extract all the srcref objects of
  objects within a package namespace

- [`pkg_srcrefs_df()`](pkg_srcrefs_df.md) : Create a data.frame of
  package srcref objects

- [`srcref_expr()`](srcref_expr.md) : Parse the expression associated
  with a srcref

- [`srcref_str()`](srcref_str.md) : Convert a srcref into a string

- [`srcrefs()`](srcrefs.md) :

  Retrieve `srcref`s

- [`test_description()`](test_description.md) : Parse a test description
  from the calling expression

- [`test_description_test_that()`](test_description_test_that.md) :

  Parse the test description from a `test_that` call

- [`test_description_test_that_describe()`](test_description_test_that_describe.md)
  :

  Parse the test description from a `describe` call

- [`test_description_test_that_describe_it()`](test_description_test_that_describe_it.md)
  :

  Parse the test description from a `it` call

- [`test_srcrefs()`](test_srcrefs.md) : Extract test srcref objects

- [`test_srcrefs_df()`](test_srcrefs_df.md) : Create a data.frame of
  coverage test srcref objects

- [`test_trace_df()`](test_trace_df.md) : Build a traceability matrix
  that links documented behaviors to unit tests

- [`test_trace_mapping()`](test_trace_mapping.md) : Create a data.frame
  mapping tests to coverage traces

- [`trace_srcrefs()`](trace_srcrefs.md) : Extract srcref objects from
  coverage object traces

- [`trace_srcrefs_df()`](trace_srcrefs_df.md) : Create a data.frame of
  coverage trace srcref objects

- [`with_pseudo_srcref()`](with_pseudo_srcref.md) : For consistency,
  stub calls with srcref-like attributes
