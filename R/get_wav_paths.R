get_wav_paths <- function(path) {
  DT <- data.table(
    path = dir(path, full.names = TRUE, recursive = TRUE)
  )
  
  DT[, filename := basename(path)]
  DT[, folder := tstrsplit(path, '/')[[3]]]
  
  DT[, datetime := parse_date(tstrsplit(filename, '_')[[1]])]
}