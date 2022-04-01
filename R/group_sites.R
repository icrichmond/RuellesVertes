#' @param path path to wav folder dir (containing subfolders)
group_sites <- function(grp, rv_sp) {
  
  # clean rv_sp to get coordinates 
  # select relevant columns
  rv_sp <- select(rv_sp, c(RUELLE_ID, geometry))
  # extract coordinates
  rv_sp <- rv_sp %>%
    dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                  lon = sf::st_coordinates(.)[,2])
  # create unique sampling point IDs 
  rv_sp <- rv_sp %>% 
    as_tibble(rv_sp) %>%
    dplyr::group_by(RUELLE_ID) %>%
    dplyr::mutate(Group_S_ID = paste0("S", 1:n())) %>%
    dplyr::select(-geometry)
  # one row per ruelle 
  rv_sp_w <- pivot_wider(rv_sp, 
                         id_cols = RUELLE_ID,
                         names_from = Group_S_ID,
                         values_from = c(lat,lon))
  # rearrange columns for easier use 
  rv_sp_w <- rv_sp_w %>%
    dplyr::select(c(RUELLE_ID, lat_S1, lon_S1, lat_S2, lon_S2,
                    lat_S3, lon_S3))
  
  # full dataset
  full <- inner_join(grp, rv_sp_w)
  write.csv(full, "output/ruelles-sampling/RuellesVertes_SamplingGrouped.csv")

}