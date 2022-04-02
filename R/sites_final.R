#' @param path path to wav folder dir (containing subfolders)
sites_final <- function(rv, spt) {
  
  # Emily created create three sampling points along the ruelles in QGIS
  # 1/4 in, 1/2 in, 3/4 in 
  spt <- st_transform(spt, crs = "+init=epsg:6624")
  
  # id column has some accidental duplicates so will generate
  # unique ID based on row number and remove original id column 
  spt <- spt %>% 
    tibble::rowid_to_column("Uniq_S_ID") %>%
    dplyr::select(-id)

  # extract coordinates into more readable format 
  spt <- spt %>%
    dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                  lon = sf::st_coordinates(.)[,2])
  
  # associate sampling points with their ruelles 
  rv_sp <- st_join(rv, spt, join = st_intersects)
  
  # five ruelles have NA values because the end/extension 
  # of the ruelle was given a different ID. But they are
  # effectively sampled - so drop all NAs from dataset
  rv_sp <- tidyr::drop_na(rv_sp)
  
  # join spt dataframe based on sampling id 
  spt_df <- as.data.frame(spt)
  rv_sp <- inner_join(rv_sp, spt_df, by = "Uniq_S_ID")
  
  # remove ruelle polygon geometry 
  rv_sp <- select(rv_sp, -c(lat.x, lon.x, geometry.x, geometry.y)) %>%
    rename(lat = lat.y) %>%
    rename(long = lon.y)
  
  # create consecutive sampling ID within each group
  rv_sp <- rv_sp %>% 
    dplyr::group_by(RUELLE_ID) %>%
    dplyr::mutate(Group_S_ID = paste0(RUELLE_ID, "_", 1:n()))
  
  
  return(rv_sp)

  
}