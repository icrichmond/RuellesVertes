create_figure_3 <- function(temp_plot, road_area, rv) {
  
  min_temp <- lm(Avg_min_daily_temp_s ~ perveggr_s + percan_s + road_area_m2_s, data = buffer_vars_full[["buffer50"]])
  
  noise <- lm(mean_NDSI_s ~ perveggr_s + percan_s + road_area_m2_s, data = buffer_vars_full[["buffer50"]])
  
  floral <- lm(Floral_coverage_per_m2_s ~ Groundcover_avg_s + Midstorey_avg_s + Canopy_avg_s + Ruelle_area_m2_s, data = rv_vars_full)
  
  
  
  f <- plot_predictions(floral, condition = "Groundcover_avg_s") + 
    geom_point(data = rv_vars_full, aes(x = Groundcover_avg_s, y = Floral_coverage_per_m2_s)) + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14, colour="black"),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  # extract plot breaks on x and y axes
  atx <- c(as.numeric(na.omit(layer_scales(f)$x$break_positions())))
  aty <- c(as.numeric(na.omit(layer_scales(f)$y$break_positions())))
  
  
  # unscale axis labels for interpretation
  f_u <- f +
    scale_x_continuous(name = "Ground cover vegetation (%)",
                       breaks = atx,
                       labels = round(atx * sd(rv_vars_full$Groundcover_avg) + mean(rv_vars_full$Groundcover_avg), 0))  +
    scale_y_continuous(name =  bquote(atop(Habitat~provision~`for`~pollinators~phantom(),
                                           (floral~coverage~m^2))), 
                       breaks = aty,
                       labels = round(aty * sd(rv_vars_full$Floral_coverage_per_m2) + mean(rv_vars_full$Floral_coverage_per_m2), 2)) 
  
  
  t <- plot_predictions(min_temp, condition = "perveggr_s") + 
    geom_point(data = buffer_vars_full$buffer50, aes(x = perveggr_s, y = Avg_min_daily_temp_s)) + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14, colour="black"),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  # extract plot breaks on x and y axes
  atx <- c(as.numeric(na.omit(layer_scales(t)$x$break_positions())))
  aty <- c(as.numeric(na.omit(layer_scales(t)$y$break_positions())))
  
  
  # unscale axis labels for interpretation
  t_u <- t +
    scale_x_continuous(name = "Vegetation cover in 50 m buffer (%)",
                       breaks = atx,
                       labels = round((atx * sd(buffer_vars_full$buffer50$perveggr) + mean(buffer_vars_full$buffer50$perveggr))*100, 0))  +
    scale_y_continuous(name =  "Average minimum daily temperature (°C)", 
                       breaks = aty,
                       labels = round(aty * sd(buffer_vars_full$buffer50$Avg_min_daily_temp) + mean(buffer_vars_full$buffer50$Avg_min_daily_temp), 1)) 
  
  nv <- plot_predictions(noise, condition = "perveggr_s") + 
    geom_point(data = buffer_vars_full$buffer50, aes(x = perveggr_s, y = mean_NDSI_s)) + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14, colour="black"),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  # extract plot breaks on x and y axes
  atx <- c(as.numeric(na.omit(layer_scales(nv)$x$break_positions())))
  aty <- c(as.numeric(na.omit(layer_scales(nv)$y$break_positions())))
  
  
  # unscale axis labels for interpretation
  nv_u <- nv +
    scale_x_continuous(name = "Vegetation cover in 50 m buffer (%)",
                       breaks = atx,
                       labels = round((atx * sd(buffer_vars_full$buffer50$perveggr) + mean(buffer_vars_full$buffer50$perveggr))*100, 0))  +
    scale_y_continuous(name =  "Average NDSI", 
                       breaks = aty,
                       labels = round(aty * sd(buffer_vars_full$buffer50$mean_NDSI) + mean(buffer_vars_full$buffer50$mean_NDSI), 1)) 
  
  nc <- plot_predictions(noise, condition = "percan_s") + 
    geom_point(data = buffer_vars_full$buffer50, aes(x = percan_s, y = mean_NDSI_s)) + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14, colour="black"),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  # extract plot breaks on x and y axes
  atx <- c(as.numeric(na.omit(layer_scales(nc)$x$break_positions())))
  aty <- c(as.numeric(na.omit(layer_scales(nc)$y$break_positions())))
  
  
  # unscale axis labels for interpretation
  nc_u <- nc +
    scale_x_continuous(name = "Canopy cover in 50 m buffer (%)",
                       breaks = atx,
                       labels = round((atx * sd(buffer_vars_full$buffer50$percan) + mean(buffer_vars_full$buffer50$percan))*100, 0))  +
    scale_y_continuous(name =  "Average NDSI", 
                       breaks = aty,
                       labels = round(aty * sd(buffer_vars_full$buffer50$mean_NDSI) + mean(buffer_vars_full$buffer50$mean_NDSI), 1)) 
  
  
  
  
  
 full <- (f_u + t_u) / (nv_u + nc_u) + plot_annotation(tag_levels = 'a', tag_suffix = ")")
  
  
  ggsave('graphics/Figure3.png', full, width = 10, height = 12, units = c('in'), dpi = 450)
    
}