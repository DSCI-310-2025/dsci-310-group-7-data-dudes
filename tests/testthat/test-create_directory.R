library(testthat)

test_that("create_directory_optional creates a directory", {
  test_dir <- "data/test_dir"
  create_directory_optional(test_dir)
  expect_true(dir.exists(test_dir))
  unlink(test_dir, recursive = TRUE)  # Cleanup
})