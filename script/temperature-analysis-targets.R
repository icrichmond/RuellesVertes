
# Targets: Temperature ----------------------------------------------------------
targets_temp <- c(
  tar_target(
    sensors, 
    read.csv("input/sensors/temp_sensors.csv")
  ),
  tar_target(
    temp, 
    read.csv("input/sensors/temp_final.csv")
  ),
  tar_target(
    land_cover,
    read_stars("input/spatial/66023_IndiceCanopee_2019.tif") 
  ),
  tar_target(
    vec_land_cover,
    read_sf("input/spatial/canopycover.shp") 
  ),
  
  tar_target(
    road_area,
    calc_road_area(sensors)
  ),
  
  tar_target(
    sensors_transform,
    transform_sensors(sensors, land_cover)
  ),
  tar_target(
    canopy_buff,
    buff_canopy(sensors_transform, vec_land_cover)
  ),
  tar_target(
    temp_join, 
    join_temp(sensors_transform, temp, canopy_buff)
  ), 
  tar_target(
    temp_plot, 
    plot_temp(temp_join)
  ), 
  tar_target(
    temp_output, 
    write.xlsx(temp_plot, file = "output/canopy/fulldataframe.xlsx", colNames = T)
  )
)
