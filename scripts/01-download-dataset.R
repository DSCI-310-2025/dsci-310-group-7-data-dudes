url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
destination <- "data/raw/drug-use-by-age.csv"

download.file(url, destination)

