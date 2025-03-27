#' Train a model, generate confusion matrix, and save results as figure and table
#'
#' @description This function takes a model specification and model name, fits the model,
#' generates a confusion matrix, and saves the results as both a PNG figure and a CSV table with a print message.
#'
#' @param model_spec A tidymodels model specification.  
#' @param model_name A string representing the model name (used for saving outputs).  
#' @param data_train A data frame containing the training data.  
#' @param data_test A data frame containing the testing data.  
#' @param recipe A tidymodels recipe for preprocessing the data.  
#' @param output_path A string specifying the directory to save results.  
#' 
#' @return A list containing the trained model, predictions, confusion matrix, and paths to saved figure and table.
#' 
#' @import tidymodels
#' @import caret
#' @import ggplot2
#' @export
train_and_evaluate <- function(model_spec, model_name, data_train, data_test, recipe, output_path) {
  library(tidymodels)
  library(caret)
  library(ggplot2)
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
  
  # Save plot as PNG
  plot_file_path <- file.path(output_path, paste0(model_name, "_confusion-matrix.png"))
  ggsave(plot_file_path, plot = conf_plot, width = 5, height = 4, dpi = 300)
  
  # Save confusion matrix as CSV table
  table_file_path <- file.path(output_path, paste0(model_name, "_confusion-matrix.csv"))
  write.csv(as.data.frame(conf_matrix$table), table_file_path, row.names = FALSE)
  
  message("Confusion matrix figure (PNG) and table (CSV) saved at:", output_path)
}