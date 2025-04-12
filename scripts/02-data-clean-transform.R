library(pkg.drugage)
library(docopt)

"This script cleans and saves drug use data

Usage: 02-data-clean-transform.R --file_path=<file_path> --output_path=<output_path>
" -> doc

opt <- docopt(doc)

# Load raw data
data <- read.csv(opt$file_path)
data <- read.csv("data/raw/drug-use-by-age.csv")

# Apply transformations
# Convert "-" to NA for character columns, excluding 'age'
data_clean <- clean_drug_use_data(data)
# Create new class column that indicates age groups
data_transformed <- classify_age_group(data_clean)

# Save the cleaned data
save_data(data_transformed, opt$output_path)
save_data(data_transformed, "data/clean/data-cleaned.csv")
# ----------------------------------------------------------

# !!! error note: currently data validation checks fail
# this seems to be from that some columns are "integer" despite forcing them to be "numeric" with our function
# additionally, missing values fails at failure level (0.17647) >= failure threshold (0.2)
#   despite that not being true at all -_-
# another final error is for the package xfun, saying i dont have the right version loaded
#   but yet i do locally, not sure why these errors are happening :(

# Validate the cleaned data
library(pointblank)
library(dplyr)

data_transformed <- read.csv("data/clean/data-cleaned.csv")
str(data_transformed)

# Specify numeric and integer columns manually
numeric_cols <- c(
  "alcohol.use", "marijuana.use", "cocaine.use", "cocaine.frequency",
  "crack.use", "crack.frequency", "heroin.use", "heroin.frequency",
  "hallucinogen.use", "inhalant.use", "inhalant.frequency",
  "pain.releiver.use", "oxycontin.use", "oxycontin.frequency",
  "tranquilizer.use", "tranquilizer.frequency", "stimulant.use",
  "stimulant.frequency", "meth.use", "meth.frequency", "sedative.use",
  "sedative.frequency"
)

integer_cols <- c(
  "n", "alcohol.frequency", "marijuana.frequency", "hallucinogen.frequency",
  "pain.releiver.frequency"
)

non_numeric_cols <- c("age", "class")

# Create a data validation check
create_agent(tbl = data_transformed, tbl_name = "drug-use-data") %>%
  # Check for correct column data types (for non-numeric columns)
  col_schema_match(
    schema = col_schema(
      age = "character",
      class = "character"),
    actions = warn_on_fail()
  ) %>%
  # Check that all numeric columns are numeric
  col_is_numeric(
    columns = all_of(numeric_cols),
    actions = warn_on_fail()
  ) %>%
  # Check that all integer columns are integer
  col_is_integer(
    columns = all_of(integer_cols),
    actions = warn_on_fail()
  ) %>%
  # Check that missingness is not above 20%
  col_vals_not_null(
    columns = everything(),
    actions = warn_on_fail(warn_at = 0.20)
  ) %>%
  interrogate()
