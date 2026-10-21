# Collect srcrefs of the functions a wrapper keeps in its environment

Functions with a `srcref` are collected. Functions without one may be
wrappers themselves, and are searched in turn. Environments shared by
many functions (namespaces, the global and base environments, attached
packages) are never searched, nor is any environment searched twice.

## Usage

``` r
wrapped_srcrefs(f, seen = list())
```

## Arguments

- f:

  A function without a `srcref`

- seen:

  A `list` of environments already searched

## Value

A `list` of `srcref`s, each with a `"namespace"` attribute of the
namespace of the function it came from
