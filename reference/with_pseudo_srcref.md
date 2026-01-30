# For consistency, stub calls with srcref-like attributes

Most relevant data can be traced to an existing srcref. However, some
data, such as test traces from coverage objects, are likely cleaned up
and their srcfiles deleted, causing a barrage of warnings any time these
objects are printed.

## Usage

``` r
with_pseudo_srcref(call, file, lloc)
```

## Arguments

- call:

  Any code object, most often a `call` object

- file:

  A filepath to bind as a `srcfile` object

- lloc:

  A `srcef`-like `lloc` numeric vector

## Value

A `with_pseudo_srcref` object, mimicking the structure of `srcref`

## Details

A `pseudo_srcref` adds in the `srcref` data but continues to preserve
the expression content. This allows these expression objects to be
pretty-printed like `srcref`s when included as a `list_of_srcref`
`data.frame` column.
