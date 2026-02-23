#' Calculate Comparative Fit Measures for Regression Models
#'
#' @description
#' Calculates goodness-of-fit metrics based on Kvalseth (1985), including
#' Root Mean Squared Error (RMSE), Mean Absolute Error (MAE), and Mean Squared
#' Error (MSE). This function provides a unified output for comparing different
#' model specifications.
#'
#' @inheritParams r2
#'
#' @details
#' The metrics are calculated according to the formulas in Kvalseth (1985):
#'
#' \itemize{
#'   \item \bold{RMSE}: Root Mean Squared Residual or Error
#'     \deqn{RMSE = \sqrt{\frac{\sum (y - \hat{y})^2}{n}}}
#'   \item \bold{MAE}: Mean Absolute Residual or Error
#'     \deqn{MAE = \frac{\sum |y - \hat{y}|}{n}}
#'   \item \bold{MSE}: Mean Squared Residual or Error (Adjusted for degrees of freedom)
#'     \deqn{MSE = \frac{\sum (y - \hat{y})^2}{n - p}}
#' }
#' where \eqn{n} is the sample size and \eqn{p} is the number of model parameters
#' (including the intercept).
#'
#' **Note on MSE:** In many modern contexts, "MSE" refers to the mean
#' squared error without degree-of-freedom adjustment (denominator \eqn{n}).
#' However, this function follows Kvalseth's definition, which uses \eqn{n - p}
#' as the denominator.
#'
#' @return
#' \itemize{
#'   \item For `comp_fit()`: An object of class `comp_kvr2`, which is a list
#'     containing the calculated RMSE, MAE, and MSE values.
#'   \item For individual functions (`RMSE()`, `MAE()`, `MSE()`):
#'     A named numeric value of the specific metric.
#' }
#' @examples
#' # example data set 1. Kvålseth (1985).
#' df1 <- data.frame(x = c(1:6),
#'                  y = c(15,37,52,59,83,92))
#' model_intercept <- lm(y ~ x, df1)
#' model_without <- lm(y ~ x - 1, df1)
#' model_power <- lm(log(y) ~ log(x), df1)
#' comp_fit(model_intercept)
#' comp_fit(model_without)
#' comp_fit(model_power)
#'
#' @references
#' Tarald O. Kvalseth (1985) Cautionary Note about R 2 , The American Statistician, 39:4, 279-285, \doi{DOI: 10.1080/00031305.1985.10479448}
#'
#' @seealso [print.comp_kvr2()]
#'
#' @inherit r2 note
#' @rdname comp_kvr2
#' @export
comp_fit <- function(model, type = c("auto", "linear", "power")){
  type <- match.arg(type)

  ans <- list()

  ans <- list(rmse = RMSE(model, type),
              mae = MAE(model, type),
              mse = MSE(model, type))

  # class(ans) <- "comp_kvr2"
  v <- values_lm(model, type)
  ans <- set_kvr2_attr(ans, v = v, class_name = "comp_kvr2")

  ans
}

#' @rdname comp_kvr2
#' @export
RMSE <- function(model, type = c("auto", "linear", "power")){
  type <- match.arg(type)

  v <- values_lm(model, type)
  # ans <- list()

  ans <- sqrt(sum((v$y - v$f)^2) / v$n)
  names(ans) <- "RMSE"

  # ans$rmse <- rmse
  # ans <- set_kvr2_attr(ans, v = v, class_name = "comp_kvr2")
  ans
}

#' @rdname comp_kvr2
#' @export
MAE <- function(model, type = c("auto", "linear", "power")){
  type <- match.arg(type)

  v <- values_lm(model, type)
  # ans <- list()

  ans <- sum(abs(v$y - v$f)) / v$n
  names(ans) <- "MAE"

  # ans$mae <- mae
  # ans <- set_kvr2_attr(ans, v = v, class_name = "comp_kvr2")
  ans
}

#' @rdname comp_kvr2
#' @export
MSE <- function(model, type = c("auto", "linear", "power")){
  type <- match.arg(type)

  v <- values_lm(model, type)
  # ans <- list()

  ans <- sum((v$y - v$f)^2) / (v$n - v$p)
  names(ans) <- "MSE"

  # ans$mse <- mse
  # ans <- set_kvr2_attr(ans, v = v, class_name = "comp_kvr2")
  ans
}
