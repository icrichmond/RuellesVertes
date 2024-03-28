create_figure_2 <- function(rv) {
  
  floral <- lm(Floral_coverage_per_m2 ~ Groundcover_avg + Midstorey_avg + Canopy_avg + 
                        Ruelle_length_m + Ruelle_area_m2, data = rv)
  
  p <- plot_predictions(floral, condition = "Groundcover_avg") + 
    geom_point(data = rv, aes(x = Groundcover_avg, y = Floral_coverage_per_m2)) + 
    labs(x = "Ground cover vegetation (%)", y = expression("Floral Coverage ("*m^2*")")) + 
    theme_classic() + 
    theme(axis.text = element_text(size = 14),
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14))
  
  ggsave('graphics/Figure2.png', p, dpi = 450)
  
}