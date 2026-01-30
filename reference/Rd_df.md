# Create a tabular representation of man file information

Provides Rd index info with a few additional columns of information
about each exported object. Returns one record per documented object,
even if multiple objects alias to the same documentation file.

## Usage

``` r
Rd_df(x)
```

## Arguments

- x:

  A package object to coerce

## Value

A `data.frame` of documented object information with variables:

- index:

  A `numeric` index of documentation files associated with documentation
  objects

- file:

  A `character` filename of the Rd file in the "man" directory

- filepath:

  A `character` file path of the Rd file in the "man" directory

- alias:

  `character` object names which are aliases for the documentation in
  `filepath`

- is_exported:

  A `logical` indicator of whether the aliased object is exported from
  the package namespace

- doctype:

  A `character` representing the Rd docType field.

## Examples

``` r
package_source_dir <- system.file("examplepkg", package = "covtracer")
Rd_df(package_source_dir)
#>                          file
#> 1              Accumulator.Rd
#> 2                   Person.Rd
#> 3              PersonPrime.Rd
#> 4                    Rando.Rd
#> 5          S4Example-class.Rd
#> 6          S4Example-class.Rd
#> 7         S4Example2-class.Rd
#> 8         S4Example2-class.Rd
#> 9                    adder.Rd
#> 10      complex_call_stack.Rd
#> 11  deeper_nested_function.Rd
#> 12              hypotenuse.Rd
#> 13               increment.Rd
#> 14  names-S4Example-method.Rd
#> 15 names-S4Example2-method.Rd
#> 16         nested_function.Rd
#> 17         rd_data_sampler.Rd
#> 18              rd_sampler.Rd
#> 19      recursive_function.Rd
#> 20        reexport_example.Rd
#> 21               reexports.Rd
#> 22               reexports.Rd
#> 23         s3_example_func.Rd
#> 24         s3_example_func.Rd
#> 25         s3_example_func.Rd
#> 26   show-S4Example-method.Rd
#>                                                                               filepath
#> 1              /home/runner/work/_temp/Library/covtracer/examplepkg/man/Accumulator.Rd
#> 2                   /home/runner/work/_temp/Library/covtracer/examplepkg/man/Person.Rd
#> 3              /home/runner/work/_temp/Library/covtracer/examplepkg/man/PersonPrime.Rd
#> 4                    /home/runner/work/_temp/Library/covtracer/examplepkg/man/Rando.Rd
#> 5          /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example-class.Rd
#> 6          /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example-class.Rd
#> 7         /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example2-class.Rd
#> 8         /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example2-class.Rd
#> 9                    /home/runner/work/_temp/Library/covtracer/examplepkg/man/adder.Rd
#> 10      /home/runner/work/_temp/Library/covtracer/examplepkg/man/complex_call_stack.Rd
#> 11  /home/runner/work/_temp/Library/covtracer/examplepkg/man/deeper_nested_function.Rd
#> 12              /home/runner/work/_temp/Library/covtracer/examplepkg/man/hypotenuse.Rd
#> 13               /home/runner/work/_temp/Library/covtracer/examplepkg/man/increment.Rd
#> 14  /home/runner/work/_temp/Library/covtracer/examplepkg/man/names-S4Example-method.Rd
#> 15 /home/runner/work/_temp/Library/covtracer/examplepkg/man/names-S4Example2-method.Rd
#> 16         /home/runner/work/_temp/Library/covtracer/examplepkg/man/nested_function.Rd
#> 17         /home/runner/work/_temp/Library/covtracer/examplepkg/man/rd_data_sampler.Rd
#> 18              /home/runner/work/_temp/Library/covtracer/examplepkg/man/rd_sampler.Rd
#> 19      /home/runner/work/_temp/Library/covtracer/examplepkg/man/recursive_function.Rd
#> 20        /home/runner/work/_temp/Library/covtracer/examplepkg/man/reexport_example.Rd
#> 21               /home/runner/work/_temp/Library/covtracer/examplepkg/man/reexports.Rd
#> 22               /home/runner/work/_temp/Library/covtracer/examplepkg/man/reexports.Rd
#> 23         /home/runner/work/_temp/Library/covtracer/examplepkg/man/s3_example_func.Rd
#> 24         /home/runner/work/_temp/Library/covtracer/examplepkg/man/s3_example_func.Rd
#> 25         /home/runner/work/_temp/Library/covtracer/examplepkg/man/s3_example_func.Rd
#> 26   /home/runner/work/_temp/Library/covtracer/examplepkg/man/show-S4Example-method.Rd
#>                      alias is_exported doctype
#> 1              Accumulator        TRUE    <NA>
#> 2                   Person        TRUE    <NA>
#> 3              PersonPrime        TRUE    data
#> 4                    Rando        TRUE    <NA>
#> 5          S4Example-class       FALSE   class
#> 6                S4Example        TRUE   class
#> 7         S4Example2-class       FALSE   class
#> 8               S4Example2        TRUE   class
#> 9                    adder       FALSE    <NA>
#> 10      complex_call_stack        TRUE    <NA>
#> 11  deeper_nested_function        TRUE    <NA>
#> 12              hypotenuse        TRUE    <NA>
#> 13               increment        TRUE    <NA>
#> 14  names,S4Example-method       FALSE    <NA>
#> 15 names,S4Example2-method       FALSE    <NA>
#> 16         nested_function       FALSE    <NA>
#> 17         rd_data_sampler        TRUE    data
#> 18              rd_sampler        TRUE    <NA>
#> 19      recursive_function       FALSE    <NA>
#> 20        reexport_example        TRUE    <NA>
#> 21               reexports       FALSE  import
#> 22                    help        TRUE  import
#> 23         s3_example_func        TRUE    <NA>
#> 24 s3_example_func.default       FALSE    <NA>
#> 25    s3_example_func.list       FALSE    <NA>
#> 26   show,S4Example-method       FALSE    <NA>
```
