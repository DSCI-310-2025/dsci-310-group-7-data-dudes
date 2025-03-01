library(tidyverse)
library(ggplot2)

data_c <- read_csv("data/data-cleaned.csv")

# Proportion of individuals in each age group who have consumed alcohol in the past 12 months
plot_alc <- ggplot(data_c, aes(x=age, y=`alcohol-use`)) + 
  geom_bar(stat = "identity", width=0.7) + 
  geom_text(aes(label=`alcohol-use`), vjust=-0.3, color="grey10", size=3) +
  labs(title="Percent alcohol consumption in past 12 months by age group") +
  xlab("age group") +
  ylab("proportion of respondents (%)") +
  ylim(0, 100) +
  theme(axis.text = element_text(size = 8)) +
  theme(
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7)
  )
show(plot_alc)
ggsave("output/eda-alcohol.png", plot=plot_alc)

# Proportion of individuals in each age group who have used marijuana in the past 12 months
plot_mar <- ggplot(data_c, aes(x=age, y=`marijuana-use`)) + 
  geom_bar(stat = "identity", width=0.7) + 
  geom_text(aes(label=`marijuana-use`), vjust=-0.3, color="grey10", size=3) +
  labs(title="Percent marijuana consumption in past 12 months by age group") +
  xlab("age group") +
  ylab("proportion of respondents (%)") +
  ylim(0, 100) +
  theme(
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7)
  )
show(plot_mar)
ggsave("output/eda-marijuana.png", plot=plot_mar)

# Proportion of individuals in each age group who have used heroin in the past 12 months
plot_her <- ggplot(data_c, aes(x = as.factor(age), y = as.numeric(`heroin-frequency`))) +
  geom_bar(stat = "identity", width=0.7) +
  geom_text(aes(label=`heroin-frequency`), vjust=-0.3, color="grey10", size=3) +
  labs(title="Median frequency of heroin use in past 12 months by age group") +
  xlab("age group") +
  ylab("median frequency") +
  scale_y_continuous(
    breaks = seq(0, 300, by = 25),
    labels = seq(0, 300, by = 25)
  ) +
  theme(
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7)
  )
show(plot_her)
ggsave("output/eda-heroin.png", plot=plot_her)

# Relationship between frequency of heroin use vs. frequency of marijuana use
plot_her_mar <- data_c |>
  ggplot(aes(x = `heroin-frequency`, y = `marijuana-frequency`, color=`age`)) +
  geom_point(alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "solid") +
  labs(title="Relationship between frequency of heroin use vs. frequency of marijuana use", color = "Age Group") +
  scale_color_viridis_d() +
  theme(
    text = element_text(size = 12),
    plot.title = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 7)
  )
show(plot_her_mar)
ggsave("output/eda-heroin-marijuana.png", plot=plot_her_mar, width=8, height=6, dpi=300)
