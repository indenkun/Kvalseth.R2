test_that("Test that r2() output format is correct", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  # model <- lm(y ~ x, data = data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92)))
  model <- lm(y ~ x, data = df1)
  res <- r2(model)

  # Check whether a specific string is displayed
  expect_output(print(res), "R2_1 :")
  expect_output(print(res), "R2_9 :")

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "R2_1 :  0.9808",
    "R2_2 :  0.9808",
    "R2_3 :  0.9808",
    "R2_4 :  0.9808",
    "R2_5 :  0.9808",
    "R2_6 :  0.9808",
    "R2_7 :  0.9966",
    "R2_8 :  0.9966",
    "R2_9 :  0.9778",
    "---------------------------------",
    "\\(Type: linear, with intercept, n: 6, k: 2\\)",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that model without intercept", {
  # df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model_no_int <- lm(y ~ x - 1, data = data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92)))
  res <- r2(model_no_int)
  res

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "R2_1 :  0.9777",
    "R2_2 :  1.0836",
    "R2_3 :  1.0830",
    "R2_4 :  0.9783",
    "R2_5 :  0.9808",
    "R2_6 :  0.9808",
    "R2_7 :  0.9961",
    "R2_8 :  0.9961",
    "R2_9 :  0.9717",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that power model",{
  # df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model_power <- lm(log(y) ~ log(x), data = data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92)))
  res <- r2(model_power)
  res

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "R2_1 :  0.9777",
    "R2_2 :  1.0984",
    "R2_3 :  1.0983",
    "R2_4 :  0.9778",
    "R2_5 :  0.9816",
    "R2_6 :  0.9811",
    "R2_7 :  0.9961",
    "R2_8 :  1.0232",
    "R2_9 :  0.9706",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that multiple model without intercept", {
  model_no_int <- lm(y ~ x1 + x2 - 1, data = data.frame(x1 = c(0.34, 0.34, 0.58, 1.26, 1.26, 1.82),
                                                        x2 = c(0.73, 0.73, 0.69, 0.97, 0.97, 0.46),
                                                        y = c(5.75, 4.79, 5.44, 9.09, 8.59, 5.09)))
  res <- r2(model_no_int)
  res

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "R2_1 :  0.9247",
    "R2_2 :  0.6169",
    "R2_3 :  0.6153",
    "R2_4 :  0.9263",
    "R2_5 :  0.9657",
    "R2_6 :  0.9656",
    "R2_7 :  0.9950",
    "R2_8 :  0.9950",
    "R2_9 :  0.9661",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})

test_that("Test that power model",{
  # df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model_power <- lm(log(y) ~ log(x1) + log(x2), data = data.frame(x1 = c(0.34, 0.34, 0.58, 1.26, 1.26, 1.82),
                                                                  x2 = c(0.73, 0.73, 0.69, 0.97, 0.97, 0.46),
                                                                  y = c(5.75, 4.79, 5.44, 9.09, 8.59, 5.09)))
  res <- r2(model_power)
  res

  # Validate the format of a number (e.g., four decimal places) using regular expressions
  expected_pattern <- paste(
    "R2_1 :  0.9653",
    "R2_2 :  0.9639",
    "R2_3 :  0.9638",
    "R2_4 :  0.9653",
    "R2_5 :  0.9500",
    "R2_6 :  0.9653",
    "R2_7 :  0.9977",
    "R2_8 :  0.9949",
    "R2_9 :  0.9729",
    sep = "\\s+"
  )
  expect_output(print(res), expected_pattern)
})
