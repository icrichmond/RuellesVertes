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
# ruelles already have unique IDs but there are multiple entries per alley 

# transform to projection with units as metres with Quebec Albers 
rv_pr <- st_transform(rv_pr, crs = "+init=epsg:6624")
# save cleaned shapefiles as .rds objects
saveRDS(rv_pr, "output/RuellesRosemontPlateau.rds")
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

## Long Ruelles ## 
# calculate the centreline since ruelles vertes are polygons (QGIS?)
# st_cast doesn't work for this - temporarily using to work through code
lns <- st_cast(rv_pr, "LINESTRING")
# calculate length in meters
lng <- as_tibble(st_length(lns)) %>%
  rename(Length = value)
lng$Length <- as.double(lng$Length)
# add length to dataframe 
lns <- cbind(lns, lng)
# see length distributions 
ggplot(data = lns, (aes(x = Length))) + geom_histogram()
# majority of alleys are less than 200 m in length
# remove any that are greater than 200 m
lns_ss <- subset(lns, Length <= 200)

## Major Roads ##
# remove any that are directly adjacent to a major road 
# road classifications can be found here: https://nrn-rrn.readthedocs.io/en/latest/feature_catalog.html#terms-and-definitions
mjrds <- subset(rds, rdcls_en == "Freeway" | rdcls_en == "Expressway-Highway" |
                  rdcls_en == "Arterial")
saveRDS(mjrds, "output/MajorRoadsRosemontPlateau.rds")
# identify all ruelles that are within 50 m of a major road
x <- sf::st_join(lns_ss, mjrds, left = F, join = st_is_within_distance, dist = 50) %>%
  group_by(RUELLE_ID) %>%
  summarise(MajorRoads = list(rdsegnamen))
# remove geometry so x is not an sf object 
x <- as_tibble(x) %>%
  select(-geometry)
# remove any ruelles from lns_ss that are found in x
lns_ss <- anti_join(lns_ss, x)

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

#### Final Sites ####
# we need to create three sampling points along the ruelles 
# 1/4 in, 1/2 in, 3/4 in 
spt <- st_line_sample(lns_ss, sample = c(0.25, 0.50, 0.75))
# extract coordinates (EPSG 6624)
spt_sin <- as.data.frame(st_coordinates(spt))
spt_sin <- pivot_wider(spt_sin, id_cols = L1, values_from=c(X,Y))
# produce final list of ruelles and sampling points 
spt <- tibble(spt)
