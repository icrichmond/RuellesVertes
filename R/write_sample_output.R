#' @param path path to wav folder dir (containing subfolders)
write_sample_output <- function(rf, final_sites, final_sites_kml, final_sites_wide, sites_group) {
  
  # save ruelles as a shapefile so that sampling points can be calculated in QGIS 
  st_write(rf, 'output/ruelles-shp/cleanruellesrosemont.shp', append=F)
  st_write(rf, 'output/ruelles-sampling/rosemontruelles.kml', append=F)
  
  # save as long dataset 
  write.csv(final_sites, "output/ruelles-sampling/Ruelles_SamplingPoints_Long.csv")
  
  # save kml layer for google maps 
  st_write(final_sites_kml, "output/ruelles-sampling/ruellessitesID.kml", append=F)
  
  # save wide dataset
  write.csv(final_sites_wide, "output/ruelles-sampling/Ruelles_SamplingPoints_Wide.csv")
  
  write.csv(sites_group, "output/ruelles-sampling/RuellesVertes_SamplingGrouped.csv")
  
}