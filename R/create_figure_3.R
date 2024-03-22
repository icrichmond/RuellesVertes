create_figure_3 <- function(temp_plot, road_area, rv) {
  
  temp_plot[['buffer50']]$road_area_m2 <- road_area[['buffer50']]$road_area_m2
  
  b50 <- temp_plot$buffer50
  rv$RuelleID <- gsub("_", "-", rv$RuelleID)
  df <- inner_join(b100, rv, by = "RuelleID")
  
  mod <- lm(mean_NDSI ~ perveggr + perbuild + percan + road_area_m2, data = df)
  
  can <- plot_predictions(mod, condition = c("percan")) + 
    geom_point(data = df, aes(x = percan, y = mean_NDSI)) + 
    labs(x = "Percent Canopy Cover @ 50 m", y = "Mean NDSI") + 
    theme_classic()
  
  #build <- plot_predictions(mod, condition = c("perbuild")) + 
  #  geom_point(data = df, aes(x = perbuild, y = mean_NDSI)) + 
  #  labs(x = "Percent Building Cover @ 50 m", y = "Mean NDSI") + 
  #  theme_classic()
  
  
  p <- can #+ build

  
  ggsave('graphics/Figure3.png', p, width = 10, height = 8, units = c('in'), dpi = 450)
    
}