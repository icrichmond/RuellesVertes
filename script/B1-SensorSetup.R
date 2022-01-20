# Packages ------------------------------------------
p <- c("sf", "stars", "purrr", "dplyr")
lapply(p, library, character.only = T)

# Data ----------------------------------------------
# sensor data
sens <- read.csv("input/sensors/temp_sensors.csv")
sens <- st_as_sf(sens, coords = c("long", "lat"), crs = 4326)

# canopy data - sourced from http://observatoire.cmm.qc.ca/observatoire-grand-montreal/produits-cartographiques/donnees-georeferencees/
cc <- read_stars("input/spatial/66023_IndiceCanopee_2019.tif") 

# Buffers -------------------------------------------
# create several buffers between 10 - 100 m around each sensor 
# transform to a metric coordinate system that matches the canopy layer (units = m)
proj <- st_crs(cc)
sens <- st_transform(sens, proj)
# produce buffers every 10 m
b <- seq(10, 100, by = 10)
# calculate buffers at each distance for all sensors
buffers <- purrr::map(.x = b,
                      .f = function(x){st_buffer(sens, x)}) %>%
  purrr::set_names(., nm = paste0("buffer", b))
# prepare canopy cover 
#bb <- st_bbox(buffers$buffer100) # get extent of largest buffer
#cc <- cc[bb] # crop raster to extent
# cc <- st_as_sf(cc) # transform to sf object
# NOTE: operating now with laptop so vectorized canopy cover in GEE and importing here
cc <- read_sf("input/spatial/canopycover.shp")
cc <- st_transform(cc, st_crs(sens))
# intersect buffers with canopy
ints <- purrr::map(.x = buffers, .f = function(x){st_intersection(x, cc)})%>%
  purrr::set_names(., nm = paste0("int", b))
ints <- purrr::map(.x = ints, .f = function(x){st_make_valid(x)})

# Canopy Cover Stats ---------------------------------
# we want to calculate the percent area that is taken up by each land cover type
## Metrics of disturbance
dists <- purrr::map(.x = ints, .f = function(x){x %>% group_by(RuelleID, label) %>% mutate(area = st_area(geometry))})
canopy <- purrr::map(.x = dists, .f = function(x){x %>% group_by(RuelleID) %>% summarise(totarea = sum(area), 
                                                                                     impergr = sum(area[label == 1]),
                                                                                     veggr = sum(area[label == 3]),
                                                                                     build = sum(area[label == 2]),
                                                                                     can = sum(area[label == 4]),
                                                                                     wat = sum(area[label == 5]),
                                                                                     perimpgr = impergr/totarea, 
                                                                                     perveggr = veggr/totarea,
                                                                                     perbuild = build/totarea,
                                                                                     percan = can/totarea,
                                                                                     perwat = wat/totarea)})

# Save -----------------------------------------------
