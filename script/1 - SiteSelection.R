# Ruelles Vertes Site Selection 
# Authors: Isabella Richmond & Emily Kroft 

#### Load Packages ####
easypackages::packages("sf", "tidyverse")

#### Load & Clean Data ####
## Ruelles Vertes ##
rv <- read_sf("input/ruelles/ruelles-vertes.shp")
# select the alleys in the Plateau or Rosemont
rv$PROPRIETAI <- as.factor(rv$PROPRIETAI)
rv_pr <- subset(rv, PROPRIETAI == "Rosemont - La Petite-Patrie")
# merge all polygons that belong to the same alley
rv_pr <- rv_pr %>%
  dplyr::group_by(RUELLE_ID, PROPRIETAI) %>%
  dplyr::summarise(geometry = st_union(geometry))
#ruelles already have unique IDs

# transform to projection with units as metres with Quebec Albers 
rv_pr <- st_transform(rv_pr, crs = "+init=epsg:6624")
# save cleaned shapefiles as .rds objects
saveRDS(rv_pr, "output/RuellesRosemontPlateau.rds")
# save ruelles as a shapefile so that centreline can be calculated in QGIS 
write_sf(rv_pr, dsn = 'output/ruelles-shp/', layer = 'cleanruellesrosemont',  driver="ESRI Shapefile")
# get the extent of our study area so we can clip the roads layer 
bb <- st_bbox(rv_pr)

## Montreal Parks ##
# read in parks shapefile 
parcs <- read_sf("input/parcs/Espace_Vert.shp")
# filter for Montreal's large parks 
parcs <- st_transform(parcs, crs="+init=epsg:6624")
parcs <- st_crop(parcs,bb)
saveRDS(parcs, "output/ParksRosemont.rds")

#### Eliminating Outliers #### 
# we are removing any ruelles that fall outside a set of criteria.
## Parks ##
# remove any that are within 100 m of a large park
parcs_g <- subset(parcs, TYPO1 == "Grand parc")
y <- sf::st_join(rv_pr, parcs_g, left = F, join = st_is_within_distance, dist = 100) %>%
  group_by(RUELLE_ID) %>%
  summarize(Parcs = list(Nom))
y <- as_tibble(y) %>%
  select(-geometry)
# remove any ruelles from lns_ss that are found in y 
lns_ss <- anti_join(rv_pr, y)
saveRDS(lns_ss, "output/FinalRuelles.rds")

#### Final Sites ####
# we need to create three sampling points along the ruelles 
# 1/4 in, 1/2 in, 3/4 in 
spt <- st_line_sample(lns_ss, sample = c(0.25, 0.50, 0.75))
# extract coordinates (EPSG 6624)
spt_sin <- as.data.frame(st_coordinates(spt))
# add unique identifier for each ruelle's three points
spt_sin <- spt_sin %>%
  group_by(L1) %>%
  mutate(row = row_number())
# one row per ruelle 
spt_sin <- pivot_wider(spt_sin, id_cols = L1, names_from = row, values_from = c(X,Y))
# create final dataset of ruelle IDs and sampling points
final <- cbind(lns_ss, spt_sin)
write_csv(final, "output/Ruelles_SamplingPoints.csv")
