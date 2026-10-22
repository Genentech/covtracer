# Identify a function body by the spans of its srcrefs

Identify a function body by the spans of its srcrefs

## Usage

``` r
body_srcref_key(f)
```

## Arguments

- f:

  A function

## Value

A `character` value combining the spans of the `srcref`s attached to the
body of `f`, or `NA` if the body has none. Equal values mean the bodies
come from exactly the same code.
