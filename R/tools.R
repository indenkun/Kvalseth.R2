# internal tools
check_lm <- function(model) stopifnot(inherits(model, "lm"))

values_lm <- function(model, type = c("auto", "linear", "power")){
  type <- match.arg(type)
  check_lm(model)

  if(type == "auto"){
    if(check_power(model)) type <- "power"
    else type <- "linear"
  }

  ans <- NULL

  ans$p <- model$rank
  ans$rdf <- model$df.residual
  ans$r <- model$residuals
  ans$f <- model$fitted.values
  ans$y <- stats::model.frame(model)[[1]]
  ans$n <- length(ans$y)
  ans$k <- length(stats::coef(model))

  if(type == "power"){
    ans$r <- exp(ans$r)
    ans$f <- exp(ans$f)
    ans$y <- exp(ans$y)
  }

  ans$e <- ans$y - ans$f

  ans$df_int <- attr(model$terms, "intercept")
  ans$a <- (ans$n - ans$df_int) / ans$rdf

  ans$type <- type

  ans
}

check_power <- function(model){
  resp <- as.character(attr(model$terms, "variables"))[2]
  grepl("^log\\(", resp)
}

lm_forced_int <- function(model){
  check_lm(model)

  mf <- stats::model.frame(model)
  if(attr(model$terms, "intercept")) X <- stats::model.matrix(stats::formula(model), mf)
  else X <- cbind(`Intercept` = 1, stats::model.matrix(stats::formula(model), mf))
  y <- stats::model.response(mf)

  qr_decomp <- qr(X)

  betas <- qr.coef(qr_decomp, y)

  residuals <- y - X %*% betas
  df_residual <- nrow(X) - ncol(X)

  sigma_sq <- sum(residuals^2) / df_residual

  R <- qr.R(qr_decomp)
  v_cov <- solve(t(R) %*% R) * sigma_sq
  std_errors <- sqrt(diag(v_cov))

  # betas_vec <- as.matrix(betas)
  # fitted_values <- X %*% betas_vec

  Q <- qr.Q(qr_decomp)
  fitted_values <- Q %*% (t(Q) %*% y)

  weigths <- stats::weights(model)

  results <- list(
    Estimate = betas,
    Std.Error = std_errors,
    t_value = betas / std_errors,
    fitted_values = fitted_values,
    residuals = residuals,
    weights = weigths
  )

  results
}

set_kvr2_attr <- function(x, v, class_name) {
  structure(x,
            type = v$type,
            has_intercept = (v$df_int == 1),
            n = v$n,
            k = v$k,
            df_res = v$rdf,
            class = class_name)
}
