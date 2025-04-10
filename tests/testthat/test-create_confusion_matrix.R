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

# Generate predictions using train_and_predict
predictions <- train_and_predict(model_spec, data_train, data_test, recipe)

# Mock output path
output_path <- tempdir()  # Use tempdir for testing

test_that("create_confusion_outputs generates a ggplot object", {
  conf_plot <- create_confusion_outputs(predictions, "decision_tree", output_path)
  
  # Check that the returned object is a ggplot object
  expect_s3_class(conf_plot, "gg")  # ggplot objects are of class 'gg'
})

test_that("create_confusion_outputs generates a ggplot object with different model inputs", {
  # Test with decision tree
  conf_plot_tree <- create_confusion_outputs(predictions, "decision_tree", output_path)
  expect_s3_class(conf_plot_tree, "gg")
  
  # Test with logistic regression
  model_spec_logreg <- logistic_reg() %>%
    set_engine("glm") %>%
    set_mode("classification")
  
  predictions_logreg <- train_and_predict(model_spec_logreg, data_train, data_test, recipe)
  conf_plot_logreg <- create_confusion_outputs(predictions_logreg, "logistic_regression", output_path)
  expect_s3_class(conf_plot_logreg, "gg")
})

test_that("create_confusion_outputs generates a confusion matrix figure (PNG)", {
  create_confusion_outputs(predictions, "decision_tree", output_path)
  
  # Expected file path for PNG
  expected_plot_path <- file.path(output_path, "decision_tree_confusion-matrix.png")
  
  # Check if the PNG file is saved at the expected location
  expect_true(file.exists(expected_plot_path), info = paste("PNG file not saved at", expected_plot_path))
})

test_that("create_confusion_outputs generates a confusion matrix table (CSV)", {
  create_confusion_outputs(predictions, "decision_tree", output_path)
  
  # Expected file path for CSV
  expected_table_path <- file.path(output_path, "decision_tree_confusion-matrix.csv")
  
  # Check if the CSV file is saved at the expected location
  expect_true(file.exists(expected_table_path), info = paste("CSV file not saved at", expected_table_path))
})

test_that("create_confusion_outputs handles invalid model_name", {
  # Pass an empty string as model_name
  expect_error(create_confusion_outputs(predictions, "", output_path),
               "Model name cannot be empty")
  
  # Pass NULL as model_name
  expect_error(create_confusion_outputs(predictions, NULL, output_path),
               "Model name cannot be NULL")
})