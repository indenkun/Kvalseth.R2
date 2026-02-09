## Test environments

* local windows install, R 4.5.2
* linux (rhub on github actions), R-devel
* m1-san (rhub on github actions), R-devel
* macos-arm64 (rhub on github actions), R-devel
* windows (rhub on github actions), R-devel

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.
* Checking for future file timestamps ... NOTE: unable to verify current time.
  This note appeared to be due to a temporary network issue with the time server during the check and is unrelated to the package content.

## Background

The `kvr2` package implements the classification of coefficients of determination (R-squared) as described by Kvalseth (1985). It is designed as an educational tool to compare different mathematical definitions of R-squared, particularly for models without an intercept or power regression models.
