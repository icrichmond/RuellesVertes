#' @param DT
#' @param min_date
#' @param max_date
filter_wav <- function(DT, min_date, max_date) {
  if (class(min_date) != class(DT$date) | class(max_date) != class(DT$date)) {
    stop('check class of min/max date and date column in DT')
  }
  
  DT[!is.na(time_cat) &
       between(date, min_date, max_date)]
}
