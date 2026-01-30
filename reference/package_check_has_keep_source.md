# Verify that the package collection contains srcref information

Test whether the package object collection contains srcref attributes.

## Usage

``` r
package_check_has_keep_source(env)
```

## Arguments

- env:

  A package namespace environment or iterable collection of package
  objects

## Value

Used for side effect of throwing an error when a package was not
installed with `srcref`s.
