library(pkg.drugage)

"This script cleans and saves drug use data

Usage: 02-data-clean-transform.R --file_path=<file_path> --output_path=<output_path>
" -> doc

opt <- docopt(doc)

# Load raw data
data <- read.csv(opt$file_path)

# Apply transformations
# Convert "-" to NA for character columns, excluding 'age'
data_clean <- clean_drug_use_data(data)
# Create new class column that indicates age groups
data_transformed <- classify_age_group(data_clean)

# Save the cleaned data
save_data(data_transformed, opt$output_path)
