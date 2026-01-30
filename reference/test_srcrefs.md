# Extract test srcref objects

Extract test srcref objects

## Usage

``` r
test_srcrefs(x)

# S3 method for class 'coverage'
test_srcrefs(x)
```

## Arguments

- x:

  A
  [`package_coverage`](http://covr.r-lib.org/reference/package_coverage.md)
  coverage object, from which the test `srcref`s are extracted.

## Value

A `list_of_srcref`

## See also

as.data.frame.list_of_srcref

Other srcrefs: [`pkg_srcrefs()`](pkg_srcrefs.md),
[`trace_srcrefs()`](trace_srcrefs.md)

## Examples

``` r
options(covr.record_tests = TRUE)
pkg_path <- system.file("examplepkg", package = "covtracer")
cov <- covr::package_coverage(pkg_path)
test_srcrefs(cov)
#> [[1]]
#> show(<myS4Example>)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-complex-calls.R:2:3:2:50:3:50:2:2`
#> complex_call_stack("test")
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-complex-calls.R:6:3:6:54:3:54:6:6`
#> deeper_nested_function("test")
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-complex-calls.R:15:7:15:54:7:54:15:15`
#> complex_call_stack("test")
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-hypotenuse.R:2:3:2:35:3:35:2:2`
#> hypotenuse(3, 4)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-hypotenuse.R:5:5:5:39:5:39:5:5`
#> hypotenuse(-3, -4)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-r6-example.R:2:3:2:43:3:43:2:2`
#> initialize(...)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-r6-example.R:7:3:7:43:3:43:7:7`
#> initialize(...)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-r6-example.R:8:3:8:36:3:36:8:8`
#> acc$add(3L)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-r6-example.R:12:3:12:40:3:40:12:12`
#> initialize(...)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-r6-example.R:13:3:13:26:3:26:13:13`
#> p$print()
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-r6-example.R:18:3:18:38:3:38:18:18`
#> (function (value) 
#> {
#>     if (if (TRUE) {
#>         covr:::count("r6_example.R:97:9:97:22:9:22:97:97")
#>         missing(value)
#>     }) {
#>         if (TRUE) {
#>             covr:::count("r6_example.R:98:7:98:14:7:14:135:135")
#>             runif(1)
#>         }
#>     }
#>     else {
#>         if (TRUE) {
#>             covr:::count("r6_example.R:100:7:100:48:7:48:137:137")
#>             stop("Can't set `$random`", call. = FALSE)
#>         }
#>     }
#> })()
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-s3-example.R:2:3:2:46:3:46:2:2`
#> s3_example_func(1L)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-s3-example.R:6:3:6:54:3:54:6:6`
#> s3_example_func(list(1, 2, 3))
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-s4-example.R:3:3:3:40:3:40:3:3`
#> names(s4ex)
#> 
#> $`/tmp/RtmpyP0rku/R_LIBS1cad2abd3b59/examplepkg/examplepkg-tests/testthat/test-s4-example.R:7:3:7:31:3:31:7:7`
#> increment(1)
#> 
```
