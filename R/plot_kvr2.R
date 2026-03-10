#' Plot Method for Kvalseth's R-squared Objects
#'
#' @description
#' Visualizes the different R-squared definitions or provides a diagnostic
#' observed-vs-predicted plot to understand the model fit.
#'
#' @param x An object of class `lm`.
#' @param plot_type A string specifying the plot layout: `"both"` (default) displays
#'   the bar plot and diagnostic plot side-by-side,
#'   `"r2"` shows only the R-squared comparison,
#'   and `"diag"` shows only the observed-vs-predicted plot.
#' @inheritParams r2
#' @param ... Currently ignored.
#'
#' @details
#' When `plot_type = "r2"`, the function creates a bar plot comparing all nine
#' definitions. Bars are colored based on their validity:
#' \itemize{
#'   \item **Skyblue**: Standard values between 0 and 1.
#'   \item **Orange**: Values exceeding 1.0 or falling below 0.0 (warnings).
#' }
#'
#' When `plot_type = "diag"`, the function displays a scatter plot of observed
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
#' @return
#' The return value depends on the `plot_type` argument:
#' \itemize{
#'   \item For `"r2"` and `"diag"`: Returns a `ggplot` object
#'     that can be further customized.
#'   \item For `"both"`: Generates a combined plot using the `grid`
#'     system and returns the input object `x` invisibly.
#' }
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
plot_kvr2 <- function(x,
                      type = c("auto", "linear", "power"),
                      plot_type = c("both", "r2", "diag"), ...) {

  type <- match.arg(type)
  plot_type <- match.arg(plot_type)

  if (plot_type == "r2") {
    return(plot(r2(x, type = type)))
  }

  if (plot_type == "diag") {
    return(plot_diagnostic(x))
  }

  res_r2 <- r2(x, type = type)
  p1 <- plot(res_r2)
  p2 <- plot_diagnostic(x)


  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(1, 2, widths = grid::unit(c(1, 1), "null"))))

  print(p1, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1))
  print(p2, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 2))

  invisible(x)
}

#' Plot Method for r2_kvr2 Objects
#' @description
#' Visualizes the nine definitions of R-squared to compare their values
#' and identify potential issues (e.g., values exceeding 1 or falling below 0).
#' @param x An object of class `r2_kvr2`.
#' @param ... Currently ignored.
#'
#' @return A \code{ggplot} object representing the visual analysis.
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x - 1, data = df1) # No-intercept model
#' r2(model)
#'
#' @importFrom ggplot2 .data
#'
#' @export
plot.r2_kvr2 <- function(x, ...) {

  df_plot <- data.frame(
    Definition = toupper(names(x)),
    Value = as.numeric(unlist(x))
  )

  df_plot$Status <- ifelse(df_plot$Value < 0 | df_plot$Value > 1, "Warning", "Normal")

  df_plot$Definition <- factor(df_plot$Definition, levels = df_plot$Definition)

  p <- ggplot2::ggplot(df_plot, ggplot2::aes(x = .data$Definition, y = .data$Value, fill = .data$Status)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::geom_hline(yintercept = 1, color = "blue", linetype = "dashed", linewidth = 0.8) +
    ggplot2::geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 0.8) +
    ggplot2::scale_fill_manual(values = c("Normal" = "skyblue", "Warning" = "orange")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
    ) +
    ggplot2::labs(
      title = "Comparison of Kvalseth's R2 Definitions",
      x = NULL,
      y = "R-squared Value",
      caption = if(any(df_plot$Status == "Warning")) "Note: Orange bars indicate values outside [0, 1] range." else NULL
    )

  y_min <- min(-0.1, min(df_plot$Value))
  y_max <- max(1.1, max(df_plot$Value))
  p <- p + ggplot2::coord_cartesian(ylim = c(y_min, y_max))

  return(p)
}


#' Plot Observed vs Predicted Values
#' @description
#' A diagnostic plot to visualize why R-squared might be low or negative.
#' It compares the model predictions (identity line) against the mean (horizontal line).
#'
#' @param x A fitted `lm` object.
#' @param ... Currently ignored.
#'
#' @return A \code{ggplot} object representing the visual analysis.
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x - 1, data = df1) # No-intercept model
#' plot_diagnostic(model)
#'
#' @importFrom ggplot2 .data
#'
#' @export
plot_diagnostic <- function(x, ...) {

  if(inherits(x, "lm")){
    y <- x$model[[1]]
    y_hat <- stats::predict(x)
    y_mean <- mean(y)
  }else if(inherits(x, "lm_forced")){
    y <- as.vector(x$y)
    y_hat <- as.vector(x$fitted_values)
    y_mean <- mean(y)
  }

  df_diag <- data.frame(
    observed = y,
    predicted = y_hat
  )

  lims <- range(c(y, y_hat))

  p <- ggplot2::ggplot(df_diag, ggplot2::aes(x = .data$predicted, y = .data$observed)) +
    ggplot2::geom_point(color = "blue", alpha = 0.6, size = 2) +
    ggplot2::geom_abline(ggplot2::aes(intercept = 0, slope = 1, color = "Perfect Fit (y = y_hat)"),
                         linewidth = 1) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = y_mean, color = "Overall Mean (y = mean_y)"),
                        linewidth = 1, linetype = "dashed") +
    ggplot2::coord_equal(xlim = lims, ylim = lims) +
    ggplot2::scale_color_manual(
      name = "References",
      values = c("Perfect Fit (y = y_hat)" = "darkgreen",
                 "Overall Mean (y = mean_y)" = "red")
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::labs(
      title = "Observed vs. Predicted Plot",
      subtitle = "Visualizing RSS (distance to green) vs. TSS (distance to red)",
      x = "Predicted Values (y_hat)",
      y = "Observed Values (y)"
    )

  return(p)
}
