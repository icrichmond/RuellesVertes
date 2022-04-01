#' @param path path to wav folder dir (containing subfolders)
join_temp <- function(sens, temp, canopy) {
  
  # join spatial and temperature data for each sensor
  temp <- rename(temp, RuelleID = RUELLE_ID)
  temp$RuelleID <- gsub("_", "-", temp$RuelleID)
  tempsens <- inner_join(temp, sens)
  
  # join canopy and temperature data 
  b <- seq(10, 100, by = 10)
  canopyfull <- purrr::map(.x = canopy, .f = function(x){inner_join(x, tempsens, by = "RuelleID")}) %>% 
    purrr::set_names(., nm = paste0("buffer",b))
  
  
  # Save ----------------------------------------------------------
  saveRDS(canopyfull, "output/canopy/canopytempfull.rds")
  
  return(canopyfull)

  }