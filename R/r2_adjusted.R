#' Calculate the Adjusted Determination Coefficient
#' @description
#' Calculate the adjusted coefficient of determination by entering the regression model and coefficient of determination.
#' See details.
#' @inheritParams r2
#' @param r2 A numeric. Coefficient of determination.
#'
#' @return
#' A numeric vector or a list of class `r2_kvr2` containing the adjusted \eqn{R^2} values.
#' Each element represents the adjusted version of the corresponding \eqn{R^2} definition, accounting for the degrees of freedom.
#'
#' @details
#' The adjustment factor \eqn{a} is calculated using the following formula.
#' \deqn{a = (n - 1) / (n - k - 1)}
#' \eqn{n} is the sample size, and \eqn{k} is the number of parameters in the regression model.
#'
#' \eqn{R^2_a} (\eqn{R^2 adjusted}) is calculated using the following formula.
#' \deqn{R^2_a = 1 - a (1 - R^2)}
#'
#' This function performs freedom-of-degrees adjustment for all coefficients based on the above formula. However, Kvalseth (1985) recommends applying freedom-of-degrees adjustment only to \eqn{R^2_1} and \eqn{R^2_9}, based on the principle of consistency in coefficients.
#' Furthermore, there is no basis for applying the same type of adjustment to \eqn{R^2_6} (the square of the correlation coefficient) or to \eqn{R^2_7} and \eqn{R^2_8}, which depend on specific model forms.
#'
#' For details on each coefficient of determination, refer to [r2()].
#'
#' @references
#' Tarald O. Kvalseth (1985) Cautionary Note about R 2 , The American Statistician, 39:4, 279-285, \doi{10.1080/00031305.1985.10479448}
#'
#' @seealso [r2()]
#'
#' @export
r2_adjusted <- function(model, r2){
  v <- values_lm(model)

  r2_adjusted <- 1 - (1 - r2) * v$a
  names(r2_adjusted) <- paste(names(r2), "adjusted", sep = "_")
  # class(r2_adjusted) <- "r2_kvr2"
  r2_adjusted <- set_kvr2_attr(r2_adjusted, v = v, class_name = "r2_kvr2")

  r2_adjusted
}
