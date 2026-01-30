# Test that the coverage object retains testing information

Test whether the coverage object has expected fields produced when
coverage was captured with `option(covr.record_tests = TRUE)`.

## Usage

``` r
coverage_has_recorded_tests(coverage)
```

## Arguments

- coverage:

  a [`covr`](http://covr.r-lib.org/reference/covr-package.md) coverage
  object

## Value

A `logical` value, indicating whether the coverage object has recorded
tests, or `NA` when it does not appear to have traced any test code.

## See also

Other coverage_tests:
[`coverage_check_has_recorded_tests()`](coverage_check_has_recorded_tests.md),
[`coverage_get_tests()`](coverage_get_tests.md)
