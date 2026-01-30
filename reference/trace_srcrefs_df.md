# Create a data.frame of coverage trace srcref objects

Extract
[`coverage`](http://covr.r-lib.org/reference/package_coverage.md)
traces. Traces are the traced lines of code counted when evaluating code
coverage, which are used for counting expression evaluation. Each traced
is a unique expression within a package's source code.

## Usage

``` r
trace_srcrefs_df(x)
```

## Arguments

- x:

  A
  [`package_coverage`](http://covr.r-lib.org/reference/package_coverage.md)
  coverage object, from which the name of the package used is extracted.

## Value

A `data.frame`, where each record it a trace `srcref` with variables:

- name:

  A `character` identifier. This will use the names of the elements of a
  [`coverage`](http://covr.r-lib.org/reference/package_coverage.md)
  object, which are `srcref` "keys".

- srcref:

  A `srcref` object of the trace source code location

## See also

srcrefs test_trace_mapping

Other srcrefs_df: [`pkg_srcrefs_df()`](pkg_srcrefs_df.md),
[`test_srcrefs_df()`](test_srcrefs_df.md)

## Examples

``` r
options(covr.record_tests = TRUE)
pkg_path <- system.file("examplepkg", package = "covtracer")
cov <- covr::package_coverage(pkg_path)
trace_srcrefs_df(cov)
#>                                            name
#> 1          r6_example.R:63:7:63:24:7:24:100:100
#> 2          r6_example.R:74:7:74:23:7:23:111:111
#> 3                r6_example.R:4:3:8:3:3:3:41:45
#> 4            r6_example.R:97:9:97:22:9:22:97:97
#> 5          s3_example.R:16:3:16:11:3:11:259:259
#> 6              hypotenuse.R:8:3:8:25:3:25:35:35
#> 7            r6_example.R:31:5:31:19:5:19:68:68
#> 8          r6_example.R:98:7:98:14:7:14:135:135
#> 9          s4_example.R:26:3:26:20:3:20:292:292
#> 10           r6_example.R:62:7:62:26:7:26:99:99
#> 11           rd_sampler.R:56:3:56:6:3:6:224:224
#> 12       r6_example.R:100:7:100:48:7:48:137:137
#> 13         s3_example.R:11:3:11:30:3:30:254:254
#> 14   complex_call_stack.R:10:3:10:27:3:27:12:12
#> 15             r6_example.R:6:5:6:28:5:28:43:43
#> 16         r6_example.R:76:7:76:50:7:50:113:113
#> 17           s3_example.R:21:3:21:8:3:8:264:264
#> 18       complex_call_stack.R:4:3:4:20:3:20:6:6
#> 19         s4_example.R:54:3:54:30:3:30:320:320
#> 20         r6_example.R:75:7:75:51:7:51:112:112
#> 21   complex_call_stack.R:22:7:22:13:7:13:22:22
#> 22         s4_example.R:18:3:18:15:3:15:284:284
#> 23         s4_example.R:44:3:44:15:3:15:310:310
#> 24   complex_call_stack.R:16:3:16:23:3:23:18:18
#> 25 complex_call_stack.R:22:16:22:24:16:24:22:22
#> 26           s4_example.R:59:3:59:7:3:7:325:325
#> 27   complex_call_stack.R:23:3:23:31:3:31:25:25
#> 28             r6_example.R:7:5:7:19:5:19:44:44
#>                              srcref
#> 1           r6_example.R:63:7:63:24
#> 2           r6_example.R:74:7:74:23
#> 3              r6_example.R:4:3:8:3
#> 4           r6_example.R:97:9:97:22
#> 5           s3_example.R:16:3:16:11
#> 6             hypotenuse.R:8:3:8:25
#> 7           r6_example.R:31:5:31:19
#> 8           r6_example.R:98:7:98:14
#> 9           s4_example.R:26:3:26:20
#> 10          r6_example.R:62:7:62:26
#> 11           rd_sampler.R:56:3:56:6
#> 12        r6_example.R:100:7:100:48
#> 13          s3_example.R:11:3:11:30
#> 14  complex_call_stack.R:10:3:10:27
#> 15            r6_example.R:6:5:6:28
#> 16          r6_example.R:76:7:76:50
#> 17           s3_example.R:21:3:21:8
#> 18    complex_call_stack.R:4:3:4:20
#> 19          s4_example.R:54:3:54:30
#> 20          r6_example.R:75:7:75:51
#> 21  complex_call_stack.R:22:7:22:13
#> 22          s4_example.R:18:3:18:15
#> 23          s4_example.R:44:3:44:15
#> 24  complex_call_stack.R:16:3:16:23
#> 25 complex_call_stack.R:22:16:22:24
#> 26           s4_example.R:59:3:59:7
#> 27  complex_call_stack.R:23:3:23:31
#> 28            r6_example.R:7:5:7:19
```
