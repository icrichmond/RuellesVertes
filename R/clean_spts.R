#' @param path path to wav folder dir (containing subfolders)
clean_spts <- function(spt){
  spt <- st_transform(spt, crs = "+init=epsg:6624")
  # id column has some accidental duplicates so will generate
  # unique ID based on row number and remove original id column 
  spt <- spt %>% 
    tibble::rowid_to_column("Uniq_S_ID") %>%
    dplyr::select(-id)
  saveRDS(spt, "output/ruelles-sampling/ruellessitesID.rds")
  # extract coordinates into more readable format 
  spt <- spt %>%
    dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                  lon = sf::st_coordinates(.)[,2])
  
}