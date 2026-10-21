# Find srcrefs for namespace objects that wrap package functions

Wrappers such as `Vectorize(f)` or `memoise::memoise(f)` have no
`srcref` of their own, but keep the function they wrap in their
environment. Each namespace object without a `srcref` is searched this
way, and given the `srcref`s of the wrapped functions that belong to the
same namespace. Code from other packages, such as helpers a wrapper uses
internally, is left out.

## Usage

``` r
wrapper_srcrefs(ns, exclude = character())
```

## Arguments

- ns:

  A package namespace environment

- exclude:

  A `character` vector of object names that already have `srcref`s

## Value

A `list` of `srcref`s, named by the wrapper they belong to
