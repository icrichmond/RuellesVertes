#' @param path path to wav folder dir (containing subfolders)
filter_ruelles <- function(rv) {
  
  rv$PROPRIETAI <- as.factor(rv$PROPRIETAI)
  rv_r <- subset(rv, PROPRIETAI == "Rosemont - La Petite-Patrie")
  
  # merge all polygons that belong to the same alley
  rv_r <- rv_r %>%
    dplyr::group_by(RUELLE_ID) %>%
    dplyr::summarise(geometry = st_union(geometry))
  
  # ruelles already have unique IDs
  # 8 ruelles have two separate locations assigned to the same RUELLE_ID
  # select these 8 
  rv_m <- subset(rv_r, RUELLE_ID == "RPP-H-1000003" | 
                   RUELLE_ID == "RPP-H-1000008" | 
                   RUELLE_ID == "RPP-H-1000012" | 
                   RUELLE_ID == "RPP-H-1000014" |
                   RUELLE_ID == "RPP-H-1000044" |
                   RUELLE_ID == "RPP-H-1000070" |
                   RUELLE_ID == "RPP-I-1000010" |
                   RUELLE_ID == "RPP-I-1000102")
  # separate polygons
  rv_m <- st_cast(rv_m, "MULTIPOLYGON") %>% st_cast("POLYGON")
  # label separate polygons with the same RUELLE_ID a & b
  rv_m <- rv_m %>% 
    dplyr::group_by(RUELLE_ID) %>%
    dplyr::mutate(RUELLE_ID = paste0(RUELLE_ID, ".", 1:n()))
  rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, fixed(".1"), "a")
  rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, fixed(".2"), "b")
  rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, fixed(".3"), "c")
  # RPP-H-1000044.b and RPP-H-1000003.c are not representative of the actual ruelles
  # remove these from dataset 
  rv_m <- subset(rv_m, RUELLE_ID != "RPP-H-1000003c" &
                   RUELLE_ID != "RPP-H-1000044b")
  rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, "RPP-H-1000044c", "RPP-H-1000044b")
  # remove original rows of the 8 unique ruelles from rv_r dataset and replace
  rv_r <- subset(rv_r, RUELLE_ID != "RPP-H-1000003" & 
                   RUELLE_ID != "RPP-H-1000008" & 
                   RUELLE_ID != "RPP-H-1000012" & 
                   RUELLE_ID != "RPP-H-1000014" &
                   RUELLE_ID != "RPP-H-1000044" &
                   RUELLE_ID != "RPP-H-1000070" &
                   RUELLE_ID != "RPP-I-1000010" &
                   RUELLE_ID != "RPP-I-1000102")
  rv_r <- rbind(rv_m, rv_r)
  
  
  # transform to projection with units as metres with Quebec Albers 
  rv_r <- st_transform(rv_r, crs = "+init=epsg:6624")
  
  # save cleaned shapefiles as .rds objects
  saveRDS(rv_r, "output/ruelles-sampling/RuellesRosemont.rds")
  
  # save ruelles as a shapefile so that sampling points can be calculated in QGIS 
  write_sf(rv_r, dsn = 'output/ruelles-shp/', layer = 'cleanruellesrosemont',  driver="ESRI Shapefile")
  st_write(rv_r, "output/ruelles-sampling/rosemontruelles.kml", driver = "kml")
  
  return(rv_r)

  }