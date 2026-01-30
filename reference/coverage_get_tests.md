# Retrieve test traces from a coverage object

Assumes the coverage object was produced while
`option(covr.record_tests = TRUE)`.

## Usage

``` r
coverage_get_tests(coverage)
```

## Arguments

- coverage:

  a [`covr`](http://covr.r-lib.org/reference/covr-package.md) coverage
  object

## Value

A `list` of tests evaluated when using `covr`

## See also

Other coverage_tests:
[`coverage_check_has_recorded_tests()`](coverage_check_has_recorded_tests.md),
[`coverage_has_recorded_tests()`](coverage_has_recorded_tests.md)
