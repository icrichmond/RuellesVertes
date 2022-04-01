#' @param path path to wav folder dir (containing subfolders)
clean_parks <- function(rv, parcs) {
  
  # get the extent of our study area so we can clip the parks layer 
  bb <- st_bbox(rv)
  
 # filter for Montreal's large parks 
  parcs <- st_transform(parcs, crs="+init=epsg:6624")
  parcs <- st_crop(parcs,bb)
}