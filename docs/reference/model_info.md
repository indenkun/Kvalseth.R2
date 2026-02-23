# Get Model Information Used for Calculations

Extracts the metadata and model specifications used to calculate the
coefficients of determination, such as the regression type, sample size,
and degrees of freedom.

## Usage

``` r
model_info(x)
```

## Arguments

- x:

  An object of class `r2_kvr2` or `comp_kvr2`.

## Value

A list containing the following components:

- `type`: A string indicating the regression type ("linear" or "power").

- `has_intercept`: A logical value indicating if the model includes an
  intercept.

- `n`: The number of observations used in the model (excluding missing
  values).

- `k`: The number of estimated parameters (including the intercept if
  present).

- `df_res`: Residual degrees of freedom (\\n - k\\).

## Details

This function provides transparency into the calculation process of the
various R-squared definitions. It is particularly useful for verifying
whether a model was treated as a "power" regression (log-transformed)
and how the degrees of freedom were determined for adjusted R-squared
values.

## Note

The sample size `n` refers to the actual number of observations used by
[`lm()`](https://rdrr.io/r/stats/lm.html), which may be fewer than the
rows in the original data frame if `NA` values were present.

## See also

[`r2()`](https://indenkun.github.io/kvr2/reference/r2_kvr2.md),
[`comp_fit()`](https://indenkun.github.io/kvr2/reference/comp_kvr2.md)

## Examples

``` r
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
model <- lm(y ~ x, data = df1)
res <- r2(model)

# Check the metadata
info <- model_info(res)
info$n
#> [1] 6
info$type
#> [1] "linear"
```
