calc_road_area <- function(sensors){
  
  sensors_t <- st_as_sf(sensors, coords = c("long", "lat"), crs = 4326) %>% 
    filter(RuelleID != "RPP-H-1000012b")
  
  roads_shp <- download_shp('https://donnees.montreal.ca/dataset/0acbc6c8-bbfc-4aae-a0fa-ec74ba0686c6/resource/102dd6af-836d-443e-9bee-bfdd2f525fb8/download/voi_voirie_s_v22_shp.zip', 'input/roads_shp.zip')
  
  # select roads
  roads <- roads_shp %>% 
    filter(CATEGORIEC == "Autoroute" | CATEGORIEC == "Rue" | TYPEINTERS == "Intersection de rues") %>%
    select(geometry)
  
  # create 50 m buffer surrounding sensors
  # create 100 m buffer surrounding sensors
  buff50 <- road_area(sensors_t, roads, 50)
  buff100 <- road_area(sensors_t, roads, 100)

  roadlist <- list(buff50, buff100)
  names(roadlist) <- c('buffer50', 'buffer100')
  
  
  
}

road_area <- function(sensors_t, roads, distance){
  b <- st_buffer(st_transform(sensors_t, st_crs(roads)), distance)
  
  # intersect impervious surfaces with buffer
  imp_buff <- st_intersection(roads, b) %>% 
    group_by(RuelleID) %>% 
    summarize(geometry = st_union(geometry)) %>% 
    mutate(road_area_m2 = drop_units(st_area(geometry))) 
  
}
