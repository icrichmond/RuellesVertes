#' @param path path to wav folder dir (containing subfolders)
write_sample_output <- function(ruelles_filtered, final_sites, final_sites_kml, final_sites_wide) {
  
  # save ruelles as a shapefile so that sampling points can be calculated in QGIS 
  write_sf(ruelles_filtered, dsn = 'output/ruelles-shp/', layer = 'cleanruellesrosemont',  driver="ESRI Shapefile")
  st_write(ruelles_filtered, "output/ruelles-sampling/rosemontruelles.kml", driver = "kml")
  
  # save as long dataset 
  write_csv(final_sites, "output/ruelles-sampling/Ruelles_SamplingPoints_Long.csv")
  
  # save kml layer for google maps 
  st_write(final_sites_kml, "output/ruelles-sampling/ruellessitesID.kml", driver = "kml")
  
  # save wide dataset
  write_csv(final_sites_wide, "output/ruelles-sampling/Ruelles_SamplingPoints_Wide.csv")
  
  
}