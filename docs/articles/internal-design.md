# Internal Design

``` r
library(kvr2)
```

## Internal Design of `kvr2`

### Overview

The `kvr2` package is designed not only to calculate statistics but also
to serve as an educational tool for understanding the behavior of
\\R^2\\ definitions under various model specifications (e.g., with
vs. without intercept).

To balance compatibility with external table-formatting packages (like
`insight`) and high-performance visualization (using `ggplot2` and
`grid`), the package adopts a **“Metadata-Rich Data Frame”**
architecture.

------------------------------------------------------------------------

### Data Flow Architecture

The internal process follows a three-stage pipeline:

#### 1. Extraction Phase (`values_lm`)

The core extraction function `values_lm()` deconstructs an `lm` object
into its mathematical essentials:

- \\SS\_{res}\\ (Residual Sum of Squares)
- \\SS\_{tot}\\ (Total Sum of Squares)
- \\n\\ (Sample size) and \\k\\ (Number of parameters)
- Identity of the response and predictor variables.

This decoupling ensures that the downstream calculation functions remain
lightweight and do not depend directly on the complex `lm` object
structure.

#### 2. Computation and Metadata Injection (`r2`, `comp_model`)

In this phase, the package calculates the nine \\R^2\\ definitions.
Crucially, it embeds the model’s context as **S3 Attributes**.

- **`r2_kvr2` objects**: Store metadata such as `type` (“linear” or
  “power”), `n`, `k`, and `has_intercept`.
- **`comp_model` objects**: Inherit `data.frame` properties for easy
  printing, while storing the original `lm` objects as hidden attributes
  (`with_int` and `without_int`).

#### 3. Dispatch and Visualization Phase

The S3 methods (`print`, `plot`, `model_info`) leverage these hidden
attributes:

- **[`model_info()`](https://indenkun.github.io/kvr2/reference/model_info.md)**:
  Acts as a “metadata extractor,” providing transparency into how
  degrees of freedom were handled.
- **[`plot.comp_model()`](https://indenkun.github.io/kvr2/reference/plot.comp_model.md)**:
  Recovers the original `lm` objects from attributes to generate
  diagnostic plots on the fly, without requiring the user to pass the
  models again.

------------------------------------------------------------------------

### Handling Non-Standard Evaluation (NSE)

To ensure the package passes `R CMD check` without “no visible binding
for global variable” notes, all `ggplot2` calls use the `.data` pronoun
from the `rlang` package.

``` r
# Example of internal safety
ggplot2::aes(x = .data$Definition, y = .data$Value)
```

### Dependency Strategy

The package follows a “Low-Maintenance Dependency” philosophy:

- \*\*`ggplot2` & `tidyr**`: Core dependencies for modern visualization
  and data reshaping.
- **`grid`**: A base R package used for multi-panel layouts (2x2
  dashboards) to avoid the overhead of additional layout packages like
  `patchwork` or `cowplot`.
- **`insight`**: Used for professional console output formatting.

------------------------------------------------------------------------

### Troubleshooting and Maintenance

When debugging, developers should inspect the object’s “hidden life”
using the following commands:

| Command | Purpose |
|----|----|
| `attributes(obj)` | Check if metadata (n, k, model objects) is preserved. |
| `model_info(obj)` | Verify the mathematical assumptions used for calculation. |
| `unclass(obj)` | View the underlying list structure without S3 method interference. |
