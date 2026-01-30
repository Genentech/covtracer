# Extract all the srcref objects of objects within a package namespace

Extract all the srcref objects of objects within a package namespace

## Usage

``` r
pkg_srcrefs(x)

# S3 method for class 'environment'
pkg_srcrefs(x)

# S3 method for class 'character'
pkg_srcrefs(x)

# S3 method for class 'coverage'
pkg_srcrefs(x)
```

## Arguments

- x:

  A
  [`package_coverage`](http://covr.r-lib.org/reference/package_coverage.md)
  coverage object, from which the name of the package used is extracted.

## Value

A `list_of_srcref`

## See also

as.data.frame.list_of_srcref

Other srcrefs: [`test_srcrefs()`](test_srcrefs.md),
[`trace_srcrefs()`](trace_srcrefs.md)

## Examples

``` r
pkg <- system.file("examplepkg", package = "covtracer")
install.packages(
  pkg,
  type = "source",
  repos = NULL,
  quiet = TRUE,
  INSTALL_opts = "--with-keep.source"
)
pkg_srcrefs("examplepkg")
#> $nested_function
#>  9
#> 20
#> 11
#>  1
#> 20
#>  1
#> 11
#> 13
#> 
#> $adder
#>  3
#> 10
#>  9
#>  1
#> 10
#>  1
#> 40
#> 46
#> 
#> $recursive_function
#> 21
#> 23
#> 24
#>  1
#> 23
#>  1
#> 23
#> 26
#> 
#> $Accumulator
#> 29
#> 16
#> 32
#>  3
#> 16
#>  3
#> 66
#> 69
#> 
#> $Accumulator
#>  4
#>  3
#>  8
#>  3
#>  3
#>  3
#> 41
#> 45
#> 
#> $s3_example_func.list
#>  20
#>  25
#>  22
#>   1
#>  25
#>   1
#> 263
#> 265
#> 
#> $s3_example_func
#>  10
#>  20
#>  12
#>   1
#>  20
#>   1
#> 253
#> 255
#> 
#> $Person
#>  60
#>  18
#>  64
#>   5
#>  18
#>   5
#>  97
#> 101
#> 
#> $Person
#>  72
#>  13
#>  77
#>   5
#>  13
#>   5
#> 109
#> 114
#> 
#> $increment
#>  58
#>  35
#>  60
#>   1
#>  35
#>   1
#> 324
#> 326
#> 
#> $rd_sampler
#>  55
#>  15
#>  57
#>   1
#>  15
#>   1
#> 223
#> 225
#> 
#> $deeper_nested_function
#> 15
#> 27
#> 17
#>  1
#> 27
#>  1
#> 17
#> 19
#> 
#> $hypotenuse
#>  7
#> 15
#>  9
#>  1
#> 15
#>  1
#> 34
#> 36
#> 
#> $Rando
#>  95
#>  12
#> 102
#>   3
#>  12
#>   3
#> 132
#> 139
#> 
#> $increment
#>  53
#>  25
#>  55
#>   1
#>  25
#>   1
#> 319
#> 321
#> 
#> $s3_example_func.default
#>  15
#>  28
#>  17
#>   1
#>  28
#>   1
#> 258
#> 260
#> 
#> $`names,S4Example-method`
#>  17
#>  44
#>  19
#>   1
#>  44
#>   1
#> 283
#> 285
#> 
#> $`names,S4Example2-method`
#>  43
#>  45
#>  45
#>   1
#>  45
#>   1
#> 309
#> 311
#> 
#> $`show,S4Example-method`
#>  25
#>  43
#>  27
#>   1
#>  43
#>   1
#> 291
#> 293
#> 
#> $complex_call_stack
#>  3
#> 23
#>  5
#>  1
#> 23
#>  1
#>  5
#>  7
#> 
#> $PersonPrime
#> NA
#> 
#> $help
#> NA
#> 
#> $reexport_example
#> NA
#> 
#> $S4Example2
#> NA
#> 
#> $S4Example
#> NA
#> 
#> $person
#> NA
#> 
#> $rd_data_sampler
#> NA
#> 
```
