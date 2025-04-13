library(pointblank)
library(dplyr)


data_transformed <- read.csv("data/clean/data-cleaned.csv")
str(data_transformed)

# VALIDATION - Correct data file format ------------------
create_agent(tbl = data_transformed, tbl_name = "fileFormat-checks") %>%
  col_is_numeric(columns = vars(
    alcohol.use, marijuana.use, heroin.frequency, marijuana.frequency
  )) %>%
  col_is_character(columns = vars(age, class)) %>%
  interrogate()

# VALIDATION - Correct column names ------------------
create_agent(tbl = data_transformed, tbl_name = "colName-checks") %>%
  col_exists(columns = c(
    "alcohol.use", "marijuana.use", "cocaine.use", "cocaine.frequency",
    "heroin.use", "heroin.frequency", "marijuana.frequency"
  )) %>%
  interrogate()


# VALIDATION - Missingness not beyond expected threshold---------
create_agent(tbl = data_transformed, tbl_name = "missingness") %>%
  # Check that missingness is not above 20%
  col_vals_not_null(
    columns = everything(),
    actions = warn_on_fail(warn_at = 0.30)
  ) %>%
  interrogate()


# VALIDATION - Correct data types in each column-------------------------------

# Specify numeric and integer columns manually
numeric_cols <- c(
  "alcohol.use", "marijuana.use", "cocaine.use", "cocaine.frequency",
  "crack.use", "crack.frequency", "heroin.use", "heroin.frequency",
  "hallucinogen.use", "inhalant.use", "inhalant.frequency",
  "pain.releiver.use", "oxycontin.use", "oxycontin.frequency",
  "tranquilizer.use", "tranquilizer.frequency", "stimulant.use",
  "stimulant.frequency", "meth.use", "meth.frequency", "sedative.use",
  "sedative.frequency")
integer_cols <- c(
  "n", "alcohol.frequency", "marijuana.frequency", "hallucinogen.frequency",
  "pain.releiver.frequency")

create_agent(tbl = data_transformed, tbl_name = "column-types") %>%
  # Check for correct column data types (for non-numeric columns)
  col_schema_match(
    schema = col_schema(
      age = "character",
      class = "character"
    ),
    complete = FALSE,
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
  interrogate()


# VALIDATION - Check that row data is not duplicated ---------------------------
create_agent(tbl = data_transformed, tbl_name = "duplicate-check") %>%
  rows_distinct(actions = warn_on_fail()) %>%
  interrogate()

# VALIDATION - Check that there are no anomalous or outlier values ------------------
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


# VALIDATION - Correct category levels (i.e., no string mismatches or single values) ------------------
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


# VALIDATION - Target/response variable follows expected distribution ------------------
library(pointblank)

create_agent(tbl = data_transformed, tbl_name = "target_class_check") %>%
  # Ensure class is either "youth" or "adult"
  col_vals_in_set(
    columns = vars(class),
    set = c("youth", "adult"),
    actions = warn_on_fail()
  ) %>%
  # Check youth proportion is between 45% and 55%
  col_vals_expr(
    expr = expr(mean(class == "youth") >= 0.45 & mean(class == "youth") <= 0.55),
    actions = warn_on_fail()
  ) %>%
  # Check adult proportion is between 45% and 55%
  col_vals_expr(
    expr = expr(mean(class == "adult") >= 0.45 & mean(class == "adult") <= 0.55),
    actions = warn_on_fail()
  ) %>%
  interrogate()
