library(testthat)
library(tibble)
library(ggplot2)
library(dplyr)
library(tidyr)
source("R/eda_functions.R")

# Sample edge-case data
sample_edge_data <- tibble(
  age = c("18-24"),
  `alcohol-use` = c(80),
  `marijuana-use` = c(50),
  `heroin-frequency` = c(5),
  class = c("youth"),
  n = c(100)
)

# Sample data
sample_data <- tibble(
  age = c("18-24", "25-34", "35-44"),
  `alcohol-use` = c(80, 75, 60),
  `alcohol-frequency` = c(20, 15, 10),
  `marijuana-use` = c(50, 30, 20),
  `heroin-frequency` = c(5, 3, 2),
  class = c("youth", "adult", "adult"),
  n = c(100, 200, 150)
)

sample_aggregated <- tibble(
  class = c("adult", "adult", "adult", "adult", "adult", "youth", "youth", "youth", "youth", "youth"),
  total_n = c(350, 350, 350, 350, 350, 100, 100, 100, 100, 100),
  variable = c("alcohol-use", "alcohol-frequency", "marijuana-use", "heroin-frequency", "n", "alcohol-use", "alcohol-frequency", "marijuana-use", "heroin-frequency", "n"),
  value = c(68.6, 12.9, 25.7, 2.57, 179., 80, 20, 50, 5, 100),
)

# tests for bar plot for age vs. drug use
test_that("create_bar_use_plot generates a plot object", {
  p <- create_bar_use_plot(sample_data, "age", "alcohol-use", "Alcohol Use", "Age", "Proportion", "dodgerblue", "output/eda-test/test1.png")
  expect_s3_class(p, "ggplot")
})
test_that("create_bar_use_plot can handle a lower edge case; minimal dataset", {
  expect_silent(create_bar_use_plot(sample_edge_data, "age", "alcohol-use", "Alcohol Use", "Age", "Proportion", "dodgerblue", "output/eda-test/test2.png"))
})

# tests for bar plot for age vs. drug use frequency
test_that("create_bar_freq_plot generates a plot object", {
  p <- create_bar_freq_plot(sample_data, "age", "heroin-frequency", "Median Heroin Use Frequency in the Past Year by Age", "Age", "Median Frequency", "salmon", "output/eda-test/test3.png")
  expect_s3_class(p, "ggplot")
})
test_that("create_bar_freq_plot can handle a lower edge case; minimal dataset", {
  expect_silent(create_bar_freq_plot(sample_edge_data, "age", "heroin-frequency", "Median Heroin Use Frequency in the Past Year by Age", "Age", "Median Frequency", "salmon", "output/eda-test/test4.png"))
})

# test whether scatter plot function for use frequency is returning a plot object
test_that("create_scatter_plot generates a plot object", {
  p <- create_scatter_plot(sample_data, "alcohol-frequency", "heroin-frequency", "age", "Relationship Between Alcohol and Heroin Frequency Use", "Alcohol Median Frequency", "Heroin Median Frequency", "output/eda-test/test5.png")
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
  expect_equal(result, sample_aggregated, tolerance = 1e-2, ignore_attr = TRUE)  # Check against expected result
})

# test that the grouped bar plot function works
test_that("create_grouped_bar_plot generates a plot object", {
  p <- create_grouped_bar_plot(sample_aggregated, "Youth vs. Adult Comparison", "Substance Type", "Mean Substance Use (%)", "output/eda-test/test6.png")
  expect_s3_class(p, "ggplot")
})
