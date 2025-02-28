library(tidyverse)

# Load raw dataset
data <- read_csv("data/raw/drug-use-by-age.csv")

# Convert "-" to NA for character columns, excluding 'age'
data_clean <- data %>%
  mutate(
    
    age = factor(age),  # Convert age to factor
    across(-age, ~ as.numeric(gsub("-", "NA", .)))  # Convert all other columns to numeric, replace "-" with NA
  )

# Save cleaned data
write_csv(data_clean, "data/data-cleaned.csv")

# Print success message
cat("✅ Data cleaning complete. Cleaned dataset saved as 'data/data-cleaned.csv'\n")

# Create transformed dataset with new "class" column
data_transformed <- data_clean %>%
  mutate(
    # Convert age factor to numeric, treat everything else as adult
    age_numeric = as.numeric(as.character(age)),  # Convert age factor to numeric
    class = ifelse(!is.na(age_numeric) & age_numeric <= 20, "youth", "adult")  # Classify as 'youth' or 'adult'
  ) %>%
  select(-age_numeric)  # Remove the 'age_numeric' column

# Save transformed data
write_csv(data_transformed, "data/data-cleaned-transformed.csv")

# Print success message
cat("✅ Data transformation complete. Transformed dataset saved as 'data/data-cleaned-transformed.csv'\n")

