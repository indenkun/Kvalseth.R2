# Plot Observed vs Predicted Values

A diagnostic plot to visualize why R-squared might be low or negative.
It compares the model predictions (identity line) against the mean
(horizontal line).

## Usage

``` r
plot_diagnostic(x, ...)
```

## Arguments

- x:

  A fitted `lm` object.

- ...:

  Currently ignored.

## Value

A `ggplot` object representing the visual analysis.

## Examples

``` r
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
model <- lm(y ~ x - 1, data = df1) # No-intercept model
plot_diagnostic(model)

```
