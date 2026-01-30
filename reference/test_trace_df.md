# Build a traceability matrix that links documented behaviors to unit tests

Intercept unit test coverage reports and process results to link
evaluated functions to the unit tests which trigger their evaluation. In
doing so, we can then link the associated function documentation of each
object to the tests that triggered their evaluation as a way of reusing
existing documentation to generate specifications.

## Usage

``` r
test_trace_df(x, ...)

# S3 method for class 'coverage'
test_trace_df(
  x,
  ...,
  pkg = as.package(attr(x, "package")$path),
  aggregate_by = sum
)
```

## Arguments

- x:

  A package object, name, source code path or coverage result to use as
  the bases of tracing tests. Coverage results must have been produced
  using `options(covr.record_tests = TRUE)`.

- ...:

  Additional arguments unused

- pkg:

  A `package` object as produced by `as.package`, if a specific package
  object is to be used for inspecting the package namespace.

- aggregate_by:

  `NULL` or a function by which to aggregate recurring hits `counts` and
  `direct` columns from a test to a trace. If `NULL`, no aggregation
  will be applied. (Default `sum`)

## Value

A `data.frame` of tests and corresponding traces
