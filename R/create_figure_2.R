create_figure_2 <- function(rv, temp_plot) {
  
  b50 <- temp_plot$buffer50 |>
    mutate(RuelleID = str_replace_all(RuelleID, "-", "_"))
  
  full <- left_join(rv, b50, by = "RuelleID")

  # explanatory variables
  exp <- full %>% 
    select(c("RuelleID", "Ruelle_length_m", "Ruelle_area_m2", "Groundcover_avg",
             "Midstorey_avg", "Canopy_avg")) %>% 
    pivot_longer(!RuelleID, names_to = "exp", values_to = "x_value")
  
  exp_names <- c(
    Ruelle_length_m = "Alley length (m)",
    Ruelle_area_m2 = "Alley area (m2)",
    Groundcover_avg = "Ground cover (%)",
    Midstorey_avg = "Midstory cover (%)",
    Canopy_avg = "Canopy cover (%)"
  )
  
  # response variables
  resp <- full %>% 
    select(c("RuelleID", "Food_coverage_per_m2", "Floral_coverage_per_m2",
             "mean_NDSI", "Avg_min_daily_temp.x", "Avg_max_daily_temp.x")) %>% 
    pivot_longer(!RuelleID, names_to = "resp", values_to = "y_value")
  
  resp_names <- c(
    Food_coverage_per_m2 = "Food coverage (per m2)",
    Floral_coverage_per_m2 = "Floral coverage (per m2)",
    mean_NDSI = "NDSI", 
    Avg_min_daily_temp.x = "Average minimum temperature (C)",
    Avg_max_daily_temp.x = "Average maximum temperature (C)"
  )
  
  # plot
  plot <- inner_join(exp, resp, by = "RuelleID", relationship = 'many-to-many') %>% 
    ggplot(aes(x = x_value, y = y_value)) +
    geom_point() + 
    labs(x = "", y = "") + 
    facet_grid(resp ~ exp, 
               scales = "free", 
               switch = "both", 
               labeller = labeller(exp  = as_labeller(exp_names),
                                   resp = as_labeller(resp_names, default=label_wrap_gen(20)))) +
    theme(strip.background = element_blank(),
          strip.placement = "outside",
          strip.text = element_text(size = 10, colour = "black"),
          panel.background = element_rect(colour = "black", fill = NA),
          panel.grid = element_blank(),
          axis.text = element_text(colour = "black"))
  
  ggsave('graphics/Figure2.png', plot, height = 10, width = 10, units = 'in', dpi = 450)
           
           

             
}

