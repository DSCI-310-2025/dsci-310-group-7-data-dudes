library(tidyverse)

# Load raw dataset
data <- read_csv("data/drug-use-by-age.csv")

# Convert "-" to "NA", then make numeric
data_clean <- data %>%
  mutate(across(where(is.character), ~ na_if(., "-"))) %>%  # Convert "-" to NA
  mutate(across(where(is.character), as.numeric))  # Convert to numeric

# Save cleaned data
write_csv(data_clean, "data/drug-use-by-age-cleaned.csv")

# Print success message
cat("✅ Data cleaning complete. Cleaned dataset saved as 'data/drug-use-by-age-cleaned.csv'\n")