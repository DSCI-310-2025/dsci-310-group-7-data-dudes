library(dplyr)
library(readr)

# Function to clean the data
clean_drug_use_data <- function(data) {
  data %>%
    mutate(
      age = factor(age),
      across(-age, ~ as.numeric(gsub("-", "NA", .)))
    )
}

# Function to classify age group
classify_age_group <- function(data) {
  data %>%
    mutate(
      age_numeric = as.numeric(as.character(age)),
      class = ifelse(!is.na(age_numeric) & age_numeric <= 20, "youth", "adult")
    ) %>%
    select(-age_numeric)
}

# Function to save data with directory handling
save_data <- function(data, output_path) {
  if (!dir.exists(dirname(output_path))) {
    dir.create(dirname(output_path), recursive = TRUE)
  }
  write_csv(data, output_path)
}
