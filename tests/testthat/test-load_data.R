# Expected case
test_that("`load_csv` correctly loads a CSV file", {
  test_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:5, b = letters[1:5]), test_file, row.names = FALSE)

  df <- load_csv(test_file)
  expect_s3_class(df, "data.frame")
  expect_equal(ncol(df), 2)
  expect_equal(nrow(df), 5)

  unlink(test_file)  # Cleanup
})

# Edge case
test_that("`load_csv` handles empty CSV file", {
  test_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(), test_file, row.names = FALSE)  # Empty file

  df <- load_csv(test_file)
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 0)  # Should return empty dataframe

  unlink(test_file)  # Cleanup
})

# Error case
test_that("`load_csv` fails when file does not exist", {
  expect_error(load_csv("non_existent_file.csv"))
})