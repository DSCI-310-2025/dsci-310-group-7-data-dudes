library(tidyverse)
library(tidymodels)

# Read data
set.seed(123)
data <- read_csv("data/data-cleaned-transformed.csv") %>%
    select(-n, -age) %>%
    mutate(class = as.factor(class)) # make class a factor variable

# Split data into test/training set.
data_split <- initial_split(data, strata = class)
data_train <- training(data_split)
data_test <- testing(data_split)

# Define recipe
recipe <- recipe(class ~ ., data = data_train) %>%
    step_normalize(all_numeric_predictors())

# Define knn model
knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = 5) %>%
    set_engine("kknn") %>%
    set_mode("classification")

# Create workflow
knn_workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(knn_spec)

# Fit model
knn_fit <- knn_workflow %>%
    fit(data = data_train)

# Predict on test data
predictions <- predict(knn_fit, data_test, type = "class") %>%
    bind_cols(data_test)

# Confusion matrix
conf_mat <- conf_mat(predictions, truth = class, estimate = .pred_class)
conf_mat

# # # # # # # #
# # Define logistic regression model
# log_reg_spec <- logistic_reg(mode = "classification") %>%
#     set_engine("glm")

# # Create workflow
# log_reg_workflow <- workflow() %>%
#     add_recipe(recipe) %>%
#     add_model(log_reg_spec)

# # Fit model
# log_reg_fit <- log_reg_workflow %>%
#     fit(data = data_train)

# # Predict on test data
# predictions <- predict(log_reg_fit, data_test, type = "class") %>%
#     bind_cols(data_test)

# # Confusion matrix
# conf_mat <- conf_mat(predictions, truth = class, estimate = .pred_class)
# conf_mat

# # # # # # # #
# # Define Decision Tree model
# tree_spec <- decision_tree() %>%
#     set_engine("rpart") %>%
#     set_mode("classification")

# # Create workflow
# tree_workflow <- workflow() %>%
#     add_recipe(recipe) %>%
#     add_model(tree_spec)

# # Fit model
# tree_fit <- tree_workflow %>%
#     fit(data = data_train)

# # Predict on test data
# predictions <- predict(tree_fit, data_test, type = "class") %>%
#     bind_cols(data_test)

# # Confusion matrix
# conf_mat <- conf_mat(predictions, truth = class, estimate = .pred_class)
# conf_mat
