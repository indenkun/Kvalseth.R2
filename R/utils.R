#' Get Model Information Used for Calculations
#'
#' @description
#' Extracts the metadata and model specifications used to calculate the
#' coefficients of determination, such as the regression type,
#' sample size, and degrees of freedom.
#'
#' @param x An object of class `r2_kvr2` or `comp_kvr2`.
#'
#' @details
#' This function provides transparency into the calculation process of the
#' various R-squared definitions. It is particularly useful for verifying
#' whether a model was treated as a "power" regression (log-transformed)
#' and how the degrees of freedom were determined for adjusted R-squared values.
#'
#' @return A list containing the following components:
#' \itemize{
#'   \item `type`: A string indicating the regression type ("linear" or "power").
#'   \item `has_intercept`: A logical value indicating if the model includes an intercept.
#'   \item `n`: The number of observations used in the model (excluding missing values).
#'   \item `k`: The number of estimated parameters (including the intercept if present).
#'   \item `df_res`: Residual degrees of freedom (\eqn{n - k}).
#' }
#'
#' @note
#' The sample size `n` refers to the actual number of observations
#' used by [lm()], which may be fewer than the rows in the original
#' data frame if `NA` values were present.
#'
#' @seealso [r2()], [comp_fit()]
#'
#' @examples
#' df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#' model <- lm(y ~ x, data = df1)
#' res <- r2(model)
#'
#' # Check the metadata
#' info <- model_info(res)
#' info$n
#' info$type
#'
#' @export
model_info <- function(x){
  stopifnot((inherits(x, c("r2_kvr2", "comp_kvr2"))))
  list(type = attr(x, "type"),
       has_intercept = attr(x, "has_intercept"),
       n = attr(x, "n"),
       k = attr(x, "k"),
       df_res = attr(x, "df_res"))
}
