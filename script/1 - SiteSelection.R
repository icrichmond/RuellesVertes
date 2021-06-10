# Ruelles Vertes Site Selection 
# Authors: Isabella Richmond & Emily Kroft 

#### Load Packages ####
easypackages::packages("sf", "tidyverse")

#### Load & Clean Data ####
## Ruelles Vertes ##
rv <- read_sf("input/ruelles/ruelles-vertes.shp")
# select the alleys in the Plateau or Rosemont
rv$PROPRIETAI <- as.factor(rv$PROPRIETAI)
rv_pr <- subset(rv, PROPRIETAI == "Rosemont - La Petite-Patrie" | 
                  PROPRIETAI == "Plateau - Mont-Royal")
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
write_sf(rv_pr, dsn = 'output/ruelles-shp/', layer = 'cleanruelles',  driver="ESRI Shapefile")
# get the extent of our study area so we can clip the roads layer 
bb <- st_bbox(rv_pr)

## Montreal Roads ## 
rds <- read_sf("input/roads/road_segment_1.shp")
# reproject and clip so that it roads are in the same projection
rds <- st_transform(rds, crs = "+init=epsg:6624")
rds <- st_crop(rds, bb)
saveRDS(rds, "output/RoadsRosemontPlateau.rds")

## Montreal Parks ##
parcs <- read_sf("input/parcs/Espace_Vert.shp")
parcs <- st_transform(parcs, crs="+init=epsg:6624")
parcs <- st_crop(parcs,bb)
saveRDS(rds, "output/ParksRosemontPlateau.rds")

#### Eliminating Outliers #### 
# we are removing any ruelles that fall outside a set of criteria.
## Parks ##
# remove any that are within 50 m of a large park
parcs <- subset(parcs, Type == "Parc")
saveRDS(parcs, "output/ParksRosemontPlateau.rds")
y <- sf::st_join(lns, parcs, left = F, join = st_is_within_distance, dist = 50) %>%
  group_by(RUELLE_ID) %>%
  summarize(Parcs = list(Nom))
y <- as_tibble(y) %>%
  select(-geometry)
# remove any ruelles from lns_ss that are found in y 
lns_ss <- anti_join(lns_ss, y)
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
