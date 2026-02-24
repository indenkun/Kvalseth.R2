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
  expect_equal(info_p$k, 1)      # log(x)
  expect_equal(info_p$df_res, 5) # 6 - 1
})

test_that("model_info extracts correct metadata from r2_kvr2 object", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model_no_int <- lm(y ~ x - 1, data = df1)
  res <- r2(model_no_int)

  info <- model_info(res)

  expect_type(info, "list")
  expect_equal(info$type, "linear")
  expect_false(info$has_intercept)
  expect_equal(info$n, 6)
  expect_equal(info$k, 1)      # x
  expect_equal(info$df_res, 5) # 6 - 1
})

test_that("model_info handles power regression metadata correctly", {
  df_pow <- data.frame(x = 1:5, y = c(2, 4, 8, 16, 32))
  model_pow <- lm(log(y) ~ log(x), data = df_pow)

  res_pow <- r2(model_pow, type = "power")
  info_pow <- model_info(res_pow)

  expect_equal(info_pow$type, "power")
  expect_true(info_pow$has_intercept)
  expect_equal(info_pow$n, 5)
  expect_equal(info_pow$k, 2)         # intercept + log(x)
})

test_that("model_info throws error for invalid input", {
  bad_obj <- list(a = 1, b = 2)
  expect_error(model_info(bad_obj))

  model_direct <- lm(speed ~ dist, data = cars)
  expect_error(model_info(model_direct))
})

test_that("model_info values are consistent with r2_adjusted internal logic", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)
  res_adj <- r2(model, adjusted = TRUE)
  info <- model_info(res_adj)

  a_manual <- (info$n - 1) / (info$n - info$k)
  expect_equal(a_manual, 1.25) # (6-1)/(6-2) = 1.25
})
