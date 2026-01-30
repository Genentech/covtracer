# Wrap object in test description derivation data

Wrap object in test description derivation data

Adds "testthat" style

## Usage

``` r
as_test_desc(x, type = "call")

as_testthat_desc(x)
```

## Arguments

- x:

  A test description string to bind style data to

- type:

  A type class to attribute to the test description. Defaults to
  `"call"`.

## Value

A `test_description` subclass object with additional `style` attribute
indicating how the test description was derived.
