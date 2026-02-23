# Plot Observed vs Predicted Values

A diagnostic plot to visualize why R-squared might be low or negative.
It compares the model predictions (45-degree line) against the mean
(horizontal line).

## Usage

``` r
plot_diagnostic(x, ...)
```

## Arguments

- x:

  An object of class `lm`.

- ...:

  Further graphical parameters passed to
  [`barplot()`](https://rdrr.io/r/graphics/barplot.html) or
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Value

The function is called for its side effect of generating a plot. It
returns `x` invisibly.

## Examples

``` r
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
model <- lm(y ~ x - 1, data = df1) # No-intercept model
plot_kvr2(model)

```
