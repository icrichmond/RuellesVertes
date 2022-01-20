# Ruelles Vertes Site Selection 
# Authors: Isabella Richmond & Emily Kroft 

#### Load Packages ####
easypackages::packages("sf", "tidyverse", "mapview", "ggspatial")

#### Load Data ####
# Ruelles Vertes
rv_r <- readRDS("output/ruelles-sampling/RuellesRosemont.rds")
# All roads
rds <- readRDS("output/roads/RoadsRosemontPlateau.rds")
# Parks
parcs <- readRDS("output/parks/ParksRosemont.rds")
# Major roads
mjrds <- readRDS("output/roads/MajorRoadsRosemont.rds")
# Final ruelles
lns_ss <- readRDS("output/ruelles-sampling/FinalRuelles.rds")
# Sampling points
spt <- readRDS("output/ruelles-sampling/ruellessitesID.rds")

#### Mapview ####
# we can use mapview to investigate our spatial data like we would in Arc or Q
mapview(mjrds)
mapview(parcs)
mapview(rv_pr)
mapview(lns_ss)

#### Map ####
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
