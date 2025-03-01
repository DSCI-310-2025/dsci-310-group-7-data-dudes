library(tidyverse)
library(tidymodels)
library(ggplot2)
library(caret)

output_dir <- "output"
if (!dir.exists(output_dir)) {
    dir.create(output_dir)
}

# Read data
set.seed(123)
data <- read_csv("data/data-cleaned-transformed.csv") %>%
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
        geom_text(aes(label = Count), size = 6, color = "black") + # Black text color
        labs(title = paste(model_name, "Confusion Matrix"), x = "Actual Class", y = "Predicted Class") +
        theme_minimal()

    # Save plot
    file_path <- file.path(output_dir, paste0(model_name, "-confusion-matrix.png"))
    ggsave(file_path, plot = conf_plot, width = 5, height = 4, dpi = 300)


    list(
        model = fit,
        predictions = predictions,
        confusion_matrix = conf_matrix,
        plot_path = file_path
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
knn_results <- train_and_evaluate(knn_spec, "KNN")
log_reg_results <- train_and_evaluate(log_reg_spec, "Logistic_Regression")
tree_results <- train_and_evaluate(tree_spec, "Decision_Tree")

# Print file paths
print(paste("KNN Confusion Matrix saved at:", knn_results$plot_path))
print(paste("Logistic Regression Confusion Matrix saved at:", log_reg_results$plot_path))
print(paste("Decision Tree Confusion Matrix saved at:", tree_results$plot_path))
