noisedata <- function(path) {
  # read files as waves and name that list
  w <- readWave(path)
  
  # calculate ACI for each file 
  a <- ACI(w)
  
  # calculate NDSI 
  n <- NDSI(soundscapespec(w, plot = F))
  
  # remove extremely large wave files
  rm(w) 
  
  # create a dataframe for both measures for each wave file
  d <- data.frame(unlist(a), unlist(n))
  
}