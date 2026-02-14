# Changelog

## kvr2 (development version)

### New Features

- Added
  [`model_info()`](https://indenkun.github.io/kvr2/reference/model_info.md)
  function to extract metadata used for calculations, such as regression
  type (linear/power), sample size (\\n\\), and degrees of freedom
  (\\k\\, \\df\_{res}\\).
- The [`print()`](https://rdrr.io/r/base/print.html) methods for
  `r2_kvr2` and `comp_kvr2` objects now display model information at the
  end of the output by default.
- Added a new argument `model_info` (default is `TRUE`) to
  [`print()`](https://rdrr.io/r/base/print.html) methods, allowing users
  to toggle the display of model metadata.

### Improvements

- Improved the auto-detection logic for power regression models. It now
  correctly distinguishes between a variable named “log” and the
  [`log()`](https://rdrr.io/r/base/Log.html) function call (e.g.,
  `lm(log(y) ~ x)` is correctly identified while `lm(log ~ x)` is
  treated as linear).
- Internal calculations now explicitly store model attributes to ensure
  consistency between
  [`r2()`](https://indenkun.github.io/kvr2/reference/r2_kvr2.md) and
  [`model_info()`](https://indenkun.github.io/kvr2/reference/model_info.md).

### Bug Fixes

- Fixed several typographical errors in the output and documentation.
  Notably, corrected “RMES” to “RMSE” (Root Mean Square Error) in the
  output of
  [`comp_fit()`](https://indenkun.github.io/kvr2/reference/comp_kvr2.md).
- Fixed a misclassification issue where models with a dependent variable
  named “log” were incorrectly identified as power regression when using
  `type = "auto"`.
- Corrected “liner” to “linear” in various internal labels and
  documentation to ensure consistency with standard statistical
  terminology.

## kvr2 0.1.0

- First releases on CRAN.
