#' @param DT
#' @param min_date
#' @param max_date
filter_wav <- function(DT, min_date = min_date, max_date = max_date) {
  DT[!is.na(time_cat) &
       between(date, min_date, max_date)]
}
