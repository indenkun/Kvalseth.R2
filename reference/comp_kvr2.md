# Calculate Comparative Fit Measures for Regression Models

Calculates goodness-of-fit metrics based on Kvalseth (1985), including
Root Mean Squared Error (RMSE), Mean Absolute Error (MAE), and Mean
Squared Error (MSE). This function provides a unified output for
comparing different model specifications.

## Usage

``` r
comp_fit(model, type = c("auto", "linear", "power"))

RMSE(model, type = c("auto", "linear", "power"))

MAE(model, type = c("auto", "linear", "power"))

MSE(model, type = c("auto", "linear", "power"))
```

## Arguments

- model:

  A linear model or power regression model of the `lm`.

- type:

  Character string. Selects the model type: `"linear"`, `"power"`, or
  `"auto"` (default). In `"auto"`, the function detects if the dependent
  variable is log-transformed.

## Value

An object of class `comp_kvr2`, which is a list containing the
calculated RMSE, MAE, and MSE values.

## Details

The metrics are calculated according to the formulas in Kvalseth (1985):

- **RMSE**: Root Mean Squared Residual or Error \$\$RMSE =
  \sqrt{\frac{\sum (y - \hat{y})^2}{n}}\$\$

- **MAE**: Mean Absolute Residual or Error \$\$MAE = \frac{\sum \|y -
  \hat{y}\|}{n}\$\$

- **MSE**: Mean Squared Residual or Error (Adjusted for degrees of
  freedom) \$\$MSE = \frac{\sum (y - \hat{y})^2}{n - p}\$\$

where \\n\\ is the sample size and \\p\\ is the number of model
parameters (including the intercept).

**Note on MSE:** In many modern contexts, "MSE" refers to the mean
squared error without degree-of-freedom adjustment (denominator \\n\\).
However, this function follows Kvalseth's definition, which uses \\n -
p\\ as the denominator.

## Note

The power regression model must be based on a logarithmic
transformation.

The auto-selection between linear regression and power regression models
is determined by whether the dependent variable's name contains “log”.
If the name “log” is intentionally used for a linear regression model,
the selection cannot be made correctly.

## References

Tarald O. Kvalseth (1985) Cautionary Note about R 2 , The American
Statistician, 39:4, 279-285, [doi:
10.1080/00031305.1985.10479448](https://doi.org/%2010.1080/00031305.1985.10479448)

## See also

[`print.comp_kvr2()`](https://indenkun.github.io/kvr2/reference/print.kvr2.md)

## Examples

``` r
# example data set 1. Kvålseth (1985).
df1 <- data.frame(x = c(1:6),
                 y = c(15,37,52,59,83,92))
model_intercept <- lm(y ~ x, df1)
model_without <- lm(y ~ x - 1, df1)
model_power <- lm(log(y) ~ log(x), df1)
comp_fit(model_intercept)
#> RMSE :  3.6165 
#> MAE :  3.5238 
#> MSE :  19.6190 
#> ---------------------------------
#> (Type: linear, with intercept, n: 6, k: 2)
comp_fit(model_without)
#> RMSE :  3.9008 
#> MAE :  3.6520 
#> MSE :  18.2593 
#> ---------------------------------
#> (Type: linear, without intercept, n: 6, k: 1)
comp_fit(model_power)
#> RMSE :  3.8982 
#> MAE :  3.6334 
#> MSE :  22.7938 
#> ---------------------------------
#> (Type: power, with intercept, n: 6, k: 2)
```
