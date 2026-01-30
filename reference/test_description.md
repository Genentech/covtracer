# Parse a test description from the calling expression

In the general case, a simple indicator of the source file and line
number is used as a test description. There are some special cases where
more descriptive information can be extracted:

## Usage

``` r
test_description(x)
```

## Arguments

- x:

  a unit test call stack or expression.

## Value

A string that describes the test. If possible, this will be a written
description of the test, but will fall back to the test call as a string
in cases where no written description can be determined.

## Details

- `testthat`:

  If the test used
  [`test_that`](https://testthat.r-lib.org/reference/test_that.html),
  then the description (`desc` parameter) is extracted and evaluated if
  need be to produce a descriptive string. Nested calls to
  [`test_that`](https://testthat.r-lib.org/reference/test_that.html)
  currently return the outermost test description, although this
  behavior is subject to change.
