# Changelog

## covtracer 0.0.2

- Fix [`test_trace_df()`](../reference/test_trace_df.md) when recorded
  tests were unable to discover `srcref`s
  ([\#78](https://github.com/genentech/covtracer/issues/78), 1)

- Szymon Maksymiuk is now a maintainer

## covtracer 0.0.1

CRAN release: 2024-07-08

- initial CRAN release

## covtracer 0.0.0.9000

- Fix handling for packages with no objects
  ([\#73](https://github.com/genentech/covtracer/issues/73), 1)

- Add handling for `testthat`’s `describe`-`it` syntax
  ([\#63](https://github.com/genentech/covtracer/issues/63), 1)

- Improve handling of non-function package object aliases
  ([\#61](https://github.com/genentech/covtracer/issues/61), 1)

- Improved support for S4 generic functions
  ([\#58](https://github.com/genentech/covtracer/issues/58),
  [\#59](https://github.com/genentech/covtracer/issues/59),
  [\#67](https://github.com/genentech/covtracer/issues/67), 1)

- Fix bug when producing a test-trace data.frame when package objects
  have an empty `srcfile`. This can happen when an object is documented,
  such as a `list`, which does not preserve a `srcref`
  ([\#51](https://github.com/genentech/covtracer/issues/51), 1)

- Minor changes to internal test matrix type to use `integer` instead of
  `numeric` (`double`), coinciding with changes to upstream `covr`.
  ([\#47](https://github.com/genentech/covtracer/issues/47), 1)

- Added column `type` to the result of `test_srcrefs_df` and thereby
  `test_type` to the result of `test_trace_df` to provide contextual
  information necessary for interpretting the test descriptions
  ([\#43](https://github.com/genentech/covtracer/issues/43), 1)

- Avoid parsing srcrefs when they’re only needed for producing a test
  description string, instead just jumping straight to coersion to
  string ([\#41](https://github.com/genentech/covtracer/issues/41),

  1.  

- Added safety fuse for extracting srcrefs of cyclic recursive
  environment nesting, terminating when beginning to recurse into an
  environment that has already been hit
  ([\#38](https://github.com/genentech/covtracer/issues/38),
  [@dkgf](https://github.com/dkgf))

- Now emit a warning when a coverage object does not include traces from
  any R code. This scenario may occur if a package only has reexports,
  or if it only calls out to C, in which cases it’s ambiguious whether
  test traces were captured.
  ([\#35](https://github.com/genentech/covtracer/issues/35), 1)

- Resolve edge-case bug where all nested namespace objects are without
  srcrefs ([\#33](https://github.com/genentech/covtracer/issues/33), 1)

- Resolve bug with reepxort methods S3 tables
  ([\#31](https://github.com/genentech/covtracer/issues/31), 1)

- Remove unnecessary recursion when searching for object’s namespace
  ([\#31](https://github.com/genentech/covtracer/issues/31), 1)

- Added test description handling for namespaced
  [`testthat::test_that`](https://testthat.r-lib.org/reference/test_that.html)
  calls.

- Updated to include field `is_reexported`, denoting whether the package
  object originates from a different namespace
  ([\#16](https://github.com/genentech/covtracer/issues/16), 1)

- Adding initial test-trace data.frame constructors (1)

- Skip classes not used for dispatch in `srcrefs.list`
  ([@maksymiuks](https://github.com/maksymiuks))

- Add symbols handling to `expr_str`
  ([@maksymiuks](https://github.com/maksymiuks))
