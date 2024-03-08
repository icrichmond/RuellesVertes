
# Targets: Site Selection ----------------------------------------------------------
targets_clean <- c(
  tar_target(
    ruelles_data,
    read_sf("input/ruelles/ruelles-vertes.shp")
  ),
  tar_target(
    parks_data,
    download_shp("https://data.montreal.ca/dataset/2e9e4d2f-173a-4c3d-a5e3-565d79baa27d/resource/c57baaf4-0fa8-4aa4-9358-61eb7457b650/download/shapefile.zip",
                 "input/parcs/")
  ),
  tar_target(
    sample_pts, 
    read_sf("output/sampling_points/ruellessites.shp")
  ),
  tar_target(
    grp, 
    read.csv("input/RuellesVertes_Groups.csv")
  ),
  tar_target(
    ruelles_filtered,
    filter_ruelles(ruelles_data)
  ),
  tar_target(
    parks_cleaned,
    clean_parks(ruelles_filtered, parks_data)
  ),
  tar_target(
    parks_large, 
    subset(parks_cleaned, TYPO1 == "Grand parc")
  ),
  tar_target(
    spts_cleaned, 
    clean_spts(sample_pts)
  ),
  tar_target(
    ruelles_outliers,
    clean_outliers(ruelles_filtered, parks_large)
  ),
  tar_target(
    final_sites, 
    sites_final(ruelles_filtered, sample_pts)
  ),
  tar_target(
    final_sites_kml, 
    kml_final_sites(final_sites, spts_cleaned)
  ),
  tar_target(
    final_sites_wide, 
    wide_final_sites(ruelles_filtered, spts_cleaned)
  ),
  tar_target(
    sites_group,
    group_sites(grp, final_sites_kml)
  ),
  tar_target(
    output,
    write_sample_output(ruelles_filtered, final_sites, final_sites_kml, final_sites_wide, sites_group)
  )
    
)
