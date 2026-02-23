#' Plot Method for Kvalseth's R-squared Objects
#'
#' @description
#' Visualizes the different R-squared definitions or provides a diagnostic
#' observed-vs-predicted plot to understand the model fit.
#'
#' @param x An object of class `lm`.
#' @param plot_type A string specifying the plot layout: `"both"` (default) displays
#'   the bar plot and diagnostic plot side-by-side using `par(mfrow = c(1, 2))`,
#'   `"r2"` shows only the R-squared comparison,
#'   and `"diag"` shows only the observed-vs-predicted plot.
#' @param ... Further graphical parameters passed to `barplot()` or `plot()`.
#'
#' @details
#' When `plot_type = "r2"`, the function creates a bar plot comparing all nine
#' definitions. Bars are colored based on their validity:
#' \itemize{
#'   \item **Skyblue**: Standard values between 0 and 1.
#'   \item **Orange**: Values exceeding 1.0 or falling below 0.0 (warnings).
#' }
#'
#' When `plot_ype = "diag"`, the function displays a scatter plot of observed
#' vs. predicted values. Two reference lines are added:
#' \itemize{
#'   \item **Darkgreen Solid Line**: The 1:1 "perfect fit" line (RSS reference).
#'   \item **Red Dashed Line**: The overall mean of the observed data (TSS reference).
#' }
#' If the data points are closer to the red dashed line than the green solid line,
#' \eqn{R^2_1} will be negative.
#'
#' **Combined View (`plot_type = "both"`)**:
#' Automatically configures the plotting device to show both plots simultaneously
#' for a comprehensive model evaluation.
#'
#' @return The function is called for its side effect of generating a plot.
#'   It returns `x` invisibly.
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x - 1, data = df1) # No-intercept model
#' plot_kvr2(model)
#' # Compare all definitions
#' plot_kvr2(model, plot_type = "r2")
#'
#' # Diagnostic plot to see why some R2 might be problematic
#' plot_kvr2(model, plot_type = "diag")
#'
#' @export
plot_kvr2 <- function(x, plot_type = c("both", "r2", "diag"), ...) {
  plot_type <- match.arg(plot_type)
  check_lm(x)

  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(oldpar))

  if(plot_type == "both") {
    graphics::par(mfrow = c(1, 2))
  }

  if(plot_type %in% c("both", "r2")){
    plot_r2(x, ...)
  }
  if(plot_type %in% c("both", "diag")) {
    plot_diagnostic(x, ...)
  }

  invisible(x)
}

#' Plot Method for r2_kvr2 Objects
#' @description
#' Visualizes the nine definitions of R-squared to compare their values
#' and identify potential issues (e.g., values exceeding 1 or falling below 0).
#' @inheritParams plot_kvr2
#'
#' @inherit plot_kvr2 return
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x - 1, data = df1) # No-intercept model
#' plot_r2(model)
#'
#' @export
plot_r2 <- function(x, ...) {
  x <- r2(x)
  vals <- unlist(x)
  names(vals) <- toupper(names(x))

  bp <- graphics::barplot.default(vals,
                                  main = "Comparison of \n Kvalseth's R2 Definitions",
                                  ylab = "R-squared Value",
                                  ylim = c(min(-0.1, min(vals)), max(1.1, max(vals))), # 範囲外も見えるように調整
                                  col = ifelse(vals < 0 | vals > 1, "orange", "skyblue"),
                                  las = 2)

  graphics::abline(h = 1, col = "blue", lwd = 2, lty = 2) # 上限ライン
  graphics::abline(h = 0, col = "red", lwd = 2, lty = 2)  # 下限ライン

  if(any(vals > 1)) graphics::mtext("Warning: Some values exceed 1.0", side = 3, col = "orange")
  if(any(vals < 0)) graphics::mtext("Warning: Some values are negative", side = 1, col = "red", line = 4)

  invisible(x)
}

#' Plot Observed vs Predicted Values
#' @description
#' A diagnostic plot to visualize why R-squared might be low or negative.
#' It compares the model predictions (45-degree line) against the mean (horizontal line).
#' @inheritParams plot_kvr2
#'
#' @inherit plot_kvr2 return
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x - 1, data = df1) # No-intercept model
#' plot_kvr2(model)
#'
#' @export
plot_diagnostic <- function(x, ...) {

  y <- x$model[[1]]
  y_hat <- stats::predict(x)
  y_mean <- mean(y)

  lims <- range(c(y, y_hat))

  graphics::plot.default(y_hat, y,
                         main = "Observed vs. Predicted Plot",
                         xlab = "Predicted Values (y-hat)",
                         ylab = "Observed Values (y)",
                         pch = 16, col = "blue",
                         xlim = lims, ylim = lims,
                         type = "p",
                         ...)

  graphics::abline(0, 1, col = "darkgreen", lwd = 2)
  graphics::abline(h = y_mean, col = "red", lwd = 2, lty = 2)

  graphics::legend("topleft",
                   legend = c("Perfect Fit (RSS=0)", "Overall Mean (TSS reference)"),
                   col = c("darkgreen", "red"), lty = c(1, 2), lwd = 2, bty = "n")

  invisible(x)
}
