#' Read tables exported from ABS Table Builder
#'
#' @description
#' This provides an simple function to read in tables from Table Builder without
#' having to 'tidy' the tables first. The basic idea is that the function looks
#' for the first row that has its cell value equal to 'Count' which is what appeared
#' in all Table Builder tables. The 'Count' cell usually appear in as the last
#' column on the table and never the first.
#'
#' @param x path to a csv file exported from ABS Table Builder.
#' @param .names Default as 'asis' returns names as is. "simplify" use
#' only the abbreviations in small caps. While "clean" uses `janitor::clean_names()`.
#' @param exclude_total exclude rows with Total
#'
#' @return a data.table
#' @export
#'
#' @examples
#'
#' data_dir <- system.file("extdata", package = "abs")
#' test_csv <- file.path(data_dir, "tb1.csv")
#' mytable <- abs_read_tb(test_csv)
#'
abs_read_tb  <- function(x, .names = c("asis", "simplify", "clean"), exclude_total = TRUE) {

  .names <- match.arg(.names)

  first_n_lines <- 20
  top_lines <- readLines(x, n = first_n_lines)
  bottom_lines <- readLines(x, n = -first_n_lines)
  has_count <- grepl(",\"Count\"|,Count,|,Count$", x = top_lines)

  if (sum(has_count) == 0) {
    stop(paste0("Could not find the 'Count' column in the first ", first_n_lines, " lines."))
  }
  if (sum(has_count) > 1) {
    stop(paste0("There are multiple 'Count' columns in the first ", {first_n_lines}, " lines."))
  }

  .data <- fread(x, skip = which(has_count), header = FALSE)
  headers <- top_lines[has_count] %>%
    gsub("\"", "", .) %>%
    strsplit(., split = ",") %>%
    unlist()

  # remove rows that have any emptied cells or NAs
  .data <-
    .data[rowSums(is.na(.data) | .data == "") == 0]

  if (length(headers) != ncol(.data)) {
    stop(paste0("The length of headers isn't equal to the number of columns in 'x'"))
  }

  names(.data) <- headers

  if (exclude_total) {
    .data <- .data[rowSums(.data == "Total", na.rm = T) == 0, ]
  }

  if (.names == "clean") {
    data.table::setnames(.data,
             old = names(.data),
             new = janitor::make_clean_names(names(.data)))
  }

  if (.names == "simplify") {
    data.table::setnames(.data,
                         old = names(.data),
                         new = tolower(stringr::word(names(.data), 1)))
  }

  return(.data)
}
