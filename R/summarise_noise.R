#' @param path path to wav folder dir (containing subfolders)
summarise_noise <- function(DT) {
  n <- c("meanACI", "sdACI", "rangeACI", "meanNDSI", "sdNDSI", "rangeNDSI")
  
  DT[, (n):= .(mean(ACI), sd(ACI), list(range(ACI)), mean(NDSI), sd(NDSI), list(range(NDSI))),
     by = .(folder, time_cat)]
  
  DT$rangeACI <- as.character(DT$rangeACI)
  DT$rangeNDSI <- as.character(DT$rangeNDSI)
}