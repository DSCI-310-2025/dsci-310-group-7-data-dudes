"This script trains several models, generates confusion matrices, and saves the results as figures and tables.
Usage: script.R --data=<data_file> --output_prefix=<output_prefix>

Options:
--data=<data_file>           Path to the data file
--output_prefix=<output_prefix>  Prefix for the output files
" -> doc

# Load necessary libraries
library(docopt)
library(readr)       # for read_csv
library(dplyr)       # for select, mutate
library(tidymodels)  # for initial_split, training, testing, workflow, etc.
library(caret)       # for confusionMatrix
library(ggplot2)     # for ggplot, geom_tile, geom_text, labs, ggsave


# Parse command-line arguments
opt <- docopt(doc)

# Extract arguments
data_file <- opt$data
output_prefix <- opt$output_prefix

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

# Function to train a model, return confusion matrix, and save it as an image
train_and_evaluate <- function(model_spec, model_name) {
    workflow <- workflow() %>%
        add_recipe(recipe) %>%
        add_model(model_spec)

    fit <- workflow %>%
        fit(data = data_train)

    predictions <- predict(fit, data_test, type = "class") %>%
        bind_cols(data_test)

    # Generate confusion matrix using caret
    conf_matrix <- confusionMatrix(predictions$.pred_class, predictions$class)

    # Print the confusion matrix
    print(conf_matrix)

    # Convert confusion matrix to data frame for plotting
    conf_df <- as_tibble(as.table(conf_matrix)) %>%
        rename(Prediction = Prediction, Truth = Reference, Count = n)

    # Plot confusion matrix
    conf_plot <- ggplot(conf_df, aes(x = Truth, y = Prediction)) +
        geom_tile(color = "black", fill = "white") + # Black border, white fill
        geom_text(aes(label = Count), size = 6.5, color = "black") + # Black text color
        labs(title = paste(model_name, "Confusion Matrix"), x = "Actual Class", y = "Predicted Class") +
        theme_minimal()

  # Save confusion matrix figure (PNG) with unique output names for each model
  plot_file_path <- paste0(output_prefix, "_", model_name, "_confusion-matrix.png")
  ggsave(plot_file_path, plot = conf_plot, width = 5, height = 4, dpi = 300)

  # Save confusion matrix table (CSV) with unique output names for each model
  table_file_path <- paste0(output_prefix, "_", model_name, "_confusion-matrix.csv")
  write.csv(as.data.frame(conf_matrix), table_file_path)


  list(
    model = fit,
    predictions = predictions,
    confusion_matrix = conf_matrix,
    plot_path = plot_file_path,
    table_path = table_file_path
  )
}

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
knn_results <- train_and_evaluate(knn_spec, "knn")
log_reg_results <- train_and_evaluate(log_reg_spec, "logistic-regression")
tree_results <- train_and_evaluate(tree_spec, "decision-tree")

# Print file paths for each output
cat("KNN Confusion Matrix figure saved at:", knn_results$plot_path, "\n")
cat("KNN Confusion Matrix table saved at:", knn_results$table_path, "\n")

cat("Logistic Regression Confusion Matrix figure saved at:", log_reg_results$plot_path, "\n")
cat("Logistic Regression Confusion Matrix table saved at:", log_reg_results$table_path, "\n")

cat("Decision Tree Confusion Matrix figure saved at:", tree_results$plot_path, "\n")
cat("Decision Tree Confusion Matrix table saved at:", tree_results$table_path, "\n")