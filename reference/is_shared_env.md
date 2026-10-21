# Test whether an environment is shared by many objects

Test whether an environment is shared by many objects

## Usage

``` r
is_shared_env(env)
```

## Arguments

- env:

  An environment, or `NULL`

## Value

`TRUE` for `NULL`, namespaces, attached package environments and the
global, base and empty environments
