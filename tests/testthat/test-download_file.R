test_that("download_data downloads a csv file when given an URL", {
  test_url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
  test_destination <- "data/test/drug-use-by-age.csv"
  
  download_data(test_url, test_destination)
  expect_true(file.exists(test_destination))
  
  unlink("data/test", recursive = TRUE)  # Cleanup
})