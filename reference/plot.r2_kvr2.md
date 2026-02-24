# Plot Method for r2_kvr2 Objects

Visualizes the nine definitions of R-squared to compare their values and
identify potential issues (e.g., values exceeding 1 or falling below 0).

## Usage

``` r
# S3 method for class 'r2_kvr2'
plot(x, ...)
```

## Arguments

- x:

  An object of class `r2_kvr2`.

- ...:

  Currently ignored.

## Value

A `ggplot` object representing the visual analysis.

## Examples

``` r
df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
model <- lm(y ~ x - 1, data = df1) # No-intercept model
r2(model)
#> R2_1 :  0.9777 
#> R2_2 :  1.0836 
#> R2_3 :  1.0830 
#> R2_4 :  0.9783 
#> R2_5 :  0.9808 
#> R2_6 :  0.9808 
#> R2_7 :  0.9961 
#> R2_8 :  0.9961 
#> R2_9 :  0.9717 
#> ---------------------------------
#> (Type: linear, without intercept, n: 6, k: 1)
```
