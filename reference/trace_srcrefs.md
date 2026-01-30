# Extract srcref objects from coverage object traces

Extract srcref objects from coverage object traces

## Usage

``` r
trace_srcrefs(x)

# S3 method for class 'coverage'
trace_srcrefs(x)
```

## Arguments

- x:

  (`link[covr]{package_coverage}`) A
  [`covr`](http://covr.r-lib.org/reference/covr-package.md) coverage
  object produced with `options(covr.record_tests = TRUE)`.

## Value

A `list_of_srcref`

## See also

as.data.frame.list_of_srcref

Other srcrefs: [`pkg_srcrefs()`](pkg_srcrefs.md),
[`test_srcrefs()`](test_srcrefs.md)
