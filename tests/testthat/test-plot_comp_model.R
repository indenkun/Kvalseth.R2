test_that("internal plotting functions for comp_model return valid ggplot objects", {
  df <- data.frame(x = 1:5, y = c(2, 3, 5, 4, 6))
  m1 <- lm(y ~ x, df)
  res <- comp_model(m1)

  p_r2 <- .plot_comp_r2(res)
  expect_s3_class(p_r2, "ggplot")
  expect_equal(nrow(p_r2$data), 18)
  # expect_equal(levels(p_r2$data$model), c("with intercept", "without intercept"))

  p_fit <- .plot_comp_fit(res)
  expect_s3_class(p_fit, "ggplot")
  expect_equal(nrow(p_fit$data), 6)
  expect_true(all(c("RMSE", "MAE", "MSE") %in% p_fit$data$Metric))
})

test_that("plot.comp_model fails gracefully if attributes are missing", {
  df_fake <- data.frame(a = 1:2)
  class(df_fake) <- "comp_model"

  expect_error(plot(df_fake))
})
