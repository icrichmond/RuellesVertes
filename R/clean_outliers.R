#' @param path path to wav folder dir (containing subfolders)
clean_outliers <- function(rv, parcs) {
  
  y <- sf::st_join(rv, parcs, left = F, join = st_is_within_distance, dist = 100) %>%
  group_by(RUELLE_ID) %>%
  summarize(Parcs = list(Nom))
  
  y <- as_tibble(y) %>%
  select(-geometry)
  
  # remove any ruelles from lns_ss that are found in y 
  lns_ss <- anti_join(rv, y)
  
  return(lns_ss)
}