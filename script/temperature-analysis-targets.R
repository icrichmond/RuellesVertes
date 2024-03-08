
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
    download_tif("https://observatoire.cmm.qc.ca/documents/carte/canope/2019/IC_TIFF/660_IndiceCanopee_2019_TIF.zip", 
                 "input/mon-canopy") 
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
