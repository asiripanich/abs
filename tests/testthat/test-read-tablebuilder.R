test_that("read tablebuilder", {
  data_dir <- system.file("extdata", package = "abs")
  test_csv <- file.path(data_dir, "tb1.csv")
  test_cleaned_csv <- file.path(data_dir, "tb1_cleaned.csv")
  test2_csv <- file.path(data_dir, "tb2_modified.csv")
  expect_equal(abs_read_tb(test_csv), abs_read_tb(test_cleaned_csv))
  expect_equal(abs_read_tb(test_csv, exclude_total = FALSE), abs_read_tb(test_cleaned_csv, exclude_total = FALSE))
  expect_equal(abs_read_tb(test_csv, exclude_total = TRUE), abs_read_tb(test_cleaned_csv, exclude_total = TRUE))
  expect_equal(
    abs_read_tb(test_csv, .names = "simplify") %>% names() %>% grepl(" ", .) %>% sum(),
    0
  )
  expect_equal(
    abs_read_tb(test_csv, .names = "clean") %>% names() %>% grepl(" ", .) %>% sum(),
    0
  )
  expect_is(abs_read_tb(test2_csv), class = "data.table")
})

