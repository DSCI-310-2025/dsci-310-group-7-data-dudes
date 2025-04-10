#' Create and save a confusion matrix plot and table
#'
#' @description This function takes model predictions and generates a confusion matrix.
#' It saves the confusion matrix as a PNG figure and as a CSV table in the specified output directory,
#' and returns the ggplot object used to create the plot.
#'
#' @param predictions A data frame of predicted classes returned by `train_and_predict()`, including a `.pred_class` column and a `class` column representing true labels.
#' @param model_name A string representing the model name (used for naming the output files).
#' @param output_path A string specifying the directory to save the confusion matrix plot and CSV table.
#'
#' @return A ggplot object representing the confusion matrix.
#'
#' @import ggplot2
#' @import caret
#' @importFrom tibble as_tibble
#' @export
#' 
#' @example
#' # Example usage of the `create_confusion_outputs` function
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
#' # Generate predictions
#' predictions <- train_and_predict(model_spec, data_train, data_test, recipe)
#'
#' # Specify output path for saving the confusion matrix
#' output_path <- tempdir()  # Using tempdir for testing
#'
#' # Create and save the confusion matrix plot and table
#' conf_plot <- create_confusion_outputs(predictions, "decision_tree", output_path)
#' print(conf_plot)
create_confusion_outputs <- function(predictions, model_name, output_path) {
  library(caret)
  
  # Input validation for model_name
  if (is.null(model_name)) {
    stop("Model name cannot be NULL")
  }
  if (model_name == "") {
    stop("Model name cannot be empty")
  }
  
  # Generate confusion matrix using caret
  conf_matrix <- confusionMatrix(predictions$.pred_class, predictions$class)
  
  # Convert confusion matrix to data frame for plotting
  conf_df <- as_tibble(as.table(conf_matrix)) %>%
    rename(Prediction = Prediction, Truth = Reference, Count = n)
  
  # Plot confusion matrix
  conf_plot <- ggplot(conf_df, aes(x = Truth, y = Prediction)) +
    geom_tile(color = "black", fill = "white") +
    geom_text(aes(label = Count), size = 6, color = "black") +
    labs(title = paste(model_name, "Confusion Matrix"), x = "Actual Class", y = "Predicted Class") +
    theme_minimal()
  
  # Save plot as PNG
  plot_file_path <- file.path(output_path, paste0(model_name, "_confusion-matrix.png"))
  ggsave(plot_file_path, plot = conf_plot, width = 5, height = 4, dpi = 300)
  
  # Save confusion matrix as CSV
  table_file_path <- file.path(output_path, paste0(model_name, "_confusion-matrix.csv"))
  write.csv(as.data.frame(conf_matrix$table), table_file_path, row.names = FALSE)
  
  return(conf_plot)
}
