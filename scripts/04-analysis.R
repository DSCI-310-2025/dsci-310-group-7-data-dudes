"This script trains several models, generates confusion matrices, and saves the results as figures and tables.
Usage: script.R --data=<data_file> --output_path=<output_path>

Options:
--data=<data_file>               Path to the data file
--output_path=<output_path>      Path to the output directory
" -> doc

# Load necessary libraries
library(docopt)
library(dplyr)       # for select, mutate
library(tidymodels)

source("R/create_directory.R")
source("R/load_csv.R")
source("R/train_and_evaluate.R")


# Parse command-line arguments
opt <- docopt(doc)

# Extract arguments
data_file <- opt$data
output_path <- opt$output_path

#TEMP
data_file <- "data/clean/data-cleaned.csv"
output_path <- "output/results"

create_directory(output_path)

# Read data
set.seed(123)

data <- load_csv(data_file) %>%
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

# Train models and store results
train_and_evaluate(knn_spec, "knn", data_train, data_test, recipe, output_path)
train_and_evaluate(log_reg_spec, "logistic-regression", data_train, data_test, recipe, output_path)
train_and_evaluate(tree_spec, "decision-tree", data_train, data_test, recipe, output_path)
