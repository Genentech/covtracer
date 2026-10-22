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
#>                                               file
#> Accumulator                         Accumulator.Rd
#> Person                                   Person.Rd
#> PersonPrime                         PersonPrime.Rd
#> Rando                                     Rando.Rd
#> S4Example-class                 S4Example-class.Rd
#> S4Example                       S4Example-class.Rd
#> S4Example2-class               S4Example2-class.Rd
#> S4Example2                     S4Example2-class.Rd
#> adder                                     adder.Rd
#> complex_call_stack           complex_call_stack.Rd
#> deeper_nested_function   deeper_nested_function.Rd
#> hypotenuse                           hypotenuse.Rd
#> increment                             increment.Rd
#> names,S4Example-method   names-S4Example-method.Rd
#> names,S4Example2-method names-S4Example2-method.Rd
#> nested_function                 nested_function.Rd
#> rd_data_sampler                 rd_data_sampler.Rd
#> rd_sampler                           rd_sampler.Rd
#> recursive_function           recursive_function.Rd
#> reexport_example               reexport_example.Rd
#> reexports                             reexports.Rd
#> help                                  reexports.Rd
#> s3_example_func                 s3_example_func.Rd
#> s3_example_func.default         s3_example_func.Rd
#> s3_example_func.list            s3_example_func.Rd
#> show,S4Example-method     show-S4Example-method.Rd
#>                                                                                                    filepath
#> Accumulator                         /home/runner/work/_temp/Library/covtracer/examplepkg/man/Accumulator.Rd
#> Person                                   /home/runner/work/_temp/Library/covtracer/examplepkg/man/Person.Rd
#> PersonPrime                         /home/runner/work/_temp/Library/covtracer/examplepkg/man/PersonPrime.Rd
#> Rando                                     /home/runner/work/_temp/Library/covtracer/examplepkg/man/Rando.Rd
#> S4Example-class                 /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example-class.Rd
#> S4Example                       /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example-class.Rd
#> S4Example2-class               /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example2-class.Rd
#> S4Example2                     /home/runner/work/_temp/Library/covtracer/examplepkg/man/S4Example2-class.Rd
#> adder                                     /home/runner/work/_temp/Library/covtracer/examplepkg/man/adder.Rd
#> complex_call_stack           /home/runner/work/_temp/Library/covtracer/examplepkg/man/complex_call_stack.Rd
#> deeper_nested_function   /home/runner/work/_temp/Library/covtracer/examplepkg/man/deeper_nested_function.Rd
#> hypotenuse                           /home/runner/work/_temp/Library/covtracer/examplepkg/man/hypotenuse.Rd
#> increment                             /home/runner/work/_temp/Library/covtracer/examplepkg/man/increment.Rd
#> names,S4Example-method   /home/runner/work/_temp/Library/covtracer/examplepkg/man/names-S4Example-method.Rd
#> names,S4Example2-method /home/runner/work/_temp/Library/covtracer/examplepkg/man/names-S4Example2-method.Rd
#> nested_function                 /home/runner/work/_temp/Library/covtracer/examplepkg/man/nested_function.Rd
#> rd_data_sampler                 /home/runner/work/_temp/Library/covtracer/examplepkg/man/rd_data_sampler.Rd
#> rd_sampler                           /home/runner/work/_temp/Library/covtracer/examplepkg/man/rd_sampler.Rd
#> recursive_function           /home/runner/work/_temp/Library/covtracer/examplepkg/man/recursive_function.Rd
#> reexport_example               /home/runner/work/_temp/Library/covtracer/examplepkg/man/reexport_example.Rd
#> reexports                             /home/runner/work/_temp/Library/covtracer/examplepkg/man/reexports.Rd
#> help                                  /home/runner/work/_temp/Library/covtracer/examplepkg/man/reexports.Rd
#> s3_example_func                 /home/runner/work/_temp/Library/covtracer/examplepkg/man/s3_example_func.Rd
#> s3_example_func.default         /home/runner/work/_temp/Library/covtracer/examplepkg/man/s3_example_func.Rd
#> s3_example_func.list            /home/runner/work/_temp/Library/covtracer/examplepkg/man/s3_example_func.Rd
#> show,S4Example-method     /home/runner/work/_temp/Library/covtracer/examplepkg/man/show-S4Example-method.Rd
#>                                           alias is_exported is_traceable
#> Accumulator                         Accumulator        TRUE         TRUE
#> Person                                   Person        TRUE         TRUE
#> PersonPrime                         PersonPrime        TRUE        FALSE
#> Rando                                     Rando        TRUE         TRUE
#> S4Example-class                 S4Example-class       FALSE         TRUE
#> S4Example                             S4Example        TRUE         TRUE
#> S4Example2-class               S4Example2-class       FALSE         TRUE
#> S4Example2                           S4Example2        TRUE         TRUE
#> adder                                     adder       FALSE         TRUE
#> complex_call_stack           complex_call_stack        TRUE         TRUE
#> deeper_nested_function   deeper_nested_function        TRUE         TRUE
#> hypotenuse                           hypotenuse        TRUE         TRUE
#> increment                             increment        TRUE         TRUE
#> names,S4Example-method   names,S4Example-method       FALSE         TRUE
#> names,S4Example2-method names,S4Example2-method       FALSE         TRUE
#> nested_function                 nested_function       FALSE         TRUE
#> rd_data_sampler                 rd_data_sampler        TRUE        FALSE
#> rd_sampler                           rd_sampler        TRUE         TRUE
#> recursive_function           recursive_function       FALSE         TRUE
#> reexport_example               reexport_example        TRUE         TRUE
#> reexports                             reexports       FALSE        FALSE
#> help                                       help        TRUE        FALSE
#> s3_example_func                 s3_example_func        TRUE         TRUE
#> s3_example_func.default s3_example_func.default       FALSE         TRUE
#> s3_example_func.list       s3_example_func.list       FALSE         TRUE
#> show,S4Example-method     show,S4Example-method       FALSE         TRUE
#>                         doctype
#> Accumulator                <NA>
#> Person                     <NA>
#> PersonPrime                data
#> Rando                      <NA>
#> S4Example-class           class
#> S4Example                 class
#> S4Example2-class          class
#> S4Example2                class
#> adder                      <NA>
#> complex_call_stack         <NA>
#> deeper_nested_function     <NA>
#> hypotenuse                 <NA>
#> increment                  <NA>
#> names,S4Example-method     <NA>
#> names,S4Example2-method    <NA>
#> nested_function            <NA>
#> rd_data_sampler            data
#> rd_sampler                 <NA>
#> recursive_function         <NA>
#> reexport_example           <NA>
#> reexports                import
#> help                     import
#> s3_example_func            <NA>
#> s3_example_func.default    <NA>
#> s3_example_func.list       <NA>
#> show,S4Example-method      <NA>
```
