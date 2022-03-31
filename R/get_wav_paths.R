get_wav_paths <- function(path) {
  DT <- data.table(
    path = dir(path, full.names = TRUE, recursive = TRUE)
  )
  
  DT[, filename := basename(path)]
  DT[, folder := tstrsplit(path, '/')[[3]]]
  
  DT[, datetime_char := tstrsplit(filename, '-')[[1]]]
  DT[, date := parse_date(tstrsplit(datetime_char, '_')[[1]])]
  DT[, time := as.ITime(tstrsplit(datetime_char, '_')[[2]],
                        format = '%H%M%S')]
  
  return(DT)
}