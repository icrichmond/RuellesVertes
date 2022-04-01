#' @param path path to wav folder dir (containing subfolders)
write_sample_output <- function(ruelles_filtered, final_sites) {
  
  # save ruelles as a shapefile so that sampling points can be calculated in QGIS 
  write_sf(ruelles_filtered, dsn = 'output/ruelles-shp/', layer = 'cleanruellesrosemont',  driver="ESRI Shapefile")
  st_write(ruelles_filtered, "output/ruelles-sampling/rosemontruelles.kml", driver = "kml")
  
  # save wide dataset
  write_csv(final_sites, "output/ruelles-sampling/Ruelles_SamplingPoints_Wide.csv")
  
  
}