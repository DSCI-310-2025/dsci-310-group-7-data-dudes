library(ggplot2)
library(dplyr)
library(tidyr)
library(docopt)

source("R/load_csv.R")
source("R/create_directory.R")
source("R/eda_functions.R")

"This script performs some exploratory data analysis on the cleaned and transformed drug use data

Usage: 03-eda.R --file_path=<file_path> --output_path=<output_path>
" -> doc

opt <- docopt(doc)
data <- load_csv(opt$file_path)
create_directory(opt$output_path)

# make alcohol and marijuana use plots
plot_alc <- create_bar_use_plot(data, "age", "alcohol-use", "Alcohol Consumption in the Past Year by Age", "Age", "Proportion of respondents (%)", "dodgerblue", file.path(opt$output_path, "eda-alcohol.png"))
plot_mar <- create_bar_use_plot(data, "age", "marijuana-use", "Marijuana Consumption in the Past Year by Age", "Age", "Proportion of respondents (%)", "forestgreen", file.path(opt$output_path, "eda-marijuana.png"))

# Create and save frequency bar plots
plot_her <- create_bar_freq_plot(data, "age", "heroin-frequency", "Median Heroin Use Frequency in the Past Year by Age", "Age", "Median Frequency", "salmon", file.path(opt$output_path, "eda-heroin.png"))


# Scatter plot with regression line for heroin marijuana analysis
plot_her_mar <- create_scatter_plot(data, "heroin-frequency", "marijuana-frequency", "age", "Relationship Between Heroin and Marijuana Frequency Use", "Heroin Median Frequency", "Marijuana Median Frequency", file.path(opt$output_path, "eda-heroin-marijuana.png"))

# now add some plots on comparing youth vs adult

# generate aggregated data for youth vs. adult comparison
data_long <- aggregate_data(data)

# Create and save youth vs. adult comparison plots
plot_all_use <- create_grouped_bar_plot(
  filter(data_long, grepl("use", variable)), 
  "Youth vs. Adult: Substance Use", "Substance Type", "Mean Substance Use (%)", file.path(opt$output_path, "eda-all-use.png"))

plot_all_freq <- create_grouped_bar_plot(
  filter(data_long, grepl("frequency", variable)), 
  "Youth vs. Adult: Substance Use Frequency", "Substance Type", "Mean Frequency of Group per Year", file.path(opt$output_path, "eda-all-freq.png"))
