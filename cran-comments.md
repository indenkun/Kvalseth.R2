## Test environments

* local windows install, R 4.5.2
* linux (rhub on github actions), R-devel
* m1-san (rhub on github actions), R-devel
* macos-arm64 (rhub on github actions), R-devel
* windows (rhub on github actions), R-devel
* windows (winbuilder), R-release

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
* Possibly misspelled words in DESCRIPTION:
Kvalseth (13:133)

This is a new submission.
"Kvalseth" is a proper noun (the author's name) and not a misspelling.

## Resubmission

This is a resubmission. I have addressed the following comments from the CRAN maintainers:

> please omit the redundant "Provides functions to" from the start of the description.

**Response:** I have removed the redundant phrase. The Description now starts with "Calculates...".

> Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation.

**Response:** I have added the `@return` (translated to `\value`) tag to all exported methods.
Specifically:

* For `print.kvr2.Rd`: Added a description stating that it returns the input object invisibly and is called for its side effect (printing to the console).
* For `r2_adjusted.Rd`: Added a description of the structure (class) and the meaning of the calculated adjusted R-squared values.

## Background

The `kvr2` package implements the classification of coefficients of determination () as described by Kvalseth (1985). It is designed as an educational tool to compare different mathematical definitions of , particularly for models without an intercept or power regression models.
