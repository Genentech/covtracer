# covtracer 0.0.1

* initial CRAN release

# covtracer 0.0.0.9000

* Fix handling for packages with no objects (#73, @dgkf)

* Add handling for `testthat`'s `describe`-`it` syntax (#63, @dgkf)

* Improve handling of non-function package object aliases (#61, @dgkf)

* Improved support for S4 generic functions (#58, #59, #67, @dgkf)

* Fix bug when producing a test-trace data.frame when package objects have an
  empty `srcfile`. This can happen when an object is documented, such as a
  `list`, which does not preserve a `srcref` (#51, @dgkf)

* Minor changes to internal test matrix type to use `integer` instead of
  `numeric` (`double`), coinciding with changes to upstream `covr`. (#47, @dgkf)

* Added column `type` to the result of `test_srcrefs_df` and thereby `test_type`
  to the result of `test_trace_df` to provide contextual information necessary
  for interpretting the test descriptions (#43, @dgkf)

* Avoid parsing srcrefs when they're only needed for producing a test
  description string, instead just jumping straight to coersion to string (#41,
  @dgkf)

* Added safety fuse for extracting srcrefs of cyclic recursive environment
  nesting, terminating when beginning to recurse into an environment that has
  already been hit (#38, @dkgf)

* Now emit a warning when a coverage object does not include traces from any R
  code. This scenario may occur if a package only has reexports, or if it only
  calls out to C, in which cases it's ambiguious whether test traces were
  captured. (#35, @dgkf)

* Resolve edge-case bug where all nested namespace objects are without srcrefs
  (#33, @dgkf)

* Resolve bug with reepxort methods S3 tables (#31, @dgkf)

* Remove unnecessary recursion when searching for object's namespace (#31, @dgkf)

* Added test description handling for namespaced `testthat::test_that` calls.

* Updated to include field `is_reexported`, denoting whether the package object
  originates from a different namespace (#16, @dgkf)

* Adding initial test-trace data.frame constructors (@dgkf)

* Skip classes not used for dispatch in `srcrefs.list` (@maksymiuks)

* Add symbols handling to `expr_str` (@maksymiuks)
