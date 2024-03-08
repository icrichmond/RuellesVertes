#' @param path path to wav folder dir (containing subfolders)
wide_final_sites <- function(rv_r, spt) {
  
  # associate sampling points with their ruelles 
  rv_sp <- st_join(rv_r, spt, join = st_intersects)
  # five ruelles have NA values because the end/extension 
  # of the ruelle was given a different ID. But they are
  # effectively sampled - so drop all NAs from dataset
  rv_sp <- drop_na(rv_sp)
  # join spt dataframe based on sampling id 
  spt_df <- as.data.frame(spt)
  rv_sp <- inner_join(rv_sp, spt_df, by = "Uniq_S_ID")
  # remove ruelle polygon geometry 
  rv_sp <- select(rv_sp, -c(lat.x, lon.x, geometry.x, geometry.y)) %>%
    rename(lat = lat.y) %>%
    rename(long = lon.y)
  # create consecutive sampling ID within each group
  # associate sampling points with their ruelles 
  rv_sp <- st_join(rv_r, spt, join = st_intersects)
  # five ruelles have NA values because the end/extension 
  # of the ruelle was given a different ID. But they are
  # effectively sampled - so drop all NAs from dataset
  rv_sp <- drop_na(rv_sp)
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
  # join rv_sp to spt to save kml layer for google maps 
  rv_sp <- arrange(rv_sp, Uniq_S_ID)
  # remove Group_S_ID column and recreate without ruelle id 
  rv_sp_w <- select(rv_sp, -Group_S_ID)
  rv_sp_w <- rv_sp_w %>% 
    dplyr::group_by(RUELLE_ID) %>%
    dplyr::mutate(Group_S_ID = paste0("S", 1:n()))
  # pivot wider
  rv_sp_w <- st_drop_geometry(rv_sp_w ) %>% 
    pivot_wider(id_cols = RUELLE_ID,
                names_from = Group_S_ID,
                values_from = c(lat,long))
  return(rv_sp_w)

}