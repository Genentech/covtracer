# Match srcrefs against srcrefs that contain them

Provided two lists of `srcref` objects, find the first `srcrefs` in `r`
that entirely encapsulate each respective `srcref` in `l`, returning a
list of indices of `srcref`s in `r` for each `srcref` in `l`.

## Usage

``` r
match_containing_srcrefs(l, r)
```

## Arguments

- l:

  A `list_of_srcref` object

- r:

  A `list_of_srcref` object

## Value

A `integer` vector of the first index in `r` that fully encapsulate the
respective element in `l`
