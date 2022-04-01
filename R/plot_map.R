#' @param path path to wav folder dir (containing subfolders)
plot_map <- function(rv_r, parcs, mjrds, spt) {
  
  ggplot() + 
  geom_sf(data = rv_r, col = "black") + 
  geom_sf(data = parcs, fill = "palegreen4") + 
  geom_sf(data = mjrds,  col = "gray44") + 
  #geom_sf(data = spt, col = "lightblue", size = 0.5)
  coord_sf(crs = "+init=epsg:6624") + 
  annotation_scale(location = "tl", width_hint = 0.5) +
  annotation_north_arrow(location = "tl", which_north = "true", style = north_arrow_fancy_orienteering) +
  theme(panel.grid.major = element_line(color = gray(.1), linetype = "dashed", size = 0.1),
        panel.background = element_rect(fill = NA))
  ggsave("graphics/AllRuelles_MjrRds_Parcs_Rosemont.jpg",dpi = 400)

  }