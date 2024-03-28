create_figure_1 <- function(model_max_temp, model_min_temp, model_noise, model_habitat, model_food){
  
  maxtemp <- plot_temp_model(model_max_temp) + ggtitle("a) Maximum air\ntemperature")
  mintemp <- plot_temp_model(model_min_temp) + ggtitle("b) Minimum air\ntemperature")
  
  habitat <- plot_provisioning(model_habitat) + ggtitle("e) Habitat\nprovision for\npollinators")
  food <- plot_provisioning(model_food) + ggtitle("d) Food provision")
  
  noise <- plot_noise(model_noise) + ggtitle("c) Anthropogenic\nnoise")
  
  legend <- get_legend(noise)
  
  
  all_mods <- plot_grid(plot_grid(maxtemp, mintemp, food, habitat, nrow = 2, ncol = 2, align = 'v'),
                        plot_grid(noise + theme(legend.position = "none"), legend, ncol = 1, nrow = 2, align = 'v', rel_heights = c(3,1)),
                        rel_widths = c(2, 1)) 
  
  ggsave('graphics/Figure1.png', all_mods, width = 18, height = 14, units = 'in', dpi = 450)
  
}

plot_temp_model <- function(model){
  
  maxt_v <- tidy(model[[1]][[1]]) %>% 
    mutate(model = "Vegetation Within Alley + Structural Form",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error)  %>% 
    filter(term != "(Intercept)")
  
  
  maxt_b <- tidy(model[[2]][[1]]) %>% 
    mutate(model = "Surrounding Land Cover",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  maxt <- rbind(maxt_v, maxt_b)
  
  maxtemp_plot <- ggplot(data = maxt, aes(x = estimate, y = factor(term, levels = c('Canopy_avg', 'Midstorey_avg', 'Groundcover_avg', 'Ruelle_length_m', 'Ruelle_area_m2', 'percan', 'perveggr', 'perbuild', 'road_area_m2')), group = model, color = model)) + 
    geom_point() + 
    geom_vline(xintercept= 0, linetype="dotted") + 
    geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) +
    theme_classic() + 
    labs(y = "", x = "") + 
    scale_y_discrete(limits = rev, 
                     labels = c("Main roads (50m buffer)", "Building cover (50m buffer)", "Vegetation cover (50m buffer)", "Canopy cover (50m buffer)", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + 
    scale_color_manual(values = c( "#21908CFF", "#440154FF", "#47C16EFF", "#FDE725FF")) +
    theme(legend.position = "none",
          plot.title = element_text(size = 16, face = "bold"),
          axis.text = element_text(size = 16))
  
  return(maxtemp_plot)
  
}



plot_provisioning <- function(model) {
  
  floral_v <- tidy(model[[1]][[1]]) %>% 
    mutate(model = "Vegetation Within Alley + Structural Form",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  floral_aes1 <- tidy(model[[1]][[2]]) %>% 
    mutate(model = "Aesthetic Features Within Alley (non-ecological)",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  floral_aes2 <- tidy(model[[1]][[3]]) %>% 
    mutate(model = "Aesthetic Features Within Alley (ecological)",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  floral <- rbind(floral_v, floral_aes1, floral_aes2)
  
  floral_plot <- ggplot(data = floral, aes(x = estimate, y = factor(term, levels = c("MaintainedGardensYes common", "MaintainedGardensYes rare", "WildlifeSupportYes rare", "StructureConditionYes common", "StructureConditionYes rare", "PlayEquipmentYes common", "PlayEquipmentYes rare", "PublicArtYes common", "PublicArtYes rare", "Ruelle_area_m2", "Ruelle_length_m", "Groundcover_avg", "Midstorey_avg", "Canopy_avg")), group = model, color = model)) + 
    geom_point() + 
    geom_vline(xintercept= 0, linetype="dotted") + 
    geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) +
    theme_classic() + 
    labs(y = "", x = "") + 
    scale_y_discrete(labels = c("Maintained gardens: common", "Maintained gardens: rare", "Wildlife support features: rare", 
                                "Structures in good condition: common", "Structures in good condition: rare", "Games for children: common", "Games for children: rare", 
                                "Public art: common", "Public art: rare", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + 
    scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#440154FF")) + 
    theme(legend.position = "none",
          plot.title = element_text(size = 16, face = "bold"),
          axis.text = element_text(size = 16))
  
  return(floral_plot)
  
}



plot_noise <- function(model){
  noise_v <- tidy(model[[1]][[1]]) %>% 
    mutate(model = "Vegetation Within Alley + Structural Form",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  noise_b <- tidy(model[[2]][[1]]) %>% 
    mutate(model = "Surrounding Land Cover",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  noise_aes1 <- tidy(model[[1]][[2]]) %>% 
    mutate(model = "Aesthetic Features Within Alley (non-ecological)",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  noise_aes2 <- tidy(model[[1]][[3]]) %>% 
    mutate(model = "Aesthetic Features Within Alley (ecological)",
           low_lim = estimate - std.error,
           high_lim = estimate + std.error) %>% 
    filter(term != "(Intercept)")
  
  noise <- rbind(noise_v, noise_b, noise_aes1, noise_aes2)
  
  
  # create plot for noise
  plot <- ggplot(data = noise, aes(x = estimate, y = factor(term, levels = c("MaintainedGardensYes common", "MaintainedGardensYes rare", "WildlifeSupportYes rare", "StructureConditionYes common", "StructureConditionYes rare", "PlayEquipmentYes common", "PlayEquipmentYes rare", "PublicArtYes common", "PublicArtYes rare", 'road_area_m2', 'perbuild', 'perveggr', 'percan', 'Ruelle_area_m2', 'Ruelle_length_m', 'Groundcover_avg',  'Midstorey_avg', 'Canopy_avg')), group = model, color = model)) + 
    geom_point() + 
    geom_vline(xintercept= 0, linetype="dotted") + 
    geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) + xlim(-4, 6) + 
    theme_classic() + 
    labs(x = "", y = "", colour = "Model group") + 
    scale_y_discrete(labels = c("Maintained gardens: common", "Maintained gardens: rare", "Wildlife support features: rare", 
                                "Structures in good condition: common", "Structures in good condition: rare", "Games for children: common", "Games for children: rare", 
                                "Public art: common", "Public art: rare", "Main roads (50m buffer)", "Building cover (50m buffer)", "Vegetation cover (50m buffer)", "Canopy cover (50m buffer)", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + 
    scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#21908CFF", "#440154FF")) + 
    theme(plot.title = element_text(size = 16, face = "bold"),
          axis.text = element_text(size = 16),
          legend.text = element_text(size = 16),
          legend.title = element_text(size = 16))
  
  return(plot)
}
