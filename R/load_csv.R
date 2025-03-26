#' Load CSV
#'
#' Reads a CSV file into a dataframe.
#' 
#' @param file_path A character string specifying the path to the CSV file.
#' @return A dataframe containing the data from the CSV file.
load_csv <- function(file_path) {
  readr::read_csv(file_path)
}