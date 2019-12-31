#' simplify table builder headers
#'
#' @param x data.frame
#'
#' @return data.frame
#' @export
#' @importFrom stringr word
tb_simplify_names <- function(x) {
  checkmate::assert_data_frame(x, null.ok = FALSE)
  simplified_names <- names(x) %>%
    stringr::word(1) %>%
    tolower()
  names(x) <- simplified_names
  return(x)
}

#' remove rows with totals
#'
#' @param x data.frame
#'
#' @return data.frame
#' @export
tb_remove_totals <- function(x) {
  checkmate::assert_data_frame(x, null.ok = FALSE)
  if (!is.data.table(x)) {
    x <- as.data.table(x)
  }
  x <- x[rowSums(x == "Total") == 0]
  return(x)
}

#' Create a range from a numeric vector of size two
#'
#' If the length of the vector is more than two then the vector gets returned.
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
tb_range <- function(x) {
  if (length(x) == 2)
    return(x[[1]]:x[[2]])
  if (is.list(x))
    return(unlist(x))
  x
}

#' remove overseas visitors
#'
#' @param x data.frame
#'
#' @return data.frame
#' @export
tb_remove_overseas_visitors <- function(x) {
  checkmate::assert_data_frame(x, null.ok = FALSE)
  x <- x[rowSums(x == "Overseas visitor") == 0]
  return(x)
}

#' remove rows with 'value'
#'
#' @param x data.frame
#' @param value a vector
#'
#' @return data.frame
#' @export
tb_remove_row_with <- function(x, value) {
  checkmate::assert_data_frame(x, null.ok = FALSE)
  if (!is.data.table(x))
    x <- as.data.table(x)
  for(val in value) {
    x <- x[rowSums(x == val) == 0]
  }
  x
}

#' remove rows where 'var' in 'value'
#'
#' @param x a data.frame
#' @param var column name in the data.frame to be evaluated
#' @param value a value or a vector of values that should be removed
#'
#' @return
#' @export
#'
#' @examples
tb_remove_row_where <- function(x, var, value) {
  checkmate::assert_data_frame(x, null.ok = FALSE)
  if (!x %has_name% var)
    return(x)
  if (!is.data.table(x))
    x <- as.data.table(x)
  x[!get(var) %in% value]
}


#' Reweight rows with not stated
#'
#' @param x a data.frame
#' @param zone_col a character indicates the zone column for groupping
#'
#' @return a data.frame
#' @export
tb_distribute_not_stated <- function(x, zone_col) {
  checkmate::assert_data_frame(x, null.ok = FALSE)
  checkmate::assert_string(zone_col, na.ok = FALSE, null.ok = FALSE)
  checkmate::assert_names(x, must.include = zone_col)

  if (!is.data.table(x))
    setDT(x)

  # remove not stated
  x2 <- x[rowSums(x == "Not stated" | x == "not stated") == 0]

  # calculate zone totals
  x_zone_total <- x[, .(total = sum(count)), by = c(zone_col)]

  # redistribute zone totals based on group proportions
  x2_new <-
    copy(x2) %>%
    .[, p := ifelse(count == 0, 0, count / sum(count)), by = c(zone_col)] %>%
    .[x_zone_total, , on = c(zone_col), nomatch = 0] %>%
    .[, count2 := p * total]

  # check if the new total equal to the starting total
  stopifnot(sum(x$count) == sum(x2_new$count2))

  x2_new %>%
    .[, count := count2] %>%
    .[, c("p", "total", "count2") := NULL]

  x2_new
}
