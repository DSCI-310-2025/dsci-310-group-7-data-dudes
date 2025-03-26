library(testthat)

# Expected case
test_that("`download_data` downloads a csv file when given an URL", {
  test_url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
  test_destination <- "data/test/drug-use-by-age.csv"
  
  download_data(test_url, test_destination)
  expect_true(file.exists(test_destination))
  
  unlink("data", recursive = TRUE)  # Cleanup
})

# Edge case
test_that("`download_data` handles pre-existing file", {
    test_url <- "https://raw.githubusercontent.com/rudeboybert/fivethirtyeight/refs/heads/master/data-raw/drug-use-by-age/drug-use-by-age.csv"
    test_destination <- "data/test/drug-use.csv"

    dir.create(dirname(test_destination), recursive=TRUE)
    write.csv(data.frame(a = 1:5), test_destination, row.names = FALSE) # creating an existing df

    download_data(test_url, test_destination)
    expect_true(file.exists(test_destination))

    unlink("data", recursive = TRUE)
})

# Error case
test_that("`download_data` fails with an invalid URL", {
  test_url <- "https://invalid.url/file.csv"
  test_destination <- "data/test/invalid.csv"

  expect_error(download_data(test_url, test_destination), "Unable to download file")
})