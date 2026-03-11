# kvr2 (development version)

# kvr2 0.2.0

## New Features
* Added `model_info()` function to extract metadata used for calculations, such as regression type (linear/power), sample size ($n$), and degrees of freedom ($k$, $df_{res}$).
* The `print()` methods for `r2_kvr2` and `comp_kvr2` objects now display model information at the end of the output by default. 
* Added a new argument `model_info` (default is `TRUE`) to `print()` methods, allowing users to toggle the display of model metadata.
* Added `comp_model()` to contrast intercept and no-intercept versions of the same model using QR-decomposition for robust re-calculation.
* Added a set of plot functions that visually display the difference between the actual and predicted values of the dependent variable in the model and the coefficient of determination.

## Improvements
* Improved the auto-detection logic for power regression models. It now correctly distinguishes between a variable named "log" and the `log()` function call (e.g., `lm(log(y) ~ x)` is correctly identified while `lm(log ~ x)` is treated as linear).
* Internal calculations now explicitly store model attributes to ensure consistency between `r2()` and `model_info()`.

## Bug Fixes
* Fixed several typographical errors in the output and documentation. Notably, corrected "RMES" to "RMSE" (Root Mean Square Error) in the output of `comp_fit()`.
* Fixed a misclassification issue where models with a dependent variable named "log" were incorrectly identified as power regression when using `type = "auto"`.
* Corrected "liner" to "linear" in various internal labels and documentation to ensure consistency with standard statistical terminology.

# kvr2 0.1.0

* First releases on CRAN.
