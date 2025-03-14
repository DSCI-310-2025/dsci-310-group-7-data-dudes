library(dplyr)

# Load raw dataset
data <- read_csv("data/raw/drug-use-by-age.csv")

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

# check data
str(data_transformed)

# Save the data
write_csv(data_transformed, "data/clean/data-cleaned.csv")

# Print success message
cat("✅ Data transformation complete. ")
cat("Transformed dataset saved to data/clean/data-cleaned.csv")
