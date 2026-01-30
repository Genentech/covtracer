# Create a data.frame of coverage test srcref objects

Extract unit test `srcref`s from a
[`coverage`](http://covr.r-lib.org/reference/package_coverage.md)
object. A test name will be derived from the test source code,
preferrably from a written annotation, but otherwise falling back to
using a code snippet. `srcrefs` are unique for each expression executed
within a testing suite.

## Usage

``` r
test_srcrefs_df(x)
```

## Arguments

- x:

  A
  [`package_coverage`](http://covr.r-lib.org/reference/package_coverage.md)
  coverage object, from which the name of the package used is extracted.

## Value

A `data.frame` of test `srcrefs` extracted from a `coverage` object.
Contains one record for each `srcref` with variables:

- name:

  A `character` test description. For `testthat` tests, the `desc`
  parameter will be used, otherwise a snippet of code will be used for
  the test name

- srcref:

  A `srcref` object describing the location of the test

- test_type:

  A `character` indicating the structure of the test. One of
  `"testthat"`, `"call"` or `NULL`

## See also

srcrefs test_trace_mapping

Other srcrefs_df: [`pkg_srcrefs_df()`](pkg_srcrefs_df.md),
[`trace_srcrefs_df()`](trace_srcrefs_df.md)

## Examples

``` r
options(covr.record_tests = TRUE)
pkg_path <- system.file("examplepkg", package = "covtracer")
cov <- covr::package_coverage(pkg_path)
test_srcrefs_df(cov)
#>                                                         name
#> 1                       S4 Generic Call: show(<myS4Example>)
#> 2               Calling a deeply nested series of functions.
#> 3             Calling a function halfway through call stack.
#> 4                                               symbol: desc
#> 5                         hypotenuse is calculated correctly
#> 6  hypotenuse is calculated correctly; with negative lengths
#> 7         Example R6 Accumulator class constructor is traced
#> 8            Example R6 Accumulator class methods are traced
#> 9            Example R6 Accumulator class methods are traced
#> 10         Example R6 Person class public methods are traced
#> 11         Example R6 Person class public methods are traced
#> 12  Example R6 Rando class active field functions are traced
#> 13              s3_example_func works using default dispatch
#> 14                 s3_example_func works using list dispatch
#> 15                              S4Example names method works
#> 16                  S4Example increment generic method works
#>                             srcref     type
#> 1                             <NA>     call
#> 2    test-complex-calls.R:2:3:2:50 testthat
#> 3    test-complex-calls.R:6:3:6:54 testthat
#> 4  test-complex-calls.R:15:7:15:54 testthat
#> 5       test-hypotenuse.R:2:3:2:35 testthat
#> 6       test-hypotenuse.R:5:5:5:39 testthat
#> 7       test-r6-example.R:2:3:2:43 testthat
#> 8       test-r6-example.R:7:3:7:43 testthat
#> 9       test-r6-example.R:8:3:8:36 testthat
#> 10    test-r6-example.R:12:3:12:40 testthat
#> 11    test-r6-example.R:13:3:13:26 testthat
#> 12    test-r6-example.R:18:3:18:38 testthat
#> 13      test-s3-example.R:2:3:2:46 testthat
#> 14      test-s3-example.R:6:3:6:54 testthat
#> 15      test-s4-example.R:3:3:3:40 testthat
#> 16      test-s4-example.R:7:3:7:31 testthat
```
