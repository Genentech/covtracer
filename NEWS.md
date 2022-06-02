# Unreleased (tentative 0.0.1)

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

