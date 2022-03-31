#' @param wav_paths
categorize_wav <- function(DT) {
  DT[between(hour(time), 7, 9), time_cat := 'morning']
  DT[between(hour(time), 12, 14), time_cat := 'afternoon']
  DT[between(hour(time), 17, 19), time_cat := 'evening']
  
  return(DT)
}
