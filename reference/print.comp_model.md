# Print Method for Model Comparison Objects

A specialized print method for `comp_model` objects. It formats the
comparison table for better readability and provides diagnostic warnings
if any R-squared values fall outside the standard 0 to 1 range.

## Usage

``` r
# S3 method for class 'comp_model'
print(x, ..., digits = 4)
```

## Arguments

- x:

  An object of class `comp_model`.

- ...:

  Further arguments passed to or from other methods.

- digits:

  Number of decimal places to be used for formatting numerical values.
  Default is `4`.

## Value

Returns the input object `x` invisibly.

## Details

The output is formatted using the `insight` package's `export_table()`
functionality, ensuring a clean and structured display in the console.

In addition to the table, this method performs an automated check on the
R-squared values (columns 2 to 10). If any value exceeds 1.0 or falls
below 0.0, a warning message is displayed. This is a critical
educational feature, as it flags instances where specific \\R^2\\
definitions become mathematically inappropriate due to the lack of an
intercept or model misspecification.

## See also

[`comp_model()`](https://indenkun.github.io/kvr2/reference/comp_model.md)
