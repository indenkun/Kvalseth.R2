# Calculate Multiple Definitions of Coefficient of Determination (R-squared)

Calculates nine types of coefficients of determination (\\R^2\\) based
on the classification by Kvalseth (1985). This function is designed to
demonstrate how \\R^2\\ values can vary depending on their mathematical
definition, particularly in models without an intercept or in power
regression models

## Usage

``` r
r2(model, type = c("auto", "liner", "power"), adjusted = FALSE)

r2_1(model, type = c("auto", "liner", "power"))

r2_2(model, type = c("auto", "liner", "power"))

r2_3(model, type = c("auto", "liner", "power"))

r2_4(model, type = c("auto", "liner", "power"))

r2_5(model, type = c("auto", "liner", "power"))

r2_6(model, type = c("auto", "liner", "power"))

r2_7(model, type = c("auto", "liner", "power"))

r2_8(model, type = c("auto", "liner", "power"))

r2_9(model, type = c("auto", "liner", "power"))
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

An object of class `r2_kvr2`, which is a list containing the calculated
values for each \\R^2\\ formula.

## Details

The nine coefficient equations from \\R^2_1\\ to \\R^2_9\\ are based on
Kvalseth (1985) and are as follows:

- \\R^2_1\\: Proportion of total variance explained. \$\$R_1^2 = 1 -
  \frac{\sum(y - \hat{y})^2}{\sum(y - \bar{y})^2}\$\$

- \\R^2_2\\: Based on the variation of predicted values. \$\$R^2_2 =
  \frac{\sum(\hat{y} - \bar{y})^2}{\sum(y - \bar{y})^2}\$\$

- \\R^2_3\\: Ratio of variation using the mean of predicted values.
  \$\$R_3^2 = \frac{\sum(\hat{y} - \bar{\hat{y}})^2}{\sum(y -
  \bar{y})^2}\$\$

- \\R^2_4\\: Incorporates the mean residual. \$\$R_4^2 = 1 -
  \frac{\sum(e - \bar{e})^2}{\sum(y - \bar{y})^2}, \quad e = y -
  \hat{y}\$\$

- \\R^2_5\\: The square of the multiple correlation coefficient between
  the dependent variable and the independent variable (a comprehensive
  indicator in linearized models). \$\$R_5^2 = \text{squared multiple
  correlation coefficient between the regressand and the regressors}\$\$

- \\R^2_6\\: Square of Pearson's correlation coefficient between
  observed \\y\\ and predicted \\\hat{y}\\. \$\$R_6^2 = \frac{\left(
  \sum(y - \bar{y})(\hat{y} - \bar{\hat{y}}) \right)^2}{\sum(y -
  \bar{y})^2 \sum(\hat{y} - \bar{\hat{y}})^2}\$\$

- \\R^2_7\\: Recommended for models without an intercept. \$\$R_7^2 =
  1 - \frac{\sum(y - \hat{y})^2}{\sum y^2}\$\$

- \\R^2_8\\: Alternative form for models without an intercept. \$\$R_8^2
  = \frac{\sum \hat{y}^2}{\sum y^2}\$\$

- \\R^2_9\\: Robust version using medians to resist outliers. \$\$R_9^2
  = 1 - \left( \frac{M\\\|y_i - \hat{y}\_i\|\\}{M\\\|y_i - \bar{y}\|\\}
  \right)^2\$\$

where \\M\\ represents the median of the sample.

For degree of freedom adjustment `adjusted = TRUE`, refer to
[r2_adjusted](https://indenkun.github.io/kvr2/reference/r2_adjusted.md).

## Note

The power regression model must be based on a logarithmic
transformation.

The auto-selection between linear regression and power regression models
is determined by whether the dependent variable's name contains “log”.
If the name “log” is intentionally used for a linear regression model,
the selection cannot be made correctly.

## References

Tarald O. Kvalseth (1985) Cautionary Note about R 2 , The American
Statistician, 39:4, 279-285,
[doi:10.1080/00031305.1985.10479448](https://doi.org/10.1080/00031305.1985.10479448)

Box, George E. P., Hunter, William G., Hunter, J. Stuart. (1978)
Statistics for experimenters: an introduction to design, data analysis,
and model building. New York, United States, J. Wiley, p. 462-473,
ISBN:9780471093152.

## Examples

``` r
# Example data set 1. Kvalseth (1985).
df1 <- data.frame(x = c(1:6),
                 y = c(15,37,52,59,83,92))
