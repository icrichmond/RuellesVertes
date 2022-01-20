# Packages -----------------------------------------------------
p <- c("sf", "purrr", "dplyr")
lapply(p, library, character.only = T)


# Data ---------------------------------------------------------
sens <- readRDS("output/canopy/sensorsspatial.rds")
temp <- read.csv("input/sensors/temp_final.csv")
canopy <- readRDS("output/canopy/canopymetrics.rds")


# Joining ------------------------------------------------------
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
