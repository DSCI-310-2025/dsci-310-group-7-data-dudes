library(testthat)

# Expected case
test_that("create_directory creates a directory", {
  test_dir <- "data/test_dir"
  create_directory(test_dir)
  expect_true(dir.exists(test_dir))
  unlink(test_dir, recursive = TRUE)  # Cleanup
})

# Edge case
test_that("create_directory handles existing directory", {
  test_dir <- "data/test_dir"
  dir.create(test_dir, recursive = TRUE)
  create_directory(test_dir)  # Should not fail
  expect_true(dir.exists(test_dir))
  unlink(test_dir, recursive = TRUE)  # Cleanup
})

# Error case
test_that("create_directory fails on invalid path", {
  expect_error(create_directory(NULL))
})
