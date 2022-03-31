#' @param path path to wav folder dir (containing subfolders)
get_wav_paths <- function(paths) {
  DT <- data.table(
    path = paths
  )
  
  DT[, filename := basename(path)]
  DT[, folder := tstrsplit(path, '/')[[3]]]
  
  DT[, datetime_char := tstrsplit(filename, '-')[[1]]]
  DT[, date := parse_date(tstrsplit(datetime_char, '_')[[1]])]
  DT[, time := as.ITime(tstrsplit(datetime_char, '_')[[2]],
                        format = '%H%M%S')]
  
  return(DT)
}