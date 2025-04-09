source("R/create_directory.R")
source("R/download_data.R")
source("R/load_csv.R")

url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
destination <- "data/raw/"

create_directory(destination)
download_data(url, destination)
data <- load_csv(file.path(destination, "drug-use-by-age.csv"))