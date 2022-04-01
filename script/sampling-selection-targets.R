
# Targets: Site Selection ----------------------------------------------------------
targets_clean <- c(
  tar_target(
    ruelles_data,
    read_sf("input/ruelles/ruelles-vertes.shp")
  ),
  tar_target(
    parks_data,
    read_sf("input/parcs/Espace_Vert.shp")
  ),
  tar_target(
    roads_data,
    read_sf("input/roads/road_segment_1.shp")
  ),
  tar_target(
    sample_pts, 
    read_sf("output/sampling_points/ruellessites.shp")
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
    roads_cleaned, 
    clean_roads(ruelles_filtered, roads_data)
  ),
  tar_target(
    ruelles_outliers,
    clean_outliers(ruelles_filtered, parks_large)
  ),
  tar_target(
    final_sites, 
    sites_final(ruelles_cleaned, sample_pts)
  ),
  tar_targets(
    map, 
    plot_map(ruelles_filtered, parks_cleaned, roads_cleaned, final_sites)
  ),
  tar_target(
    output,
    write_sample_output(ruelles_filtered, final_sites)
  )
    
)


targets_grouping <- c(
  tar_target(
    grp, 
    "input/RuellesVertes_Groups.csv",
    format = "file"
  ),
  tar_target(
    ruelles_kml, 
    st_read("output/ruelles-sampling/ruellessitesID.kml")
  ),
  tar_target(
    sites_group,
    group_sites(grp, ruelles_kml)
  ),
  tar_target(
    site_output, 
    write.csv(sites_group, "output/ruelles-sampling/RuellesVertes_SamplingGrouped.csv")
  )
)