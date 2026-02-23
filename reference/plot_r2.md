# Plot Method for r2_kvr2 Objects

Visualizes the nine definitions of R-squared to compare their values and
identify potential issues (e.g., values exceeding 1 or falling below 0).

## Usage

``` r
plot_r2(x, ...)
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
plot_r2(model)

```
