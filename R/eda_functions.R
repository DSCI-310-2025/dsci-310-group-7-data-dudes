#' Using the cleaned data, create some exploratory data analysis plots to gain a better understanding of 
#' the data.
#' 
#' @description These functions create different types of plots based on the scope of certain variables
#' in the data. The functions include:
#' - `create_bar_use_plot`: Creates a bar plot for substance use.
#' - `create_bar_freq_plot`: Creates a bar plot for substance use frequency.
#' - `create_scatter_plot`: Creates a scatter plot with a regression line.
#' - `aggregate_data`: Aggregates data for youth vs. adult comparison.
#' - `create_grouped_bar_plot`: Creates grouped bar plots for youth vs. adult comparison.
#' 
#' @param data A .csv dataframe containing data to be plotted or aggregated.
#' @param x_var A string specifying the x-axis variable.
#' @param y_var A string specifying the y-axis variable.
#' @param title A string specifying the plot title.
#' @param x_label A string specifying the x-axis label.
#' @param y_label A string specifying the y-axis label.
#' @param fill_color A string specifying the fill color for the bars.
#' @param output_file A string specifying the output file path for saving the plot.
#' @param color_var A string specifying the color variable for the scatter plot.
#' 
#' @return ggplot objects representing the generated plot(s).
#' 
#' @import ggplot2
#' @import dplyr
#' @import tidyr
#' @export

# Function to create bar plot for substance use
create_bar_use_plot <- function(data, x_var, y_var, title, x_label, y_label, fill_color, output_file) {
  plot <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]])) + 
    geom_bar(stat = "identity", width = 0.7, fill = fill_color) + 
    geom_text(aes(label = .data[[y_var]]), vjust = -0.3, color = "grey10", size = 3) +
    labs(title = title, x = x_label, y = y_label) +
    ylim(0, 100) +
    theme_bw() +
    theme(
      plot.title = element_text(size = 10, face = "bold"),
      axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
      axis.text.y = element_text(size = 7)
    )
  ggsave(output_file, plot = plot, width = 8, height = 6)
  return(plot)
}


# Create and save frequency bar plots
create_bar_freq_plot <- function(data, x_var, y_var, title, x_label, y_label, fill_color, output_file) {
  plot <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]])) + 
    geom_bar(stat = "identity", width = 0.7, fill = fill_color) + 
    geom_text(aes(label = .data[[y_var]]), vjust = -0.3, color = "grey10", size = 3) +
    labs(title = title, x = x_label, y = y_label) +
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
  ggsave(output_file, plot = plot, width = 8, height = 6)
  return(plot)
}

# Function to create scatter plot with regression line
create_scatter_plot <- function(data, x_var, y_var, color_var, title, x_label, y_label, output_file) {
  plot <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]], color = .data[[color_var]])) +
    geom_point(alpha = 0.8) +
    geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "solid") +
    labs(title = title, x = x_label, y = y_label, color = "Age Group") +
    scale_color_viridis_d() +
    theme_bw() +
    theme(
      plot.title = element_text(size = 10, face = "bold"),
      axis.text.x = element_text(size = 7, angle = 30, hjust = 1),
      axis.text.y = element_text(size = 7)
    )
  ggsave(output_file, plot = plot, width = 8, height = 6, dpi = 300)
  return(plot)
}


# Function to aggregate data for youth vs. adult comparison
aggregate_data <- function(data) {
  data %>%
    group_by(class) %>%
    summarise(across(where(is.numeric), ~ weighted.mean(.x, n, na.rm = TRUE), 
                     .names = "mean_{.col}"),
              total_n = sum(n)) %>%
    pivot_longer(cols = starts_with("mean_"), 
                 names_to = "variable", values_to = "value") %>%
    mutate(variable = gsub("mean_", "", variable),
           value = round(value, 2))
}


# Function to create grouped bar plots
create_grouped_bar_plot <- function(data, title, x_label, y_label, output_file) {
  plot <- ggplot(data, aes(x = .data[["variable"]], y = .data[["value"]], fill = class)) +
    geom_bar(stat = "identity", position = "dodge") +
    theme_bw() +
    labs(title = title, x = x_label, y = y_label, fill = "Class") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_fill_manual(values = c("adult" = "darkblue", "youth" = "dodgerblue"),
                      labels = c("adult" = "Adult", "youth" = "Youth"))
  ggsave(output_file, plot = plot, width = 8, height = 6, dpi = 300)
  return(plot)
}
