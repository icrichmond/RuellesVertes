# Packages -------------------------------------------------------
p <- c("dplyr", "ggplot2", "openxlsx")
lapply(p, library, character.only = T)

# Data -----------------------------------------------------------
full <- readRDS("output/canopytempfull.rds")
full <- lapply(full, function(x){x %>% mutate(across(totarea:perwat, as.numeric))})
full <-lapply(full, function(x){as.data.frame(x)})

# Plot function ---------------------------------------------------

pdf("graphics/CanopyRelationships.pdf")
for (i in seq(full)) {
  ggmax <- ggplot(aes(percan, Avg_max_daily_temp), data = full[[i]]) + 
    geom_point() +
    theme_classic() + 
    labs(x = "Canopy Cover in Buffer Area (%)", y = "Avg Maximum Daily Temp")+
    ggtitle(names(full[i]))
  print(ggmax)
  
  ggmin <- ggplot(aes(percan, Avg_min_daily_temp), data = full[[i]]) + 
    geom_point() +
    theme_classic() + 
    labs(x = "Canopy Cover in Buffer Area (%)", y = "Avg Minimum Daily Temp")+
    ggtitle(names(full[i]))
  print(ggmin)
}
dev.off()
