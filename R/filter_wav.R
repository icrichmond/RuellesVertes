#' @param DT
#' @param min_date
#' @param max_date
filter_wav <- function(DT, min_date, max_date) {
  if (class(min_date)[1] != class(DT$date)[1] | class(max_date)[1] != class(DT$date)[1]){ 
         stop('check class of min/max date and date column in DT')
  }
  
  DT[!is.na(time_cat) & between(date, min_date, max_date)]
}
