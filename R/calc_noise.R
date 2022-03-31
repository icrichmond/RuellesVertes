calc_noise <- function(path) {
  # read files as waves and name that list
  w <- readWave(path)
  
  # calculate ACI for each file 
  a <- ACI(w)
  
  # calculate NDSI 
  n <- NDSI(soundscapespec(w, plot = F))
  
  # create a dataframe for both measures for each wave file
  return(data.frame(ACI = a, NDSI = n))
}