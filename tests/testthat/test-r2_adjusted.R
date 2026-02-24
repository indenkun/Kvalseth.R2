test_that("r2_adjusted calculates values correctly via r2(adjusted = TRUE)", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)

  # n = 6, k = 2 (intercept + x)
  # a = (6 - 1) / (6 - 2) = 5 / 4 = 1.25
  n <- 6
  k <- 2
  a_expected <- (n - 1) / (n - k)

  res_raw <- r2(model, adjusted = FALSE)
  r2_1_raw <- as.numeric(res_raw$r2_1)
  r2_1_adj_expected <- 1 - (1 - r2_1_raw) * a_expected

  res <- r2(model, adjusted = TRUE)

  expect_s3_class(res, "r2_kvr2")

  expect_true(all(grepl("_adj$", names(res))))
  expect_equal(length(res), 9)

  expect_equal(as.numeric(res$r2_1_adj), r2_1_adj_expected, tolerance = 1e-4)

  expect_equal(round(as.numeric(res$r2_1_adj), 4), 0.9760)
})

test_that("r2_adjusted returns correct names and types", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)

  res_raw <- r2(model)
  res_adj <- r2_adjusted(model, res_raw$r2_1)

  expect_type(res_adj, "double")
  expect_named(res_adj, paste0(names(res_raw$r2_1), "_adj"))
})

# test_that("r2_adjusted handles models without intercept correctly", {
#   df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
#   model0 <- lm(y ~ x - 1, data = df1)
#
#   res <- r2(model0, adjusted = TRUE)
#
#   expect_true(all(res <= 1))
# })
