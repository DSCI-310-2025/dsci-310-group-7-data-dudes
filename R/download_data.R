#' Download Dataset
#'
#' Downloads a file from a given URL and saves it to a specified destination.
#'
#' @param url A character string specifying the file URL.
#' @param destination A character string specifying the
#' file path where the data will be saved.
#'
#' @return None. The function downloads the file as a side effect.
download_data <- function(url, destination) {
  create_directory(dirname(destination))

  # Attempt to download the file and catch errors
  tryCatch({
    download.file(url, destination, quiet = TRUE)
    message("File downloaded successfully to ", destination)
    return(TRUE)
  }, error = function(e) {
    stop("Error: Unable to download file from ", url)
  }, warning = function(w) {
    stop("Warning: Unable to download file from ", url)
  })
}
