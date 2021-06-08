# Ruelles Vertes Site Selection 
# Authors: Isabella Richmond & Emily Kroft 

#### Load Packages ####
easypackages::packages("sf", "tidyverse", "mapview", "ggspatial")

#### Load Data ####
# Ruelles Vertes
rv_pr <- readRDS("output/RuellesRosemontPlateau.rds")
# All roads
rds <- readRDS("output/RoadsRosemontPlateau.rds")
# Parks
parcs <- readRDS("output/ParksRosemontPlateau.rds")
# Major roads
mjrds <- readRDS("output/MajorRoadsRosemontPlateau.rds")
# Final ruelles
lns_ss <- readRDS("output/FinalRuelles.rds")

#### Mapview ####
# we can use mapview to investigate our spatial data like we would in Arc or Q
mapview(mjrds)
mapview(parcs)
mapview(rv_pr)
mapview(lns_ss)

#### Map ####
ggplot() + 
  geom_sf(data = rv_pr, col = "black") + 
  geom_sf(data = parcs, fill = "palegreen4") + 
  geom_sf(data = mjrds,  col = "gray44") + 
  coord_sf(crs = "+init=epsg:6624") + 
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "br", which_north = "true", style = north_arrow_fancy_orienteering) +
  theme(panel.grid.major = element_line(color = gray(.1), linetype = "dashed", size = 0.1),
        panel.background = element_rect(fill = NA))
ggsave("graphics/AllRuelles_MjrRds_Parcs_RosemontPlateau.jpg",dpi = 400)
