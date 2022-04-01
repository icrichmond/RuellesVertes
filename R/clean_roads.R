#' @param path path to wav folder dir (containing subfolders)
clean_roads <- function(rv, rds) {
  
  # get the extent of our study area so we can clip the parks layer 
  bb <- st_bbox(rv)
  
  # reproject and clip so that it roads are in the same projection
  rds <- st_transform(rds, crs = "+init=epsg:6624")
  rds <- st_crop(rds, bb)
  
  # select only major roads
  mjrds <- subset(rds, rdcls_en == "Freeway" | rdcls_en == "Expressway-Highway" |
                    rdcls_en == "Arterial")
  
  return(mjrds)
}