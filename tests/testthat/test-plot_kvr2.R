test_that("plot_kvr2 returns correct ggplot objects for single types", {
  df1 <- data.frame(x = 1:6, y = c(15, 37, 52, 59, 83, 92))
  model <- lm(y ~ x, data = df1)

  p_r2 <- plot_kvr2(model, plot_type = "r2")
  expect_s3_class(p_r2, "ggplot")

  expect_equal(nrow(p_r2$data), 9)
  expect_equal(toupper(p_r2$labels$y), "R-SQUARED VALUE")

  p_diag <- plot_kvr2(model, plot_type = "diag")
  expect_s3_class(p_diag, "ggplot")

})

test_that("plot_diagnostic handles lm_forced objects", {
  forced_obj <- list(y = 1:5, fitted_values = 1.1:5.1)
  class(forced_obj) <- "lm_forced"

  p <- plot_diagnostic(forced_obj)
  expect_s3_class(p, "ggplot")
  expect_equal(p$data$observed, 1:5)
})
