test_that("load_data loads a CSV file into a dataframe", {
  test_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:5, b = letters[1:5]), test_file, row.names = FALSE)
  
  df <- load_data(test_file)
  expect_s3_class(df, "data.frame")
  expect_equal(ncol(df), 2)
  expect_equal(nrow(df), 5)
  
  unlink(test_file)  # Cleanup
})