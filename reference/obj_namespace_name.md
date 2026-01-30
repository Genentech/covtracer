# Get namespace export namespace name

For most objects, this will be identical to the namespace name provided,
but reexports will retain their originating package's namespace name.
This helper function helps to expose this name to determine which
exports are reexports.

## Usage

``` r
obj_namespace_name(x, ns)
```

## Arguments

- x:

  A value to find within namespace `ns`

- ns:

  A package namespace

## Value

A `character` string representing a namespace or similar
