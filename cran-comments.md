## Test environments

* local windows install, R 4.5.2
* linux (rhub on github actions), R-devel
* m1-san (rhub on github actions), R-devel
* macos-arm64 (rhub on github actions), R-devel
* windows (rhub on github actions), R-devel
* windows (winbuilder), R-release

## R CMD check results

0 errors | 0 warnings | 0 note

## Update (v0.2.0)
This is a minor update from v0.1.0. 

### Key Changes:
* **Visualization Suite**: Added a comprehensive plotting system using `ggplot2`. 
  - `plot.r2_kvr2()`: Visualizes the 9 R-squared definitions.
  - `plot_diagnostic()`: Added a diagnostic observed-vs-predicted plot.
  - `plot.comp_model()`: A 2x2 dashboard to compare intercept vs. no-intercept models.
* **Testing**: 
  - Significantly expanded `testthat` coverage for R-squared adjustments and model comparisons.

## Downstream dependencies
There are currently no downstream dependencies for this package.
