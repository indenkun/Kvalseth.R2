test_that("Test that model_info returns correct structure and values", {
  df <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df)
  res <- r2(model)

  info <- model_info(res)

  expect_type(info, "list")
  expect_named(info, c("type", "has_intercept", "n", "k", "df_res"))

  expect_equal(info$type, "linear")
  expect_true(info$has_intercept)
  expect_equal(info$n, 6)
  expect_equal(info$k, 2)
  expect_equal(info$df_res, 4)

  expect_type(info$has_intercept, "logical")
  expect_type(info$n, "integer")
})

test_that("Test that model_info works correctly for no-intercept power models", {
  df <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model_p <- lm(log(y) ~ log(x) - 1, data = df)
  res_p <- r2(model_p)

  info_p <- model_info(res_p)

  expect_equal(info_p$type, "power")
  expect_false(info_p$has_intercept)
  expect_equal(info_p$k, 1)      # log(x) のみ
  expect_equal(info_p$df_res, 5) # 6 - 1
})
