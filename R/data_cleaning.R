#' Cleaning and Transforming Data
#'
#' @description These functions clean and transform the drug use dataset to ensure proper data types,
#' handle missing values, classify age groups, and save processed data.
#' The functions include:
#' - `clean_drug_use_data`: Cleans the dataset by converting age to a factor and other values to numeric.
#' - `classify_age_group`: Categorizes individuals into 'youth' or 'adult' based on age.
#' - `save_data`: Saves the processed dataset, creating necessary directories if they do not exist.
#'
#' @param data A dataframe containing drug use data.
#' @param output_path A string specifying the file path to save the processed data.
#'
#' @return A cleaned and transformed dataframe.
#'
#' @import dplyr
#' @import readr
#' @export

#' Cleans the drug use dataset
#' 
#' @param data A dataframe containing drug use data.
#' @return A dataframe with age as a factor and other values converted to numeric.
clean_drug_use_data <- function(data) {
  data %>%
    mutate(
      age = factor(age),
      across(-age, ~ as.numeric(na_if(., "-")))
    )
}

#' Classifies individuals into age groups
#' 
#' @param data A dataframe containing drug use data with an age column.
#' @return A dataframe with an added column `class` indicating 'youth' or 'adult'.
classify_age_group <- function(data) {
  data %>%
    mutate(
      age_numeric = as.numeric(as.character(age)),
      class = ifelse(!is.na(age_numeric) & age_numeric <= 20, "youth", "adult")
    ) %>%
    select(-age_numeric)
}

#' Saves processed data to a specified file path
#' 
#' @param data A dataframe to be saved.
#' @param output_path A string specifying the output file path.
#' @return None. Saves the data to a file.
save_data <- function(data, output_path) {
  if (!dir.exists(dirname(output_path))) {
    dir.create(dirname(output_path), recursive = TRUE)
  }
  write_csv(data, output_path)
}
