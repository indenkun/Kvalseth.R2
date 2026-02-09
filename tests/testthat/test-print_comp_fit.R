test_that("Test that comp_fit() output format is correct", {
  # df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92)))
  res <- comp_fit(model)

  # Check whether a specific string is displayed
  expect_output(print(res), "RMES :")
  expect_output(print(res), "MAE :")
  expect_output(print(res), "MSE :")

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "RMES :  3.6165",
    "MAE :  3.5238",
    "MSE :  19.6190",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that model without intercept", {
  # df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x - 1, data = data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92)))
  res <- comp_fit(model)

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "RMES :  3.9008",
    "MAE :  3.6520",
    "MSE :  18.2593",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that power model", {
  # df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(log(y) ~ log(x), data = data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92)))
  res <- comp_fit(model)

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "RMES :  3.8982",
    "MAE :  3.6334",
    "MSE :  22.7938",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that multiple model", {
  model <- lm(y ~ x1 + x2, data = data.frame(x1 = c(0.34, 0.34, 0.58, 1.26, 1.26, 1.82),
                                             x2 = c(0.73, 0.73, 0.69, 0.97, 0.97, 0.46),
                                             y = c(5.75, 4.79, 5.44, 9.09, 8.59, 5.09)))
  res <- comp_fit(model)
  res

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "RMES :  0.3177",
    "MAE :  0.2665",
    "MSE :  0.2019",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that multiple model without intercept", {
  model_no_int <- lm(y ~ x1 + x2 - 1, data = data.frame(x1 = c(0.34, 0.34, 0.58, 1.26, 1.26, 1.82),
                                                        x2 = c(0.73, 0.73, 0.69, 0.97, 0.97, 0.46),
                                                        y = c(5.75, 4.79, 5.44, 9.09, 8.59, 5.09)))
  res <- comp_fit(model_no_int)
  res

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "RMES :  0.4709",
    "MAE :  0.3897",
    "MSE :  0.3327",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})
