library(testthat)

test_that("create_directory_optional creates a directory", {
  test_dir <- "data/test_dir"
  create_directory_optional(test_dir)
  expect_true(dir.exists(test_dir))
  unlink(test_dir, recursive = TRUE)  # Cleanup
})

test_that("download_data downloads a csv file when given an URL", {
  test_url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
  test_destination <- "data/test/drug-use-by-age.csv"
  
  download_data(test_url, test_destination)
  expect_true(file.exists(test_destination))
  
  unlink("data/test", recursive = TRUE)  # Cleanup
})

test_that("load_data loads a CSV file into a dataframe", {
  test_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:5, b = letters[1:5]), test_file, row.names = FALSE)
  
  df <- load_data(test_file)
  expect_s3_class(df, "data.frame")
  expect_equal(ncol(df), 2)
  expect_equal(nrow(df), 5)
  
  unlink(test_file)  # Cleanup
})