pak::pak("DSCI-310-2025/pkg.drugage")
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


# VALIDATION - Check that row data is not duplicated
create_agent(tbl = data_transformed, tbl_name = "duplicate-check") %>%
  rows_distinct() %>%
  col_vals_unique(
    columns = everything(),
    actions = warn_on_fail()
  ) %>%
  interrogate()


# VALIDATION - Check that there are no anomalous or outlier values
# Function to calculate IQR thresholds
get_iqr_bounds <- function(column_data) {
  Q1 <- quantile(column_data, 0.25, na.rm = TRUE)
  Q3 <- quantile(column_data, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower <- Q1 - 1.5 * IQR
  upper <- Q3 + 1.5 * IQR
  return(list(lower = lower, upper = upper))
}

# Calculate bounds for your column
bounds <- get_iqr_bounds(data_transformed$numeric_column)

create_agent(tbl = data_transformed, tbl_name = "outlier-check") %>%
  col_vals_between(
    columns = "numeric_column",
    left = bounds$lower,
    right = bounds$upper,
    na_pass = TRUE,
    actions = action_levels(warn_at = 0.01, notify_at = 0.05)
  ) %>%
  interrogate()


# VALIDATION - Correct category levels (i.e., no string mismatches or single values)
valid_age_levels <- c("12", "13", "14", "15", "16", "17", "18", "19",
                      "20", "21", "22-23", "24-25", "26-29", "30-34",
                      "35-49", "50-64", "65+")

valid_class_levels <- c("youth", "adult")

create_agent(tbl = data_transformed, tbl_name = "category-checks") %>%
  col_vals_in_set(
    columns = vars(class),
    set = c("youth", "adult"),
    actions = warn_on_fail()
  ) %>%
  col_vals_in_set(
    columns = vars(age),
    set = c("12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
            "22-23", "24-25", "26-29", "30-34", "35-49", "50-64", "65+"),
    actions = warn_on_fail()
  ) %>%
  interrogate()


#VALIDATION - Target/response variable follows expected distribution
create_agent(tbl = data_transformed, tbl_name = "target_class_check") %>%
  # Ensure class is either "youth" or "adult"
  col_vals_in_set(
    columns = vars(class),
    set = c("youth", "adult"),
    actions = warn_on_fail()
  ) %>%
  # Check youth proportion is between 45% and 55%
  col_vals_expr(
    expr = expr(mean(.data$class == "youth") >= 0.45 & mean(.data$class == "youth") <= 0.55),
    actions = warn_on_fail()
  ) %>%
  # Check adult proportion is between 45% and 55%
  col_vals_expr(
    expr = expr(mean(.data$class == "adult") >= 0.45 & mean(.data$class == "adult") <= 0.55),
    actions = warn_on_fail()
  ) %>%
  interrogate()
