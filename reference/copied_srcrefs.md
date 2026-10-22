# Find srcrefs for namespace functions copied from another function

A function rebuilt from another one, for example by changing its default
arguments with `formals<-`, loses its own `srcref` but keeps the
original body, along with the body's `srcref`s. Such a function is given
the `srcref` of the namespace function whose body has exactly the same
`srcref`s, so both share code and tests, as an alias (`a <- b`) does.

## Usage

``` r
copied_srcrefs(ns, exclude = character())
```

## Arguments

- ns:

  A package namespace environment

- exclude:

  A `character` vector of object names that already have `srcref`s

## Value

A `list` of `srcref`s, named by the copy they belong to

## Details

Only bodies in braces carry `srcref`s, so a copy of a function like
`function(x) x + 1` can't be matched this way.
