# Map `srcrefs` over an iterable object, Filtering non-srcref results

Map `srcrefs` over an iterable object, Filtering non-srcref results

## Usage

``` r
flat_map_srcrefs(xs, ns = NULL, breadcrumbs = character())
```

## Arguments

- xs:

  Any iterable object

- ns:

  A `character` namespace name to attribute to objects in `xs`. If `xs`
  objects themselves have namespaces attributed already to them, the
  namespace will not be replaced.

- breadcrumbs:

  Recursive methods are expected to propegate a vector of "breadcrumbs"
  (a character vector of namespace names encountered while traversing
  the namespace used as a memory of what we've seen already), which is
  used for short-circuiting recursive environment traversal.

## Value

A `list` of `srcref`s
