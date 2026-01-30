# Join srcref data.frames by intersection of srcref spans

References to source code are defined by the source code line and column
span of the relevant source code. This function takes data frames
containing that information to pair source code in one data frame to
source code from another. In this case, source code from the left hand
data frame is paired if it is entirely contained within a record of
source code in the right hand data frame.

## Usage

``` r
join_on_containing_srcrefs(x, y, by = c(srcref = "srcref"))
```

## Arguments

- x:

  A `data.frame`, as produced by `as.data.frame` applied to a
  `list_of_srcref`, against which `y` should be joined.

- y:

  A `data.frame`, as produced by `as.data.frame` applied to a
  `list_of_srcref`, joining data from srcrefs data which encompasses
  srcrefs from `x`.

- by:

  A named `character` `vector` of column names to use for the merge. The
  name should be the name of the column from the left `data.frame`
  containing a `list_of_srcref` column, and the value should be the name
  of a column from the right `data.frame` containing a `list_of_srcref`
  column.

## Value

A `data.frame` of `x` joined on `y` by spanning `srcref`
