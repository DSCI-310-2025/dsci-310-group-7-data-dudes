#' Train a model and generate class predictions
#'
#' @description This function takes a model specification and a recipe, fits the model on the training data,
#' and returns predictions on the testing data.
#'
#' @param model_spec A tidymodels model specification.
#' @param data_train A data frame containing the training data.
#' @param data_test A data frame containing the testing data.
#' @param recipe A tidymodels recipe for preprocessing the data.
#'
#' @return A data frame containing the predicted classes along with the original `data_test` columns.
#'
#' @import tidymodels
#' @export
#' 
#' @example
#' # Example usage of the `train_and_predict` function
#' set.seed(123)
#' data <- tibble(
#'   class = sample(c("A", "B"), 150, replace = TRUE),
#'   feature1 = rnorm(150),
#'   feature2 = rnorm(150)
#' )
#'
#' # Split the data into training and testing sets
#' data_split <- initial_split(data, prop = 0.8)
#' data_train <- training(data_split)
#' data_test <- testing(data_split)
#'
#' # Define the model specification
#' model_spec <- decision_tree() %>%
#'   set_engine("rpart") %>%
#'   set_mode("classification")
#'
#' # Define the recipe (preprocessing)
#' recipe <- recipe(class ~ feature1 + feature2, data = data_train) %>%
#'   step_normalize(all_numeric())
#'
#' # Run the function
#' predictions <- train_and_predict(model_spec, data_train, data_test, recipe)
#' head(predictions)
train_and_predict <- function(model_spec, data_train, data_test, recipe) {
  workflow <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(model_spec)
  
  fit <- workflow %>%
    fit(data = data_train)
  
  predictions <- predict(fit, data_test, type = "class") %>%
    bind_cols(data_test)
  
  return(predictions)
}
