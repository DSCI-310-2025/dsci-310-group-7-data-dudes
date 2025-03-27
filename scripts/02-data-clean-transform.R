library(dplyr)
library(docopt)
library(readr)
source("R/data_cleaning.R")

"This script cleans and saves drug use data

Usage: 02-data-clean-transform.R --file_path=<file_path> --output_path=<output_path>
" -> doc

opt <- docopt(doc)

# Load raw dataset
# data <- read_csv("data/raw/drug-use-by-age.csv")
data <- read_csv(opt$file_path)

# Apply transformations
# Convert "-" to NA for character columns, excluding 'age'
data_clean <- clean_drug_use_data(data)
# Create new class column that indicates age groups
data_transformed <- classify_age_group(data_clean)

# Save the cleaned dataset
# write_csv(data_transformed, "data/clean/data-cleaned.csv")
save_data(data_transformed, opt$output_path)
