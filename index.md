# kvr2: Educational Tool for Exploring \\R^2\\ Definitions

The `kvr2` package provides functions to calculate nine types of
coefficients of determination (\\R^2\\) as classified by **Kvalseth
(1985)**.

### Overview

The coefficient of determination, \\R^2\\, is one of the most common
metrics for assessing model fit. However, its mathematical definition is
not unique. While various formulas yield identical results in standard
linear regression with an intercept, they can diverge
significantly—sometimes producing negative values or values exceeding
1—when applied to:

- **Models without an intercept** (No-intercept models)
- **Power regression models**
- **Other fits via transformations** (e.g., log-log models)

### Scope and Compatibility

This package is specifically designed for models that can be represented
as `lm` objects in R. This includes:

- **Standard Linear Models** (with an intercept)
- **No-intercept Models** (e.g., `lm(y ~ x - 1)`)
- **Power Regression Models** (fitted via log-transformation, such as
  `lm(log(y) ~ log(x))`)

**Note:** This package does **not** support general non-linear least
squares (`nls`) or other complex non-linear modeling frameworks. It
focuses on the mathematical sensitivity of \\R^2\\ within the context of
linear estimation and its common transformations.

### Educational Purpose

The primary goal of this package is **not** to provide a definitive
“best” \\R^2\\ for every scenario, but to serve as an educational
resource. By providing a comprehensive list of definitions, it helps
users understand the **mathematical sensitivity** of goodness-of-fit
indices.

Through this package, users can:

1.  **Observe Variability**: See firsthand how the choice of an
    algebraic formula can lead to different interpretations of the same
    model.
2.  **Identify Pitfalls**: Recognize why certain definitions are
    inappropriate for specific model types (e.g., how the lack of an
    intercept affects the sum of squares).
3.  **Analyze Recommendations**: Explore Kvalseth’s arguments for why
    \\R^2_1\\ (and \\R^2_9\\ for robust cases) are often preferred for
    consistency and comparability.

### Formulas Included

The package calculates nine indices based on Kvalseth (1985):

- **\\R^2_1\\** to **\\R^2_8\\**: A classification of existing and
  historical formulas used in statistical literature and software.
- **\\R^2_9\\**: A robust version of the coefficient of determination
  based on median absolute deviations, as proposed in the original
  paper.

------------------------------------------------------------------------

## Installation

You can install the released version of `kvr2` from CRAN with:

``` r
install.packages("kvr2")
```

You can install the development version of `kvr2` like so:

``` r
remotes::install_github("indenkun/kvr2")
```

## Usage and Examples

`kvr2` provides a simple way to observe how different \\R^2\\
definitions behave across various model specifications.

### 1. Basic Usage: Consistency and Divergence

In standard linear models with an intercept, most \\R^2\\ definitions
yield identical results. However, they can diverge significantly in
models without an intercept or in power regression models.

``` r
library(kvr2)

# Dataset from Kvalseth (1985)
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))

# Case A: Linear regression with intercept (Values are consistent)
model_int <- lm(y ~ x, data = df1)
r2(model_int)
#> R2_1 :  0.9808 
#> R2_2 :  0.9808 
#> R2_3 :  0.9808 
#> R2_4 :  0.9808 
#> R2_5 :  0.9808 
#> R2_6 :  0.9808 
#> R2_7 :  0.9966 
#> R2_8 :  0.9966 
#> R2_9 :  0.9778

# Case B: Linear regression without intercept (Values diverge)
model_no_int <- lm(y ~ x - 1, data = df1)
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

**Observation:** In Case B, notice that \\R^2_2\\ and \\R^2_3\\ exceed
1.0. This demonstrates why choosing the correct definition is critical
for models without an intercept.

### 2. Accessing Calculated Values

The [`r2()`](https://indenkun.github.io/kvr2/reference/r2_kvr2.md)
function returns a list object. While the output is formatted for
readability, you can easily access individual values for further
analysis or reporting.

``` r
# Accessing specific R2 values from the result object
results$r2_1
#>      r2_1 
#> 0.9776853

results$r2_9
#>      r2_9 
#> 0.9717156

# You can also use it in your custom functions or data frames
my_val <- results$r2_1
```

### 3. Model Comparison with Error Metrics

To complement \\R^2\\ analysis, use
[`comp_fit()`](https://indenkun.github.io/kvr2/reference/comp_kvr2.md)
to evaluate models via standard error metrics such as RMSE, MAE, and
MSE.

``` r
comp_fit(model_no_int)
#> RMES :  3.9008 
#> MAE :  3.6520 
#> MSE :  18.2593
```

For details, refer to the documentation for each function.

## References

Kvalseth, T. O. (1985). Cautionary Note about \\R^2\\. The American
Statistician, 39(4), 279-285. [DOI:
10.1080/00031305.1985.10479448](https://doi.org/10.1080/00031305.1985.10479448)
