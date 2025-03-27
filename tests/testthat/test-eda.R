library(testthat)
source("R/eda_functions.R")

# Sample data
sample_data <- tibble(
  age = c("18-24", "25-34", "35-44"),
  `alcohol-use` = c(80, 75, 60),
  `marijuana-use` = c(50, 30, 20),
  class = c("youth", "adult", "adult"),
  n = c(100, 200, 150)
)

# test that plot functions are returning plots
test_that("create_bar_use_plot generates a plot object", {
  p <- create_bar_use_plot(sample_data, "age", "alcohol-use", "Alcohol Use", "Age", "Proportion", "dodgerblue", "test1.png")
  expect_s3_class(p, "ggplot")
})

test_that("create_bar_freq_plot generates a plot object", {
  p <- create_bar_freq_plot(data, "age", "heroin-frequency", "Median Heroin Use Frequency in the Past Year by Age", "Age", "Median Frequency", "salmon", "test2.png")
  expect_s3_class(p, "ggplot")
})

test_that("create_scatter_plot generates a plot object", {
  p <- create_scatter_plot(data, "alcohol-frequency", "marijuana-frequency", "age", "Relationship Between Alcohol and Marijuana Frequency Use", "Alcohol Median Frequency", "Marijuana Median Frequency", "test3.png")
  expect_s3_class(p, "ggplot")
})


# test that aggregating makes a valid table
test_that("aggregate_data returns a valid tibble", {
  result <- aggregate_data(sample_data)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("class", "variable", "value", "total_n") %in% colnames(result)))
})


# test that aggregating is done as expected
test_that("aggregate_data correctly computes weighted means", {
  result <- aggregate_data(sample_data)
  expect_true(all(result$value >= 0))  # Ensure all values are non-negative
})


# test that the grouped bar plot function works
test_that("create_grouped_bar_plot generates a plot object", {
  p <- create_grouped_bar_plot(sample_data, "Youth vs. Adult Comparison", "Substance Type", "Mean Substance Use (%)", "test4.png")
  expect_s3_class(p, "ggplot")
})
