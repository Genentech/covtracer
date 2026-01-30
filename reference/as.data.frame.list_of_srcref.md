# Coerce a list_of_srcref object to a data.frame

Coerce a list_of_srcref object to a data.frame

## Usage

``` r
# S3 method for class 'list_of_srcref'
as.data.frame(
  x,
  ...,
  use.names = TRUE,
  expand.srcref = FALSE,
  row.names = NULL
)
```

## Arguments

- x:

  A `list_of_srcref` object

- ...:

  Additional arguments unused

- use.names:

  A `logical` indicating whether the names of `x` should be used to
  create a `name` column.

- expand.srcref:

  A `logical` indicating whether to expand the components of `srcref`
  objects into separate columns.

- row.names:

  `NULL` or a single integer or character string specifying a column to
  be used as row names, or a character or integer vector giving the row
  names for the data frame.

## Value

A `data.frame` with one record per `srcref` and variables:

- name:

  Names of the `srcref` objects, passed using the names of `x` if
  `use.names = TRUE`

- srcref:

  `srcref` objects if `expand.srcrefs = FALSE`

- srcfile, line1, byte1, line2, col1, col2, parsed1, parsed2:

  The `srcref` file location if it can be determined. If an absolute
  path can't be found, only the base file name provided in the `srcref`
  object and the numeric components of the `srcref` objects if
  `expand.srcrefs = TRUE`

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
as.data.frame(pkg_srcrefs("examplepkg"))
#>                       name                          srcref
#> 1          nested_function  complex_call_stack.R:9:20:11:1
#> 2                    adder           r6_example.R:3:10:9:1
#> 3       recursive_function complex_call_stack.R:21:23:24:1
#> 4              Accumulator         r6_example.R:29:16:32:3
#> 5              Accumulator            r6_example.R:4:3:8:3
#> 6     s3_example_func.list         s3_example.R:20:25:22:1
#> 7          s3_example_func         s3_example.R:10:20:12:1
#> 8                   Person         r6_example.R:60:18:64:5
#> 9                   Person         r6_example.R:72:13:77:5
#> 10               increment         s4_example.R:58:35:60:1
#> 11              rd_sampler         rd_sampler.R:55:15:57:1
#> 12  deeper_nested_function complex_call_stack.R:15:27:17:1
#> 13              hypotenuse           hypotenuse.R:7:15:9:1
#> 14                   Rando        r6_example.R:95:12:102:3
#> 15               increment         s4_example.R:53:25:55:1
#> 16 s3_example_func.default         s3_example.R:15:28:17:1
#> 17  names,S4Example-method         s4_example.R:17:44:19:1
#> 18 names,S4Example2-method         s4_example.R:43:45:45:1
#> 19   show,S4Example-method         s4_example.R:25:43:27:1
#> 20      complex_call_stack   complex_call_stack.R:3:23:5:1
#> 21             PersonPrime                            <NA>
#> 22                    help                            <NA>
#> 23        reexport_example                            <NA>
#> 24              S4Example2                            <NA>
#> 25               S4Example                            <NA>
#> 26                  person                            <NA>
#> 27         rd_data_sampler                            <NA>
```
