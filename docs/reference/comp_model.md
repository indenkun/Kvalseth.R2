# Contrast R-squared Definitions: Intercept vs. No-Intercept

A specialized tool for educational and diagnostic purposes. This
function automatically generates a comparison between a model with an
intercept and its forced no-intercept counterpart (or vice versa),
revealing how mathematical definitions of R-squared diverge under
different constraints.

## Usage

``` r
comp_model(model, type = c("auto", "linear", "power"), adjusted = FALSE)
```

## Arguments

- model:

  A linear model or power regression model of the `lm`.

- type:

  Character string. Selects the model type: `"linear"`, `"power"`, or
  `"auto"` (default). In `"auto"`, the function detects if the dependent
  variable is log-transformed.

- adjusted:

  Logical. If `TRUE`, calculates the adjusted coefficient of
  determination for each formula.

## Value

A data frame of class `comp_model` containing nine R-squared definitions
and three fit metrics (RMSE, MAE, MSE) for both intercept and
no-intercept versions.

## Details

This function reconstructs the alternative model using QR decomposition
rather than [`update()`](https://rdrr.io/r/stats/update.html) to ensure
robustness against environment/scoping issues.

It is particularly useful for observing how definitions like \\R^2_2\\
can exceed 1.0 or \\R^2_1\\ can become negative when an intercept is
removed, illustrating the "pitfalls" discussed in Kvalseth (1985).

## References

Kvalseth, T. O. (1985) Cautionary Note about R2. The American
Statistician, 39(4), 279-285.

## Examples

``` r
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
model <- lm(y ~ x, data = df1)

# Compare R-squared sensitivity
comp_model(model)
#> model             |   R2_1 |   R2_2 |   R2_3 |   R2_4 |   R2_5 |   R2_6
#> -----------------------------------------------------------------------
#> with intercept    | 0.9808 | 0.9808 | 0.9808 | 0.9808 | 0.9808 | 0.9808
#> without intercept | 0.9777 | 1.0836 | 1.0830 | 0.9783 | 0.9808 | 0.9808
#> 
#> model             |   R2_7 |   R2_8 |   R2_9 |   RMSE |    MAE |     MSE
#> ------------------------------------------------------------------------
#> with intercept    | 0.9966 | 0.9966 | 0.9778 | 3.6165 | 3.5238 | 19.6190
#> without intercept | 0.9961 | 0.9961 | 0.9717 | 3.9008 | 3.6520 | 18.2593
#> ---------------------------------
#> 
#> Note: Some R2 values exceed 1.0 or are negative, indicating that these definitions may be inappropriate for the no-intercept model.

# Compare adjusted R-squared
comp_model(model, adjusted = TRUE)
#> model             | R2_1_adj | R2_2_adj | R2_3_adj | R2_4_adj | R2_5_adj
#> ------------------------------------------------------------------------
#> with intercept    |   0.9760 |   0.9760 |   0.9760 |   0.9760 |   0.9760
#> without intercept |   0.9732 |   1.1003 |   1.0996 |   0.9739 |   0.9770
#> 
#> model             | R2_6_adj | R2_7_adj | R2_8_adj | R2_9_adj |   RMSE |    MAE |     MSE
#> -----------------------------------------------------------------------------------------
#> with intercept    |   0.9760 |   0.9958 |   0.9958 |   0.9722 | 3.6165 | 3.5238 | 19.6190
#> without intercept |   0.9770 |   0.9953 |   0.9953 |   0.9661 | 3.9008 | 3.6520 | 18.2593
#> ---------------------------------
#> 
#> Note: Some R2 values exceed 1.0 or are negative, indicating that these definitions may be inappropriate for the no-intercept model.
```
