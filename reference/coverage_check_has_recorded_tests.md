# Check that the coverage object retains testing information

Check whether the coverage object has expected fields produced when
coverage was captured with `option(covr.record_tests = TRUE)`, throwing
an error if it was not.

## Usage

``` r
coverage_check_has_recorded_tests(coverage, warn = TRUE)
```

## Arguments

- coverage:

  a [`covr`](http://covr.r-lib.org/reference/covr-package.md) coverage
  object

- warn:

  Whether to warn when it is uncertain whether the tests were recorded.
  It may be uncertain if tests were recorded if there are no tested R
  code traces.

## Value

Used for side-effects of emitting an error when a coverage object does
not contain recorded traces, or a warning when a coverage object appears
to have no tests.

## See also

Other coverage_tests: [`coverage_get_tests()`](coverage_get_tests.md),
[`coverage_has_recorded_tests()`](coverage_has_recorded_tests.md)
