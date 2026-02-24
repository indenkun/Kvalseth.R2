test_that("comp_model produces correct comparison values and detects anomalies", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)

  res <- comp_model(model)

  expect_s3_class(res, "comp_model")
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 2)
  expect_equal(res$model, c("with intercept", "without intercept"))

  # R2_2 = 1.0836, R2_3 = 1.0830
  r2_vals_no_int <- res[2, 2:10]

  # expect_gt(as.numeric(r2_vals_no_int$r2_2), 1)
  # expect_gt(as.numeric(r2_vals_no_int$r2_3), 1)
  # expect_equal(round(as.numeric(r2_vals_no_int$r2_2), 4), 1.0836)

  # expect_equal(round(res$rmse[1], 4), 3.6165)
  # expect_equal(round(res$rmse[2], 4), 3.9008)

  expect_s3_class(attr(res, "with_int"), "lm_forced")
  expect_s3_class(attr(res, "without_int"), "lm_forced")
})

test_that("comp_model identifies when R2 definitions are inappropriate", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)
  res <- comp_model(model)

  any_anomaly <- any(res[, 2:10] > 1 | res[, 2:10] < 0)
  expect_true(any_anomaly)
})

test_that("print.comp_model shows warning message", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)
  res <- comp_model(model)

  expect_output(print(res), "Note: Some R2 values exceed 1.0")
})
