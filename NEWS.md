# Unreleased (tentative 0.0.1)

* Now emit a warning when a coverage object does not include traces from any R
  code. This scenario may occur if a package only has reexports, or if it only
  calls out to C, in which cases it's ambiguious whether test traces were
  captured. (#35, @dgkf)

* Resolve bug with reepxort methods S3 tables (#31, @dgkf)

* Remove unnecessary recursion when searching for object's namespace (#31, @dgkf)

* Added test description handling for namespaced `testthat::test_that` calls.

* Updated to include field `is_reexported`, denoting whether the package object
  originates from a different namespace (#16, @dgkf)

* Adding initial test-trace data.frame constructors (@dgkf)

