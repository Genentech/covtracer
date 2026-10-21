# Identify the span of each srcref

Identify the span of each srcref

## Usage

``` r
srcref_span_key(x)
```

## Arguments

- x:

  A `list_of_srcref` object

## Value

A `character` vector with the file name, first line, first column, last
line and last column of each `srcref`, or `NA` for elements that are not
`srcref`s. Equal values mean exactly the same span of code.
