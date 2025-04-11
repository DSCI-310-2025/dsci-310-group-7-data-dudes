"This script trains several models, generates confusion matrices, and saves the results as figures and tables.
Usage: script.R --data=<data_file> --output_path=<output_path>

Options:
--data=<data_file>               Path to the data file
--output_path=<output_path>      Path to the output directory
" -> doc

# Load necessary libraries
library(docopt)
library(parsnip)
library(recipes)
library(workflows)
library(dplyr)
library(rsample)
library(readr)
library(survey.workflow)

# Parse command-line arguments
opt <- docopt(doc)

# Extract arguments
data_file <- opt$data
output_path <- opt$output_path

create_directory(output_path)

# Read data
set.seed(123)

data <- read_csv(data_file) %>%
  select(-n, -age) %>%
  mutate(class = as.factor(class)) # Convert class to a factor variable

# Split data into training and testing sets
data_split <- initial_split(data, strata = class)
data_train <- training(data_split)
data_test <- testing(data_split)

# Define recipe
recipe <- recipe(class ~ ., data = data_train) %>%
  step_normalize(all_numeric_predictors())

# Define model specifications
knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = 5) %>%
  set_engine("kknn") %>%
  set_mode("classification")

log_reg_spec <- logistic_reg(mode = "classification") %>%
  set_engine("glm")

tree_spec <- decision_tree() %>%
  set_engine("rpart") %>%
  set_mode("classification")

# Train and evaluate each model
model_specs <- list(
  knn = knn_spec,
  logistic_regression = log_reg_spec,
  decision_tree = tree_spec
)

for (model_name in names(model_specs)) {
  model_spec <- model_specs[[model_name]]
  
  # Train and get predictions
  predictions <- train_and_predict(model_spec, data_train, data_test, recipe)
  
  # Create confusion matrix outputs
  conf_plot <- create_confusion_outputs(predictions, model_name, output_path)
}
