library(testthat)
library(tidymodels)
library(caret)
library(ggplot2)

# Generate a random dataset
set.seed(123)
data <- tibble(
  class = sample(c("A", "B"), 150, replace = TRUE),
  feature1 = rnorm(150),
  feature2 = rnorm(150)
)

# Split the data into training and testing sets (80% training, 20% testing)
data_split <- initial_split(data, prop = 0.8)
data_train <- training(data_split)
data_test <- testing(data_split)

# Convert the class labels to factors with the same levels
data_train$class <- factor(data_train$class, levels = c("A", "B"))
data_test$class <- factor(data_test$class, levels = c("A", "B"))

# A simple recipe to preprocess the data
recipe <- recipe(class ~ feature1 + feature2, data = data_train) %>%
  step_normalize(all_numeric())

# A basic model specification (e.g., decision tree)
model_spec <- decision_tree() %>%
  set_engine("rpart") %>%
  set_mode("classification")

# Mock output path
output_path <- tempdir()  # Use tempdir for testing

test_that("train_and_evaluate runs without errors", {
expect_message(
    train_and_evaluate(model_spec, "decision_tree", data_train, data_test, recipe, output_path),
    message("Confusion matrix figure (PNG) and table (CSV) saved at:", output_path)
  )
})

test_that("train_and_evaluate generates a confusion matrix figure (PNG)", {
  result <- train_and_evaluate(model_spec, "decision_tree", data_train, data_test, recipe, output_path)
  
  # Expected file paths
  expected_plot_path <- file.path(output_path, "decision_tree_confusion-matrix.png")
  
  # Check if the PNG and CSV files are saved at the expected locations
  expect_true(file.exists(expected_plot_path), info = paste("PNG file not saved at", expected_plot_path))
})

test_that("train_and_evaluate generates a confusion matrix table (CSV)", {
  result <- train_and_evaluate(model_spec, "decision_tree", data_train, data_test, recipe, output_path)
  
  # Expected file paths
  expected_table_path <- file.path(output_path, "decision_tree_confusion-matrix.csv")
  
  # Check if the PNG and CSV files are saved at the expected locations
  expect_true(file.exists(expected_table_path), info = paste("CSV file not saved at", expected_table_path))
})
