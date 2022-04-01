#' @param path path to wav folder dir (containing subfolders)
transform_sensors <- function(sens, cc) {
  
  sens <- st_as_sf(sens, coords = c("long", "lat"), crs = 4326)
  
  # create several buffers between 10 - 100 m around each sensor 
  # transform to a metric coordinate system that matches the canopy layer (units = m)
  proj <- st_crs(cc)
  sens <- st_transform(sens, proj)
  
  return(sens)
  
}
  