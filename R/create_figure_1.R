create_figure_1 <- function(){
  
  
  
  # create plot for max daily temp
  
  maxtemp_plot <- ggplot(data = maxtemp, aes(x = Estimate, y = Variable, group = Model, color = Model)) + 
    geom_point() + 
    geom_vline(xintercept= 0, linetype="dotted") + geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) + xlim(-16.5, 9.5) + theme_classic() + 
    scale_y_discrete(limits = c("Main roads (50m buffer)", "Building cover (50m buffer)", "Vegetation cover (50m buffer)", "Canopy cover (50m buffer)", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#21908CFF", "#440154FF")) + 
    theme(legend.position = "none")
  
  
  # create plot for min daily temp
  mintemp_plot <- ggplot(data = mintemp, aes(x = Estimate, y = Variable, group = Model, color = Model)) + 
    geom_point() + geom_vline(xintercept= 0, linetype="dotted") + geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) + xlim(-2.5, 4.5) + theme_classic() + 
    scale_y_discrete(limits = c("Main roads (50m buffer)", "Building cover (50m buffer)", "Vegetation cover (50m buffer)", "Canopy cover (50m buffer)", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#21908CFF", "#440154FF")) + 
    theme(legend.position = "none")
  
  # create plot for noise
  noise_plot <- ggplot(data = noise, aes(x = Estimate, y = Variable, group = Model, color = Model)) + 
    geom_point() + geom_vline(xintercept= 0, linetype="dotted") + geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) + xlim(-4, 6) + theme_classic() + 
    scale_y_discrete(limits = c("Maintained gardens: common", "Maintained gardens: rare", "Wildlife support features: common", "Wildlife support features: rare", 
                                "Structures in good condition: common", "Structures in good condition: rare", "Games for children: common", "Games for children: rare", 
                                "Public art: common", "Public art: rare", "Main roads (50m buffer)", "Building cover (50m buffer)", "Vegetation cover (50m buffer)", "Canopy cover (50m buffer)", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#21908CFF", "#440154FF")) + 
    theme(legend.position = "none")
  
  # create plot for floral
  floral_plot <- ggplot(data = floral, aes(x = Estimate, y = Variable, group = Model, color = Model)) + 
    geom_point() + geom_vline(xintercept= 0, linetype="dotted") + geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) + xlim(-4.5, 2.5) + theme_classic() + 
    scale_y_discrete(limits = c("Maintained gardens: common", "Maintained gardens: rare", "Wildlife support features: common", "Wildlife support features: rare", 
                                "Structures in good condition: common", "Structures in good condition: rare", "Games for children: common", "Games for children: rare", 
                                "Public art: common", "Public art: rare", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#440154FF")) + 
    theme(legend.position = "none")
  
  
  # create plot for food
  food_plot <- ggplot(data = food, aes(x = Estimate, y = Variable, group = Model, color = Model)) + 
    geom_point() + geom_vline(xintercept= 0, linetype="dotted") + geom_pointrange(aes(xmin = low_lim, xmax = high_lim)) + xlim(-3.5, 4.5) + theme_classic() + 
    scale_y_discrete(limits = c("Maintained gardens: common", "Maintained gardens: rare", "Wildlife support features: common", "Wildlife support features: rare", 
                                "Structures in good condition: common", "Structures in good condition: rare", "Games for children: common", "Games for children: rare", 
                                "Public art: common", "Public art: rare", 
                                "Alley area","Alley length", "Ground cover", "Midstory cover","Canopy cover")) + scale_color_manual(values = c("#FDE725FF", "#47C16EFF", "#440154FF")) + theme(legend.position = "none")
  
}