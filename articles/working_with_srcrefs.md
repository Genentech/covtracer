# Working with srcrefs

``` r
library(covtracer)
```

## What are `srcref` objects?

``` r
print(examplepkg_ns$hypotenuse)
#> function(a, b) {
#>   return(sqrt(a^2 + b^2))
#> }
#> <bytecode: 0x56163bb892c0>
#> <environment: namespace:examplepkg>
```

`srcref`s are a base R data type that is used frequently for working
with package code. When you install a package using the
`--with-keep.source` flag, data about the package’s source code
representation is bound to the objects that the namespace attaches or
loads. In short, `srcref`s are simple data structures which store the
file path of the source code and information about where to find the
relevant bits in that file including line and character columns of the
start and end of the source code.

> For extensive details, refer to
> [`?getSrcref`](https://rdrr.io/r/utils/sourceutils.html) and
> [`?srcref`](https://rdrr.io/r/base/srcfile.html).

Lets see it in action:

``` r
getSrcref(covtracer::test_trace_df)
```

``` r
# get line and column ranges (for details see ?srcref)
as.numeric(getSrcref(covtracer::test_trace_df))
#> numeric(0)
```

``` r
getSrcFilename(covtracer::test_trace_df)
#> character(0)
```

## Extracting relevant traceability `srcref`s

Instead of working with these objects directly, there are a few helper
functions for making these objects easier to extract. For tracing
coverage paths, there are three important classes of `srcref`s:

1.  Package namespace object `srcref`s
2.  Test code `srcref`s
3.  Coverage trace `srcref`s

### Setup

Before we begin, we’ll get a package test coverage object and store the
package namespace. We take extra precaution to use a temporary library
for the sake of example, but this is only necessary when we want to
avoid installing the package into our working library.

``` r
library(withr)
library(covr)

withr::with_temp_libpaths({
  options(keep.source = TRUE, keep.source.pkg = TRUE, covr.record_tests = TRUE)
  examplepkg_source_path <- system.file("examplepkg", package = "covtracer")
  install.packages(
    examplepkg_source_path,
    type = "source",
    repos = NULL,
    INSTALL_opts = c("--with-keep.source", "--install-tests")
  )
  examplepkg_cov <- covr::package_coverage(examplepkg_source_path)
  examplepkg_ns <- getNamespace("examplepkg")
})
```

### Functions for extracting `srcref`s

There are a few functions for teasing out this information succinctly.
These include `pkg`, `trace`, and `test` flavors for `*_srcefs` and
`*_srcrefs_df` families of functions (eg,
[`pkg_srcrefs_df()`](../reference/pkg_srcrefs_df.md)). `*_srcrefs()`
functions return a more primitive `list` objects. Because these can be a
bit cumbersome to read through, `*_srcrefs_df()` alternatives are
provided for improved introspection and readability.

> `data.frame` results contain a `srcref` column, where each element is
> a `srcref` object. Even though this appears as a succinct text, it
> contains all the `srcref` data.

#### Extracting package namespace object `srcref`s

Getting a `list` of `srcref`s

``` r
pkg_srcrefs(examplepkg_ns)["test_description.character"]
```

Viewing results as a `data.frame`

``` r
head(pkg_srcrefs_df(examplepkg_ns))
#>                   name                          srcref  namespace
#> 1      nested_function  complex_call_stack.R:9:20:11:1 examplepkg
#> 2                adder           r6_example.R:3:10:9:1 examplepkg
#> 3   recursive_function complex_call_stack.R:21:23:24:1 examplepkg
#> 4          Accumulator         r6_example.R:29:16:32:3 examplepkg
#> 6 s3_example_func.list         s3_example.R:20:25:22:1 examplepkg
#> 7      s3_example_func         s3_example.R:10:20:12:1 examplepkg
```

Extracing individual `srcref`s from the resulting `data.frame`

``` r
df <- pkg_srcrefs_df(examplepkg_ns)
df$srcref[[1L]]
#> function(x) {
#>   deeper_nested_function(x)
#> }
```

#### Extracting test `srcref`s

Similarly, we can extract test `srcrefs` using equivalent functions for
tests. However, to get test traces, we must first run the package
coverage, which records exactly which tests were actually run by the
test suite. Starting from coverage omits any skipped tests or
unevaluated test lines, only presenting test code that is actually run.

Note that the original source files will no longer exist, as `covr` will
install the package into a temporary location for testing. Because of
this, test “srcrefs” are actually `call` objects with a
`with_pseudo_srcref`, allowing them to be treated like a `srcref`s for
consistency.

``` r
examplepkg_test_srcrefs <- test_srcrefs(examplepkg_cov)
```

Despite not having a valid `srcfile`, we can still use all of our
favorite `srcref` functions because of the `with_pseudo_scref` subclass:

``` r
getSrcFilename(examplepkg_test_srcrefs[[1]])
```

    #> character(0)

And finally, there is a corresponding `*_df` function to make this
information easier to see at a glance:

``` r
head(examplepkg_test_srcrefs)
#> [[1]]
#> show(<myS4Example>)
#> 
#> $`/tmp/RtmpqDLhS0/R_LIBS25713191d242/examplepkg/examplepkg-tests/testthat/test-complex-calls.R:2:3:2:50:3:50:2:2`
#> complex_call_stack("test")
#> 
#> $`/tmp/RtmpqDLhS0/R_LIBS25713191d242/examplepkg/examplepkg-tests/testthat/test-complex-calls.R:6:3:6:54:3:54:6:6`
#> deeper_nested_function("test")
#> 
#> $`/tmp/RtmpqDLhS0/R_LIBS25713191d242/examplepkg/examplepkg-tests/testthat/test-complex-calls.R:15:7:15:54:7:54:15:15`
#> complex_call_stack("test")
#> 
#> $`/tmp/RtmpqDLhS0/R_LIBS25713191d242/examplepkg/examplepkg-tests/testthat/test-hypotenuse.R:2:3:2:35:3:35:2:2`
#> hypotenuse(3, 4)
#> 
#> $`/tmp/RtmpqDLhS0/R_LIBS25713191d242/examplepkg/examplepkg-tests/testthat/test-hypotenuse.R:5:5:5:39:5:39:5:5`
#> hypotenuse(-3, -4)
```

#### Extracting trace `srcref`s

The final piece of the puzzle is the coverage traces. These are the
simplest to find, since `covr` stores this information with every
coverage object. Even without any helper functions, you can find this
information by indexing into a coverage object to explore for yourself.

``` r
examplepkg_cov[[1]]$srcref
#> private$age <- age
```

Nevertheless, we provide simple alternatives for restructuring this data
into something more consistent with the rest of the pacakge.

``` r
examplepkg_trace_srcrefs <- trace_srcrefs(examplepkg_cov)
examplepkg_trace_srcrefs[1]
#> $`r6_example.R:63:7:63:24:7:24:100:100`
#>  63
#>   7
#>  63
#>  24
#>   7
#>  24
#> 100
#> 100
```

And just like the other functions in the family, this too comes with a
`*_df` companion function.

``` r
head(trace_srcrefs_df(examplepkg_cov))
#>                                   name                  srcref
#> 1 r6_example.R:63:7:63:24:7:24:100:100 r6_example.R:63:7:63:24
#> 2 r6_example.R:74:7:74:23:7:23:111:111 r6_example.R:74:7:74:23
#> 3       r6_example.R:4:3:8:3:3:3:41:45    r6_example.R:4:3:8:3
#> 4   r6_example.R:97:9:97:22:9:22:97:97 r6_example.R:97:9:97:22
#> 5 s3_example.R:16:3:16:11:3:11:259:259 s3_example.R:16:3:16:11
#> 6     hypotenuse.R:8:3:8:25:3:25:35:35   hypotenuse.R:8:3:8:25
```

## Summary

With all of this information, we can match related code blocks to one
another to retrospectively evaluate the relationship between package
code and tests.
