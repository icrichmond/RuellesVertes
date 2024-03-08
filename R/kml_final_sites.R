#' @param path path to wav folder dir (containing subfolders)
kml_final_sites <- function(rv_sp, spt) {
    
  # join rv_sp to spt to save kml layer for google maps 
  rv_sp <- arrange(rv_sp, Uniq_S_ID)
  spt <- select(spt, -c(lat,lon))
  spt_kml <- inner_join(rv_sp, st_drop_geometry(spt))
  spt_kml <- st_as_sf(spt_kml)
  
  ### TODO NEED SPT
  
}