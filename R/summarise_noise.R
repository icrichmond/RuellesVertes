#' @param path path to wav folder dir (containing subfolders)
summarise_noise <- function(DT) {
  n <- c("meanACI", "sdACI", "minACI", "maxACI", "meanNDSI", "sdNDSI", "minNDSI", "maxNDSI")
  
  DT[, (n):= .(mean(ACI), sd(ACI), min(ACI), max(ACI), mean(NDSI), sd(NDSI), min(NDSI), max(NDSI)),
     by = .(folder, time_cat)]
  
  
}