# Linear regression model with intercept
model_intercept1 <- lm(y ~ x, df1)
# Linear regression model without intercept
model_without1 <- lm(y ~ x - 1, df1)
# Power regression model
model_power1 <- lm(log(y) ~ log(x), df1)
r2(model_intercept1)
#> R2_1 :  0.9808 
#> R2_2 :  0.9808 
#> R2_3 :  0.9808 
#> R2_4 :  0.9808 
#> R2_5 :  0.9808 
#> R2_6 :  0.9808 
#> R2_7 :  0.9966 
#> R2_8 :  0.9966 
#> R2_9 :  0.9778 
r2(model_without1)
#> R2_1 :  0.9777 
#> R2_2 :  1.0836 
#> R2_3 :  1.0830 
#> R2_4 :  0.9783 
#> R2_5 :  0.9808 
#> R2_6 :  0.9808 
#> R2_7 :  0.9961 
#> R2_8 :  0.9961 
#> R2_9 :  0.9717 
r2(model_power1)
#> R2_1 :  0.9777 
#> R2_2 :  1.0984 
#> R2_3 :  1.0983 
#> R2_4 :  0.9778 
#> R2_5 :  0.9816 
#> R2_6 :  0.9811 
#> R2_7 :  0.9961 
#> R2_8 :  1.0232 
#> R2_9 :  0.9706 
# Example data set 2. Kvalseth (1985).
df2 <- data.frame(x = 6:13,
                  y = c(3882, 1266, 733, 450, 410, 305, 185, 112))
power_model2 <- lm(log((y/7343)) ~ log(x), data = df2)
r2(power_model2)
#> R2_1 :  0.9019 
#> R2_2 :  0.5858 
#> R2_3 :  0.5825 
#> R2_4 :  0.9051 
#> R2_5 :  0.9668 
#> R2_6 :  0.9498 
#> R2_7 :  0.9392 
#> R2_8 :  0.6879 
#> R2_9 :  0.9782 
# Example of a Multiple Regression Analysis Model.
# The data for two independent variables given by Box et al. (1978, p. 462)
# as used in Kvalseth (1985).
df3 <- data.frame(x1 = c(0.34, 0.34, 0.58, 1.26, 1.26, 1.82),
                  x2 = c(0.73, 0.73, 0.69, 0.97, 0.97, 0.46),
                  y = c(5.75, 4.79, 5.44, 9.09, 8.59, 5.09))
# Multiple regression analysis model with intercept
model_intercept3 <- lm(y ~ x1 + x2, df3)
# Multiple regression analysis model without intercept
model_without3 <- lm(y ~ x1 + x2 - 1, df3)
# Multiple power regression analysis model
model_power3 <- lm(log(y) ~ log(x1) + log(x2), df3)
r2(model_intercept3)
#> R2_1 :  0.9657 
#> R2_2 :  0.9657 
#> R2_3 :  0.9657 
#> R2_4 :  0.9657 
#> R2_5 :  0.9657 
#> R2_6 :  0.9657 
#> R2_7 :  0.9977 
#> R2_8 :  0.9977 
#> R2_9 :  0.9729 
r2(model_without3)
#> R2_1 :  0.9247 
#> R2_2 :  0.6169 
#> R2_3 :  0.6153 
#> R2_4 :  0.9263 
#> R2_5 :  0.9657 
#> R2_6 :  0.9656 
#> R2_7 :  0.9950 
#> R2_8 :  0.9950 
#> R2_9 :  0.9661 
r2(model_power3)
#> R2_1 :  0.9653 
#> R2_2 :  0.9639 
#> R2_3 :  0.9638 
#> R2_4 :  0.9653 
#> R2_5 :  0.9500 
#> R2_6 :  0.9653 
#> R2_7 :  0.9977 
#> R2_8 :  0.9949 
#> R2_9 :  0.9729 
```
