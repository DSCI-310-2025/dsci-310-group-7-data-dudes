library(testthat)
library(dplyr)
library(readr)
source("R/data_cleaning.R")

test_that("clean_drug_use_data correctly converts values", {
  sample_data <- data.frame(age = c("10", "20", "30"), drug_use = c("5", "-", "10"))
  cleaned <- clean_drug_use_data(sample_data)
  
  expect_s3_class(cleaned$age, "factor")
  expect_true(is.numeric(cleaned$drug_use))
  expect_true(is.na(cleaned$drug_use[2]))
})

test_that("classify_age_group correctly assigns class", {
  sample_data <- data.frame(age = factor(c("10", "20", "30")))
  classified <- classify_age_group(sample_data)
  
  expect_equal(classified$class, c("youth", "youth", "adult"))
})

test_that("save_data creates a file", {
  temp_file <- tempfile(fileext = ".csv")
  sample_data <- data.frame(age = factor("10"), class = "youth")
  
  save_data(sample_data, temp_file)
  expect_true(file.exists(temp_file))
})
