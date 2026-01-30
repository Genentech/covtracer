# Combining srcref Data

``` r
library(covtracer)
```

There are two key relationships that we will explore. The first is a
relationship of `srcref` objects, and the second is the relationship
between namespace object definitions and their associated documentation.

## Setup

Before we begin, we’ll set up a demo coverage object and package
namespace that we can use to showcase these relationships:

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

## Relational `srcref` data

First and foremost, we want to be able to associate `srcref` objects.
These relationships are define the location of code. A `srecref`
describes a region of code where the expression was pulled from, and we
can compare these to determine whether a `srcref` is within, containing
or independent of another.

This vignette will gloss over each of these tables. For more details see
the *Working with `srcref`s* vignette.

### Linking `covr` traces to package object `srcref`s

It’s important to note that coverage traces always sit within a package
namespace object. Where a namespace object might have a `srcref` to the
full code for a function, coverage traces trace individual expressions
within that function.

To associate `srcref`s by this relation, we provide a special joining
function to combine `data.frames` by `srcref` columns.

``` r
traces_df <- trace_srcrefs_df(examplepkg_cov)
pkg_ns_df <- pkg_srcrefs_df(examplepkg_ns)
```

Just looking at these two `data.frames`, we can use the first trace and
package object to illustrate the relationship:

``` r
cat("pkg  : ", format(pkg_ns_df$srcref["s3_example_func.list"]), "\n")
#> pkg  :  s3_example.R:20:25:22:1
cat("trace: ", format(traces_df$srcref[1L]), "\n")
#> trace:  r6_example.R:63:7:63:24
```

Although still a little arcane, you can see that the package object code
contains the coverage trace. The package code spans lines 19-21, whereas
the coverage trace lies in line 20. With this information, we can couple
each package object with the coverage traces contained within each.

``` r
head(join_on_containing_srcrefs(traces_df, pkg_ns_df))
#>                                 name.x                srcref.x                  name.y                 srcref.y
#> 1 r6_example.R:63:7:63:24:7:24:100:100 r6_example.R:63:7:63:24                  Person  r6_example.R:60:18:64:5
#> 2 r6_example.R:74:7:74:23:7:23:111:111 r6_example.R:74:7:74:23                  Person  r6_example.R:72:13:77:5
#> 3       r6_example.R:4:3:8:3:3:3:41:45    r6_example.R:4:3:8:3                   adder    r6_example.R:3:10:9:1
#> 4   r6_example.R:97:9:97:22:9:22:97:97 r6_example.R:97:9:97:22                   Rando r6_example.R:95:12:102:3
#> 5 s3_example.R:16:3:16:11:3:11:259:259 s3_example.R:16:3:16:11 s3_example_func.default  s3_example.R:15:28:17:1
#> 6     hypotenuse.R:8:3:8:25:3:25:35:35   hypotenuse.R:8:3:8:25              hypotenuse    hypotenuse.R:7:15:9:1
#>   namespace.y
#> 1  examplepkg
#> 2  examplepkg
#> 3  examplepkg
#> 4  examplepkg
#> 5  examplepkg
#> 6  examplepkg
```

As expected, we can see that this test trace (now with the `".x"`
suffix) is mapped to the expected corresponding package namespace
object.

### Linking unit tests to evaluated `covr` traces

Although this relationship doesn’t require any fancy `srcref` joining,
we can associate tests and traces by a simple mapping of indices. FOr
this, the [`test_trace_mapping()`](../reference/test_trace_mapping.md)
function is provided which will reshape a `covr` object (produced using
`options(covr.record_tests = TRUE)`) to create a unified table across
all `covr` traces:

``` r
head(test_trace_mapping(examplepkg_cov))
#>      test call depth i trace
#> [1,]    1    1     1 1     9
#> [2,]    2    1    37 1    18
#> [3,]    2    1    38 2    14
#> [4,]    2    1    39 3    24
#> [5,]    2    1    40 4    21
#> [6,]    2    1    40 5    27
```

The `test` and `trace` columns contain the row indices in the respective
[`test_srcrefs_df()`](../reference/test_srcrefs_df.md) and
[`trace_srcrefs_df()`](../reference/trace_srcrefs_df.md) `data.frame`s,
allowing for this data to be joined. However, since it is easy for a
testing suite to cause the evaluation of an enormous number of traces,
this matrix can become extremely long. It is recommended to do some
aggregation or subsetting of this matrix before trying to use it to join
more data-rich data.

You can also see that the evaluation order is stored (`i`), as well as
the stack depth when it was evaluated (`depth`). With this added info,
you might consider first filtering for only the first trace evaluated by
each test, or to count all the times that a line of code was evaluated
by each test by aggregating rows.

## Relational documentation data

On the other side of the process, we also need to associate package
objects with documentation. In many cases, this is trivial, and the name
of the exported object can be used directly to find documentation as you
have come to expect using `?<object>`. This holds for simple functions.
However, some objects are aliased to different documentation files or
are built at package build time into internal representations, as is
with `S4` classes, and `R6` classes.

To handle these cases, we can use the [`Rd_df()`](../reference/Rd_df.md)
function to associate any available source code with a documentation
file.

``` r
# filter for interesting columns for display
cols <- c("file", "alias", "doctype")
Rd_df(examplepkg_source_path)[, cols]
#>                          file                   alias doctype
#> 1              Accumulator.Rd             Accumulator    <NA>
#> 2                    adder.Rd                   adder    <NA>
#> 3       complex_call_stack.Rd      complex_call_stack    <NA>
#> 4   deeper_nested_function.Rd  deeper_nested_function    <NA>
#> 5               hypotenuse.Rd              hypotenuse    <NA>
#> 6                increment.Rd               increment    <NA>
#> 7   names-S4Example-method.Rd  names,S4Example-method    <NA>
#> 8  names-S4Example2-method.Rd names,S4Example2-method    <NA>
#> 9          nested_function.Rd         nested_function    <NA>
#> 10                  Person.Rd                  Person    <NA>
#> 11             PersonPrime.Rd             PersonPrime    data
#> 12                   Rando.Rd                   Rando    <NA>
#> 13         rd_data_sampler.Rd         rd_data_sampler    data
#> 14              rd_sampler.Rd              rd_sampler    <NA>
#> 15      recursive_function.Rd      recursive_function    <NA>
#> 16        reexport_example.Rd        reexport_example    <NA>
#> 17               reexports.Rd               reexports  import
#> 18               reexports.Rd                    help  import
#> 19         s3_example_func.Rd         s3_example_func    <NA>
#> 20         s3_example_func.Rd s3_example_func.default    <NA>
#> 21         s3_example_func.Rd    s3_example_func.list    <NA>
#> 22         S4Example-class.Rd         S4Example-class   class
#> 23         S4Example-class.Rd               S4Example   class
#> 24        S4Example2-class.Rd        S4Example2-class   class
#> 25        S4Example2-class.Rd              S4Example2   class
#> 26   show-S4Example-method.Rd   show,S4Example-method    <NA>
```

These aliases are also used when we use
[`pkg_srcrefs_df()`](../reference/pkg_srcrefs_df.md) and can be used to
associate `srcrefs` with `.Rd` files.

``` r
pkg_srcrefs_df(examplepkg_ns)
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

You’ll see that we don’t have any `srcref`s associated with the `"data"`
and `"class"` doctype documentation because these objects do not
themselves have source code, even if there is source code in that was
used to create them at bulid time.

## Summary

With these relationships, we can build some really deep understandings
of exactly what code a test evaluates and tie that test together with
the documented behaviors.
