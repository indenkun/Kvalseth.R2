# The Pitfalls of R-squared: Understanding Mathematical Sensitivity

## Introduction: Why \\R^2\\ is Not Unique

In many statistical software packages, the coefficient of determination
(\\R^2\\) is presented as a singular, definitive value. However, as
Tarald O. Kvalseth pointed out in his seminal 1985 paper, “Cautionary
Note about \\R^2\\”, there are multiple ways to define and calculate
this metric.

While these definitions converge in standard linear regression with an
intercept, they can diverge dramatically in other contexts, such as
models without an intercept or power regression models. The `kvr2`
package is designed as an educational tool to explore this
**mathematical sensitivity**.

## The Eight + One Definitions

Kvalseth (1985) classified eight existing formulas and proposed one
robust alternative. Here are the core definitions used in this package:

## When Goes Negative: Interpretation and Risks

One of the most confusing moments for a researcher is encountering a
negative . Mathematically, is often expected to be between and .
However, in several formulas—most notably —the value can become
negative.

### Meaning of Negative Values

A negative indicates that the chosen model predicts the data **worse
than a horizontal line representing the mean of the observed data**.

In , this occurs when the Residual Sum of Squares (RSS) exceeds the
Total Sum of Squares (TSS). This is a clear signal that:

- The model is fundamentally inappropriate for the data.
- You are forcing a model through a specific constraint (like a
  zero-intercept) that the data strongly resists.

### Case Study: Forcing a No-Intercept Model

Consider a dataset with a strong negative trend where we force the model
through the origin.

``` r
library(kvr2)

# Example: Data with a trend that doesn't pass through (0,0)
df_neg <- data.frame(
  x = c(110, 120, 130, 140, 150, 160, 170, 180, 190, 200),
  y = c(180, 170, 180, 170, 160, 160, 150, 145, 140, 145)
)

model_forced <- lm(y ~ x - 1, data = df_neg)
r2(model_forced)
#> R2_1 :  -8.2183 
#> R2_2 :  4.3883 
#> R2_3 :  4.0856 
#> R2_4 :  -7.9156 
#> R2_5 :  0.8976 
#> R2_6 :  0.8976 
#> R2_7 :  0.9303 
#> R2_8 :  0.9303 
#> R2_9 :  -9.0197
```

In this case, is approximately. This massive negative value tells us
that using the mean of as a predictor would be far more accurate than
this zero-intercept model. Interestingly, and remain positive because
they measure correlation or re-fit the intercept, potentially masking
how poor the original forced model actually is.

------------------------------------------------------------------------

## Technical Note: How R Calculates

