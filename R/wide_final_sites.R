#' @param path path to wav folder dir (containing subfolders)
wide_final_sites <- function(final_sites) {
  
  # create wide dataset 
# remove Group_S_ID column and recreate without ruelle id 
rv_sp_w <- select(rv_sp, -Group_S_ID)
rv_sp_w <- rv_sp_w %>% 
  dplyr::group_by(RUELLE_ID) %>%
  dplyr::mutate(Group_S_ID = paste0("S", 1:n()))
# pivot wider
rv_sp_w <- pivot_wider(rv_sp_w, 
                       id_cols = RUELLE_ID,
                       names_from = Group_S_ID,
                       values_from = c(lat,long))
return(rv_sp_w)

}