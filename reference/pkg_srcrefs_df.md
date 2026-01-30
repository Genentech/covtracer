# Create a data.frame of package srcref objects

Create a data.frame of package srcref objects

## Usage

``` r
pkg_srcrefs_df(x)
```

## Arguments

- x:

  A
  [`package_coverage`](http://covr.r-lib.org/reference/package_coverage.md)
  coverage object, from which the name of the package used is extracted.

## Value

A `data.frame` with a record for each source code block with variables:

- name:

  A `character` Rd alias for the package object

- srcref:

  The `srcref` of the associated package source code

## See also

srcrefs test_trace_mapping

Other srcrefs_df: [`test_srcrefs_df()`](test_srcrefs_df.md),
[`trace_srcrefs_df()`](trace_srcrefs_df.md)

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
pkg_srcrefs_df("examplepkg")
#>                       name                          srcref  namespace
#> 1          nested_function  complex_call_stack.R:9:20:11:1 examplepkg
#> 2                    adder           r6_example.R:3:10:9:1 examplepkg
#> 3       recursive_function complex_call_stack.R:21:23:24:1 examplepkg
#> 4              Accumulator         r6_example.R:29:16:32:3 examplepkg
#> 6     s3_example_func.list         s3_example.R:20:25:22:1 examplepkg
#> 7          s3_example_func         s3_example.R:10:20:12:1 examplepkg
#> 8                   Person         r6_example.R:60:18:64:5 examplepkg
#> 9                   Person         r6_example.R:72:13:77:5 examplepkg
#> 10               increment         s4_example.R:58:35:60:1 examplepkg
#> 11              rd_sampler         rd_sampler.R:55:15:57:1 examplepkg
#> 12  deeper_nested_function complex_call_stack.R:15:27:17:1 examplepkg
#> 13              hypotenuse           hypotenuse.R:7:15:9:1 examplepkg
#> 14                   Rando        r6_example.R:95:12:102:3 examplepkg
#> 15               increment         s4_example.R:53:25:55:1 examplepkg
#> 16 s3_example_func.default         s3_example.R:15:28:17:1 examplepkg
#> 17  names,S4Example-method         s4_example.R:17:44:19:1 examplepkg
#> 18 names,S4Example2-method         s4_example.R:43:45:45:1 examplepkg
#> 19   show,S4Example-method         s4_example.R:25:43:27:1 examplepkg
#> 20      complex_call_stack   complex_call_stack.R:3:23:5:1 examplepkg
#> 21             PersonPrime                            <NA>       <NA>
#> 22                    help                            <NA>      utils
#> 23        reexport_example                            <NA>      utils
#> 24              S4Example2                            <NA> examplepkg
#> 25               S4Example                            <NA> examplepkg
#> 26                  person                            <NA>      utils
#> 27         rd_data_sampler                            <NA>       <NA>
```
