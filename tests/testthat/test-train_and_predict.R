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

test_that("train_and_predict runs without errors", {
  predictions <- train_and_predict(model_spec, data_train, data_test, recipe)
  
  # Check that predictions is a tibble and contains expected columns
  expect_s3_class(predictions, "tbl_df")
  expect_true(".pred_class" %in% colnames(predictions))
  expect_true("class" %in% colnames(predictions))
})

test_that("train_and_predict generates predictions for all test data", {
  predictions <- train_and_predict(model_spec, data_train, data_test, recipe)
  
  # Check if the number of predictions matches the number of test samples
  expect_equal(nrow(predictions), nrow(data_test))
  
  # Check if predictions have the correct class labels
  expect_true(all(predictions$.pred_class %in% c("A", "B")))
})

# Define the models for testing
log_reg_spec <- logistic_reg(mode = "classification") %>%
  set_engine("glm")

tree_spec <- decision_tree() %>%
  set_engine("rpart") %>%
  set_mode("classification")

# Test with different expected inputs
test_that("train_and_predict works with different model specs", {
  # Define the models for testing
  log_reg_spec <- logistic_reg(mode = "classification") %>%
    set_engine("glm")
  
  tree_spec <- decision_tree() %>%
    set_engine("rpart") %>%
    set_mode("classification")
  
  # Test with Logistic Regression model
  log_reg_predictions <- train_and_predict(log_reg_spec, data_train, data_test, recipe)
  expect_s3_class(log_reg_predictions, "tbl_df")
  expect_true(".pred_class" %in% colnames(log_reg_predictions))
  expect_true("class" %in% colnames(log_reg_predictions))
  
  # Test with Decision Tree model
  tree_predictions <- train_and_predict(tree_spec, data_train, data_test, recipe)
  expect_s3_class(tree_predictions, "tbl_df")
  expect_true(".pred_class" %in% colnames(tree_predictions))
  expect_true("class" %in% colnames(tree_predictions))
})

test_that("train_and_predict handles missing class column", {
  # Remove the class column
  data_no_class <- data_train %>%
    select(-class)
  
  expect_error(train_and_predict(model_spec, data_no_class, data_test, recipe), 
               "class")
})