library(tidyverse)
library(tidymodels)

# Read data
set.seed(123)
data <- read_csv("data/data-cleaned-transformed.csv") %>%
    select(-n) %>%
    mutate(class = as.factor(class)) # make class a factor variable

# Split data into test/training set.
data_split <- initial_split(data, strata = class)
data_train <- training(data_split)
data_test <- testing(data_split)

# Define recipe
recipe <- recipe(class ~ ., data = data_train)

# Define kNN model
knn_spec <- nearest_neighbor(mode = "classification", neighbors = 2) %>%
    set_engine("kknn")

# Create workflow
workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(knn_spec)

# Fit model
fit <- workflow %>%
    fit(data = data_train)

# Predict on test data
predictions <- predict(fit, data_test, type = "class") %>%
    bind_cols(data_test)

# Confusion matrix to evaluate performance
conf_mat(predictions, truth = class, estimate = .pred_class)

# Jessica's code
# #### Preparing the data
# ```{r}
# data_clean <- read_csv("data/drug-use-by-age-cleaned.csv")
# data_analysis <- data_clean %>%
#   select(-n, -age)
# ```
# Split into test/training set.
# ```{r}
# data_split <- initial_split(data_analysis, prop = 0.80)
# data_train <- training(data_split)
# data_test <- testing(data_split)
# ```

# ### Model
# Since all variables are on the same scale, we do not need to centre any data.
# ```{r}
# recipe <- recipe(class ~ ., data = data_train)

# knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = 3) %>%
#   set_engine("kknn") %>%
#   set_mode("classification")

# knn_fit <- workflow() %>%
#   add_recipe(recipe) %>%
#   add_model(knn_spec) %>%
#   fit(data = data_train)

# knn_fit
# ```

# ### Results: 
# ```{r}
# # Predict on test data
# predictions <- predict(knn_fit, data_test, type = "class") %>%
#   bind_cols(data_test)

# # Confusion matrix
# conf_mat <- conf_mat(predictions, truth = class, estimate = .pred_class)
# conf_mat
# ```


# Perform correlation analysis to identify significant predictors before modeling.
# Evaluate model performance using accuracy or RMSE.
