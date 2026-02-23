#' Contrast R-squared Definitions: Intercept vs. No-Intercept
#'
#' @description
#' A specialized tool for educational and diagnostic purposes. This function
#' automatically generates a comparison between a model with an intercept
#' and its forced no-intercept counterpart (or vice versa), revealing how
#' mathematical definitions of R-squared diverge under different constraints.
#'
#' @inheritParams r2
#'
#' @details
#' This function reconstructs the alternative model using QR decomposition
#' rather than `update()` to ensure robustness against environment/scoping
#' issues.
#'
#' It is particularly useful for observing how definitions like \eqn{R^2_2}
#' can exceed 1.0 or \eqn{R^2_1} can become negative when an intercept is
#' removed, illustrating the "pitfalls" discussed in Kvalseth (1985).
#'
#' @return A data frame of class `comp_model` containing nine R-squared
#'   definitions and three fit metrics (RMSE, MAE, MSE) for both intercept
#'   and no-intercept versions.
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x, data = df1)
#'
#' # Compare R-squared sensitivity
#' comp_model(model)
#'
#' # Compare adjusted R-squared
#' comp_model(model, adjusted = TRUE)
#'
#' @references
#' Kvalseth, T. O. (1985) Cautionary Note about R2. The American Statistician,
#' 39(4), 279-285.
#'
#' @export
comp_model <- function(model, type = c("auto", "linear", "power"), adjusted = FALSE){
  type <- match.arg(type)

  if(attr(model$terms, "intercept")){
    with_int <- c(r2(model, type = type, adjusted = adjusted),
                  comp_fit(model, type = type))
    without_int <- c(r2(lm_forced_without_int(model), type = type, adjusted = adjusted),
                     comp_fit(lm_forced_without_int(model), type = type))
  }else{
    with_int <- c(r2(lm_forced_int(model), type = type, adjusted = adjusted),
                  comp_fit(lm_forced_int(model), type = type))
    without_int <- c(r2(model, type = type, adjusted = adjusted),
                     comp_fit(model, type = type))
  }

  with_int <- cbind.data.frame(model = "with intercept", as.data.frame.list(with_int))
  with_out <- cbind.data.frame(model = "without intercept", as.data.frame.list(without_int))

  res <- rbind(with_int, with_out, make.row.names = FALSE)
  res_names <- names(res)
  names(res) <- c(res_names[1], chartr("r", "R", res_names[2:10]), toupper(res_names[11:13]))
  class(res) <- c("comp_model", class(res))
  res
}

#' Print Method for Model Comparison Objects
#'
#' @description
#' A specialized print method for `comp_model` objects. It formats the
#' comparison table for better readability and provides diagnostic warnings
#' if any R-squared values fall outside the standard 0 to 1 range.
#'
#' @param x An object of class `comp_model`.
#' @param digits Number of decimal places to be used for formatting numerical
#'   values. Default is `4`.
#' @param ... Further arguments passed to or from other methods.
#'
#' @details
#' The output is formatted using the `insight` package's `export_table()`
#' functionality, ensuring a clean and structured display in the console.
#'
#' In addition to the table, this method performs an automated check on the
#' R-squared values (columns 2 to 10). If any value exceeds 1.0 or falls
#' below 0.0, a warning message is displayed. This is a critical educational
#' feature, as it flags instances where specific \eqn{R^2} definitions become
#' mathematically inappropriate due to the lack of an intercept or model
#' misspecification.
#'
#' @return Returns the input object `x` invisibly.
#'
#' @seealso [comp_model()]
#'
#' @importFrom insight export_table
#' @export
print.comp_model <- function(x, ..., digits = 4){
  print(insight::export_table(x, digits = digits))

  if (any(x[, 2:10] > 1 | x[, 2:10] < 0)) {
    cat("---------------------------------\n")
    cat("\nNote: Some R2 values exceed 1.0 or are negative, indicating that ")
    cat("these definitions may be inappropriate for the no-intercept model.\n")
  }
  invisible(x)
}
