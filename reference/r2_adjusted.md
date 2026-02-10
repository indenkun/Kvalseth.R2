# Calculate the adjusted determination coefficient

Calculate the adjusted coefficient of determination by entering the
regression model and coefficient of determination. See details.

## Usage

``` r
r2_adjusted(model, r2)
```

## Arguments

- model:

  A linear model or power regression model of the `lm`.

- r2:

  A numeric. Coefficient of determination.

## Value

A numeric vector or a list of class `r2_kvr2` containing the adjusted
\\R^2\\ values. Each element represents the adjusted version of the
corresponding \\R^2\\ definition, accounting for the degrees of freedom.

## Details

The adjustment factor \\a\\ is calculated using the following formula.
\$\$a = (n - 1) / (n - k - 1)\$\$ \\n\\ is the sample size, and \\k\\ is
the number of parameters in the regression model.

\\R^2_a\\ (\\R^2 adjusted\\) is calculated using the following formula.
\$\$R^2_a = 1 - a (1 - R^2)\$\$

This function performs freedom-of-degrees adjustment for all
coefficients based on the above formula. However, Kvalseth (1985)
recommends applying freedom-of-degrees adjustment only to \\R^2_1\\ and
\\R^2_9\\, based on the principle of consistency in coefficients.
Furthermore, there is no basis for applying the same type of adjustment
to \\R^2_6\\ (the square of the correlation coefficient) or to \\R^2_7\\
and \\R^2_8\\, which depend on specific model forms.

For details on each coefficient of determination, refer to
[`r2()`](https://indenkun.github.io/kvr2/reference/r2_kvr2.md).

## References

Tarald O. Kvalseth (1985) Cautionary Note about R 2 , The American
Statistician, 39:4, 279-285,
[doi:10.1080/00031305.1985.10479448](https://doi.org/10.1080/00031305.1985.10479448)

## See also

[`r2()`](https://indenkun.github.io/kvr2/reference/r2_kvr2.md)