It is important to understand how the standard R function
[`summary.lm()`](https://rdrr.io/r/stats/summary.lm.html) computes its
reported . Internally, R uses the ratio of sums of squares:

Where is the Model Sum of Squares and is the Residual Sum of Squares.

### The Shift in Baseline

- **With Intercept**: is calculated relative to the mean. In this case,
  , and the formula is equivalent to .
- **Without Intercept**: R changes the definition of to the sum of
  squares about the origin.

Because R shifts the baseline for no-intercept models, the reported by
`summary(lm(y ~ x - 1))` can appear high even if the model is poor. The
`kvr2` package helps expose this by showing (relative to the mean)
alongside R’s default behavior, allowing you to see if your model is
truly better than a simple average.

------------------------------------------------------------------------

### Standard Definitions

- \\R^2_1\\: The most common form, measuring the proportion of variance
  explained. Kvalseth strongly recommends this for consistency.

\\R_1^2 = 1 - \frac{\sum(y - \hat{y})^2}{\sum(y - \bar{y})^2}\\

- \\R^2_2\\: Often used in some contexts, but can exceed 1.0 in
  no-intercept models.

\\R_2^2 = \frac{\sum(\hat{y} - \bar{y})^2}{\sum(y - \bar{y})^2}\\

- \\R^2_6\\: The square of Pearson’s correlation coefficient between
  observed and predicted values.

\\R_6^2 = \frac{\left( \sum(y - \bar{y})(\hat{y} - \bar{\hat{y}})
\right)^2}{\sum(y - \bar{y})^2 \sum(\hat{y} - \bar{\hat{y}})^2}\\

### Definitions for No-Intercept Models

- \\R^2_7\\: Specifically designed for models passing through the
  origin.

\\R_7^2 = 1 - \frac{\sum(y - \hat{y})^2}{\sum y^2}\\

### Robust Definition

- \\R^2_9\\: Proposed by Kvalseth to resist the influence of outliers by
  using medians (\\M\\).

\\R_9^2 = 1 - \left( \frac{M\\\|y_i - \hat{y}\_i\|\\}{M\\\|y_i -
\bar{y}\|\\} \right)^2\\

------------------------------------------------------------------------

## Case Study: The Danger of No-Intercept Models

Let’s use the example data from Kvalseth (1985) to see how these values
diverge when we remove the intercept.

``` r
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))

# Model without an intercept
model_no_int <- lm(y ~ x - 1, data = df1)

# Calculate all 9 types
results <- r2(model_no_int)
results
#> R2_1 :  0.9777 
#> R2_2 :  1.0836 
#> R2_3 :  1.0830 
#> R2_4 :  0.9783 
#> R2_5 :  0.9808 
#> R2_6 :  0.9808 
#> R2_7 :  0.9961 
#> R2_8 :  0.9961 
#> R2_9 :  0.9717
```

### The Trap

Notice that \\R^2_2\\ and \\R^2_3\\ are greater than 1.0. This happens
because, without an intercept, the standard sum of squares relationship
(\\SS\_{tot} = SS\_{reg} + SS\_{res}\\) no longer holds. If a researcher
blindly reports \\R^2_2\\, the result is mathematically nonsensical.

Kvalseth argues that \\R^2_1\\ is generally preferable because it
remains bounded by 1.0 and maintains a clear interpretation of “error
reduction.”

------------------------------------------------------------------------

## The Transformation Trap (Power Models)

In power regression models (typically fitted via log-log
transformation), the definition of the “mean” and “residuals” becomes
ambiguous. Does the \\R^2\\ refer to the transformed space or the
original space?

``` r
# Power model via log-transformation
model_power <- lm(log(y) ~ log(x), data = df1)
r2(model_power)
#> R2_1 :  0.9777 
#> R2_2 :  1.0984 
#> R2_3 :  1.0983 
#> R2_4 :  0.9778 
#> R2_5 :  0.9816 
#> R2_6 :  0.9811 
#> R2_7 :  0.9961 
#> R2_8 :  1.0232 
#> R2_9 :  0.9706
```

In this case, `kvr2` automatically detects the transformation (if
`type = "auto"`) and helps you evaluate if the reported fit is
consistent with your research goals.

------------------------------------------------------------------------

## Conclusion: A Multi-Metric Approach

As demonstrated, a single value can be misleading. When is negative or
exceeds, it is a diagnostic signal. We recommend:

1.  **Compare and** : If they differ wildly, your intercept constraint
    is likely problematic.
2.  **Check Absolute Errors**: Always look at RMSE or MAE alongside to
    understand the actual scale of the prediction error.
3.  **Context Matters**: Use for legitimate origin-constrained physical
    models, but be wary of its tendency to inflate the perception of
    fit.

## References

Kvalseth, T. O. (1985) Cautionary Note about \\R^2\\. The American
Statistician, 39(4), 279-285. [DOI:
10.1080/00031305.1985.10479448](https://doi.org/10.1080/00031305.1985.10479448)

Yutaka Iguchi. (2025) Differences in the Coefficient of Determination
\\R^2\\: Using Excel, OpenOffice, LibreOffice, and the statistical
analysis software R. Authorea. December 23, [DOI:
10.22541/au.176650719.94164489/v1](https://www.authorea.com/users/623380/articles/1372459)
