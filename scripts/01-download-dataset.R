library(survey.workflow)

url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
destination <- "data/raw/"

create_directory(destination)
download_data(url, destination)
data <- read.csv(file.path(destination, "drug-use-by-age.csv"))
