library(dplyr)
library(docopt)
library(readr) 

"This script cleans and saves drug use data

Usage: 02-data-clean-transform.R --file_path=<file_path> --output_path=<output_path>
" -> doc

opt <- docopt(doc)

# Load raw dataset
# data <- read_csv("data/raw/drug-use-by-age.csv")
data <- read_csv(opt$file_path)

# look at data
str(data)

# Convert "-" to NA for character columns, excluding 'age'
data_clean <- data %>%
  mutate(
    # Convert age to factor
    age = factor(age),
    # Convert all other columns to numeric, replace "-" with NA
    across(-age, ~ as.numeric(gsub("-", "NA", .))))

# Create transformed dataset with new "class" column
data_transformed <- data_clean %>%
  mutate(
    # Convert age factor to numeric
    age_numeric = as.numeric(as.character(age)),
    # Classify as 'youth' or 'adult'
    class = ifelse(!is.na(age_numeric) & age_numeric <= 20, "youth", "adult")) %>%
  # Remove the 'age_numeric' column
  select(-age_numeric)

# Print success message
print("Data transformation complete!")

# check data
str(data_transformed)

# made directory if it doesn't exist already
if (!dir.exists(dirname(opt$output_path))) {
  dir.create(dirname(opt$output_path), recursive = TRUE)
}

# Save the data
# write_csv(data_transformed, "data/clean/data-cleaned.csv")
write_csv(data_transformed, opt$output_path)

# Print success message
print("Transformed dataset saved to data/clean/data-cleaned.csv")
