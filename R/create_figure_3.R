create_figure_3 <- function(temp_plot, road_area, rv) {
  
  floral <- lm(Floral_coverage_per_m2 ~ Groundcover_avg + Midstorey_avg + Canopy_avg + 
                 Ruelle_length_m + Ruelle_area_m2, data = rv)
  
  p <- plot_predictions(floral, condition = "Groundcover_avg") + 
    geom_point(data = rv, aes(x = Groundcover_avg, y = Floral_coverage_per_m2)) + 
    labs(x = "Ground cover vegetation (%)", y = bquote(atop(Habitat~provision~`for`~pollinators~phantom(),
                                                            (floral~coverage~m^2)))) + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14, colour="black"),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  temp_plot[['buffer50']]$road_area_m2 <- road_area[['buffer50']]$road_area_m2
  
  b50 <- temp_plot$buffer50
  rv$RuelleID <- gsub("_", "-", rv$RuelleID)
  df <- inner_join(b50, rv, by = "RuelleID")
  df <- df %>% mutate(percan = percan*100)
  
  mod <- lm(mean_NDSI ~ perveggr + perbuild + percan + road_area_m2, data = df)
  
  can <- plot_predictions(mod, condition = c("percan")) + 
    geom_point(data = df, aes(x = percan, y = mean_NDSI)) + 
    labs(x = "Surrounding canopy cover within 50 m buffer (%)", y = "Mean NDSI value") + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14, colour = "black"),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  full <- p / can + plot_annotation(tag_levels = 'a', tag_suffix = ")")
  
  
  ggsave('graphics/Figure3.png', full, width = 10, height = 12, units = c('in'), dpi = 450)
    
}