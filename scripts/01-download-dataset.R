### Script 1 without custom functions ###

# url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
# destination <- "data/raw/drug-use-by-age.csv"

# if (!dir.exists(dirname(destination))) {
#   dir.create(dirname(destination), recursive = TRUE)
# }

# download.file(url, destination)

##$ Script 1 with custom functions ###
source("R/data_utils.R")

url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
destination <- "data/raw/drug-use-by-age.csv"

download_data(url, destination)
df <- load_data(destination)