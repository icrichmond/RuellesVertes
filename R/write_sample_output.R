#' @param path path to wav folder dir (containing subfolders)
write_sample_output <- function(rf, final_sites, final_sites_kml, final_sites_wide, sites_group) {

  # save as long dataset 
  write.csv(final_sites, "output/Ruelles_SamplingPoints_Long.csv")
  
  # save kml layer for google maps 
  st_write(final_sites_kml, "output/ruellessitesID.kml", append = F)
  
  # save wide dataset
  write.csv(final_sites_wide, "output/Ruelles_SamplingPoints_Wide.csv")
  
  write.csv(sites_group, "output/RuellesVertes_SamplingGrouped.csv")
  
}
