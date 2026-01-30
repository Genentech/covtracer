# Retrieve `srcref`s

This function takes a code collection and returns a `list` of related
`srcref` objects with `list` names that associate the `srcref` with a
name or alias that could be used to find documentation. Code collections
include structures such as package namespaces, environments, function
definitions, methods tables or class generators - any object which
enapsulates a single or set of `srcref` objects.

## Usage

``` r
srcrefs(x, ...)

# Default S3 method
srcrefs(x, ..., srcref_names = NULL, breadcrumbs = character())

# S3 method for class 'list'
srcrefs(x, ..., srcref_names = NULL, breadcrumbs = character())

# S3 method for class 'namespace'
srcrefs(x, ..., breadcrumbs = character())

# S3 method for class 'environment'
srcrefs(x, ..., breadcrumbs = character())

# S3 method for class 'R6ClassGenerator'
srcrefs(x, ..., srcref_names = NULL, breadcrumbs = character())

# S3 method for class 'standardGeneric'
srcrefs(x, ..., srcref_names = NULL)

# S3 method for class 'nonstandardGenericFunction'
srcrefs(x, ..., srcref_names = NULL)

# S3 method for class 'MethodDefinition'
srcrefs(x, ..., srcref_names = NULL)
```

## Arguments

- x:

  An object to source srcrefs from

- ...:

  Additional arguments passed to methods

- srcref_names:

  An optional field used to supercede any discovered object names when
  choosing which names to provide in the returned list.

- breadcrumbs:

  Recursive methods are expected to propegate a vector of "breadcrumbs"
  (a character vector of namespace names encountered while traversing
  the namespace used as a memory of what we've seen already), which is
  used for short-circuiting recursive environment traversal.

## Value

A `list` of `srcref` objects. Often, has a length of 1, but can be
larger for things like environments, namespaces or generic methods. The
names of the list reflect the name of the Rd name or alias that could be
used to find information related to each `srcref`. Elements of the
`list` will have attribute `"namespace"` denoting the source environment
namespace if one can be determined for the srcref object.

## Details

For most objects, this is a one-to-one mapping of exported object names
to their `srcref`, just like you would get using
[`getNamespace()`](https://rdrr.io/r/base/ns-reflect.html). However, for
classes and methods, this can be a one-to-many mapping of related
documentation to the multiple `srcref`s that are described there. This
is the case for S3 generics, S4 objects and R6 objects.

Objects without any related `srcref`s, such as any datasets or objects
created at package build time will be omitted from the results.

## Examples

``` r
# examples use `with` to execute within namespace as function isn't exported
ns <- getNamespace("covtracer")

# load and extract srcrefs for a package
with(ns, srcrefs(getNamespace("covtracer")))
#> named list()

# extract srcrefs for functions
with(ns, srcrefs(srcrefs))
#> [[1]]
#> NULL
#> 
```
