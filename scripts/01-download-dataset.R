url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
destination <- "data/raw/drug-use-by-age.csv"

create_directory(destination)
download_data(url, destination)
data <- load_csv(destination)