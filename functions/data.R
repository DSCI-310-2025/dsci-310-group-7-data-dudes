#' Create Directory If Needed
#' 
#' Checks if a directory exists and creates it if necessary.
#' @param path A character string specifying the directory path.
#' @return None. The function creates a directory.
create_directory_optional <- function(path) {
  if (!is.character(path)) {
    stop("`path` expects a string for directory path")
  }
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
}

#' Download Data
#'
download_data <- function(url, destination) {
  #' Downloads a file from a given URL and saves it to a specified destination.
  #' @param url A character string specifying the file URL.
  #' @param destination A character string specifying the file path where the data will be saved.
  #' @return None. The function downloads the file as a side effect.
  create_directory_if_needed(dirname(destination))
  download.file(url, destination)
}

#' Load Data
#'
#' Reads a CSV file into a dataframe.
#' @param file_path A character string specifying the path to the CSV file.
#' @return A dataframe containing the data from the CSV file.
load_data <- function(file_path) {
  readr::read_csv(file_path)
}