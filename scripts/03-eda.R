library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)
library(docopt)

"This script performs some exploratory data analysis on the cleaned and transformed drug use data

Usage: 03-eda.R --file_path=<file_path> --output_path=<output_path>
" -> doc

opt <- docopt(doc)

data <- read_csv(opt$file_path)



# Proportion of individuals in each age group who have consumed alcohol in the past 12 months
plot_alc <- ggplot(data, aes(x=age, y=`alcohol-use`)) + 
  geom_bar(stat = "identity", width=0.7, fill="dodgerblue") + 
  geom_text(aes(label=`alcohol-use`), vjust=-0.3, color="grey10", size=3) +
  labs(title="Alcohol Consumption in the Past Year by Age",
       x = "Age",
       y = "Proportion of respondents (%)") +
  ylim(0, 100) +
  theme_bw() +
  theme(axis.text = element_text(size = 8)) +
  theme(
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7))

show(plot_alc)

# Create output directory if it doesn't exist
if (!dir.exists(opt$output_path)) {
  dir.create(opt$output_path)
}

ggsave(file.path(opt$output_path, "eda-alcohol.png"), plot=plot_alc)

# Proportion of individuals in each age group who have used marijuana in the past 12 months
plot_mar <- ggplot(data, aes(x=age, y=`marijuana-use`)) + 
  geom_bar(stat = "identity", width=0.7, fill = "forestgreen") + 
  geom_text(aes(label=`marijuana-use`), vjust=-0.3, color="grey10", size=3) +
  labs(title="Marijuana Consumption in the Past Year by Age",
       x = "Age",
       y = "Proportion of respondents (%)") +
  ylim(0, 100) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7))

show(plot_mar)
ggsave(file.path(opt$output_path, "eda-marijuana.png"), plot=plot_mar)

# Proportion of individuals in each age group who have used heroin in the past 12 months
plot_her <- ggplot(data, aes(x = as.factor(age), y = as.numeric(`heroin-frequency`))) +
  geom_bar(stat = "identity", width=0.7, fill = "salmon") +
  geom_text(aes(label=`heroin-frequency`), vjust=-0.3, color="grey10", size=3) +
  labs(title="Median Heroin Use Frequency in the Past Year by Age") +
  xlab("Age") +
  ylab("Median Frequency") +
  scale_y_continuous(
    breaks = seq(0, 300, by = 25),
    labels = seq(0, 300, by = 25)
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7)
  )
show(plot_her)
ggsave(file.path(opt$output_path, "eda-heroin.png"), plot=plot_her)

# Relationship between frequency of heroin use vs. frequency of marijuana use
plot_her_mar <- data |>
  ggplot(aes(x = `heroin-frequency`, y = `marijuana-frequency`, color=`age`)) +
  geom_point(alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "solid") +
  labs(title="Relationship Between Heroin and Marijuana Frequency Use", 
       color = "Age Group",
       y = "Marijuana Median Frequency",
       x = "Heroin Median Frequency") +
  scale_color_viridis_d() +
  theme_bw() +
  theme(
    text = element_text(size = 12),
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7)
  )
show(plot_her_mar)
ggsave(file.path(opt$output_path, "eda-heroin-marijuana.png"), plot=plot_her_mar, width=8, height=6, dpi=300)

# now lets add some plots on comparing youth vs adult

# aggregate the data such that there are two rows to compare: youth and adult
data_aggregated <- data %>%
    group_by(class) %>%
    summarise(across(where(is.numeric), ~ weighted.mean(.x, n, na.rm = TRUE), 
                     .names = "mean_{.col}"),
              total_n = sum(n)) 
head(data_aggregated)

# change the form of the data so that it is easier to plot
data_long <- data_aggregated %>%
  select(-mean_n) %>%
  pivot_longer(cols = starts_with("mean_"), 
               names_to = "variable", values_to = "value") %>%
  mutate(variable = gsub("mean_", "", variable))
head(data_long)

# Create large plot comparing all drugs for adult and youth
drug_class_comparison <- ggplot(data_long, aes(x = variable, y = value, fill = class)) +
  geom_bar(stat = "identity", position = "dodge") + 
  theme_bw() +
  labs(title = "Comparison of Youth vs. Adult Drug Use",
       x = "Substance Use Variable",
       y = "Weighted Mean Value",
       fill = "Class") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# above is too large/busy of a plot, simplify by splitting it up

# Split data into two categories: "use" and "frequency"
data_use <- data_long %>%
  filter(grepl(paste("use", collapse = "|"), variable))

data_freq <- data_long %>%
  filter(grepl(paste("frequency", collapse = "|"), variable))

# Bar plot for substance use
plot_all_use <- ggplot(data_use, aes(x = variable, y = value, fill = class)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  labs(title = "Youth vs. Adult: Substance Use",
       x = "Substance Type",
       y = "Mean Substance Use (%)",
       fill = "Class") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("adult" = "darkblue", "youth" = "dodgerblue"),
                    labels = c("adult" = "Adult", "youth" = "Youth"))
plot_all_use
ggsave(file.path(opt$output_path, "eda-all-use.png"), plot=plot_all_use, width=8, height=6, dpi=300)



# Bar plot for frequency
plot_all_freq <- ggplot(data_freq, aes(x = variable, y = value, fill = class)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  labs(title = "Youth vs. Adult: Substance Use Frequency",
       x = "Substance Type",
       y = "Mean Frequency of Group per Year",
       fill = "Class") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("adult" = "darkblue", "youth" = "dodgerblue"),
                    labels = c("adult" = "Adult", "youth" = "Youth"))
plot_all_freq
ggsave(file.path(opt$output_path, "eda-all-freq.png"), plot=plot_all_freq, width=8, height=6, dpi=300)
