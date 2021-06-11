# Ruelles Vertes Site Selection 
# Authors: Isabella Richmond & Emily Kroft 

#### Load Packages ####
easypackages::packages("sf", "tidyverse")

#### Load & Clean Data ####
## Ruelles Vertes ##
rv <- read_sf("input/ruelles/ruelles-vertes.shp")
# select the alleys in the Plateau or Rosemont
rv$PROPRIETAI <- as.factor(rv$PROPRIETAI)
rv_r <- subset(rv, PROPRIETAI == "Rosemont - La Petite-Patrie")
# merge all polygons that belong to the same alley
rv_r <- rv_r %>%
  dplyr::group_by(RUELLE_ID) %>%
  dplyr::summarise(geometry = st_union(geometry))
#ruelles already have unique IDs

# transform to projection with units as metres with Quebec Albers 
rv_r <- st_transform(rv_r, crs = "+init=epsg:6624")
# save cleaned shapefiles as .rds objects
saveRDS(rv_r, "output/RuellesRosemont.rds")
# save ruelles as a shapefile so that sampling points can be calculated in QGIS 
write_sf(rv_r, dsn = 'output/ruelles-shp/', layer = 'cleanruellesrosemont',  driver="ESRI Shapefile")
# get the extent of our study area so we can clip the roads layer 
bb <- st_bbox(rv_r)

## Montreal Parks ##
# read in parks shapefile 
parcs <- read_sf("input/parcs/Espace_Vert.shp")
# filter for Montreal's large parks 
parcs <- st_transform(parcs, crs="+init=epsg:6624")
parcs <- st_crop(parcs,bb)
saveRDS(parcs, "output/ParksRosemont.rds")

## Montreal Roads ##
# for mapping 
rds <- read_sf("input/roads/road_segment_1.shp")
# reproject and clip so that it roads are in the same projection
rds <- st_transform(rds, crs = "+init=epsg:6624")
rds <- st_crop(rds, bb)
# select only major roads
mjrds <- subset(rds, rdcls_en == "Freeway" | rdcls_en == "Expressway-Highway" |
                  rdcls_en == "Arterial")
saveRDS(mjrds, "output/MajorRoadsRosemont.rds")

#### Eliminating Outliers #### 
# we are removing any ruelles that fall outside a set of criteria.
## Parks ##
# remove any that are within 100 m of a large park
parcs_g <- subset(parcs, TYPO1 == "Grand parc")
y <- sf::st_join(rv_r, parcs_g, left = F, join = st_is_within_distance, dist = 100) %>%
  group_by(RUELLE_ID) %>%
  summarize(Parcs = list(Nom))
y <- as_tibble(y) %>%
  select(-geometry)
# remove any ruelles from lns_ss that are found in y 
lns_ss <- anti_join(rv_r, y)
saveRDS(lns_ss, "output/FinalRuelles.rds")


#### Final Sites ####
# Emily created create three sampling points along the ruelles in QGIS
# 1/4 in, 1/2 in, 3/4 in 
# for oddly shaped ruelles, more sampling points were added 
# import shapefile 
spt <- read_sf("output/sampling_points/ruellessites.shp")
spt <- st_transform(spt, crs = "+init=epsg:6624")
# id column has some accidental duplicates so will generate
# unique ID based on row number and remove original id column 
spt <- spt %>% 
  tibble::rowid_to_column("Uniq_S_ID") %>%
  dplyr::select(-id)
saveRDS(spt, "output/ruellessitesID.rds")
# extract coordinates into more readable format 
spt <- spt %>%
  dplyr::mutate(lat = sf::st_coordinates(.)[,1],
                lon = sf::st_coordinates(.)[,2])
# associate sampling points with their ruelles 
rv_sp <- st_join(rv_r, spt, join = st_intersects)
# five ruelles have NA values because the end/extension 
# of the ruelle was given a different ID. But they are
# effectively sampled - so drop all NAs from dataset
rv_sp <- drop_na(rv_sp)
# join spt dataframe based on sampling id 
spt_df <- as.data.frame(spt)
rv_sp <- inner_join(rv_sp, spt_df, by = "Uniq_S_ID")
# remove ruelle polygon geometry 
rv_sp <- select(rv_sp, -c(lat.x, lon.x, geometry.x, geometry.y)) %>%
  rename(lat = lat.y) %>%
  rename(long = lon.y)
# create consecutive sampling ID within each group
rv_sp <- rv_sp %>% 
  dplyr::group_by(RUELLE_ID) %>%
  dplyr::mutate(Group_S_ID = paste0(RUELLE_ID, "_", 1:n()))
# save as long dataset 
write_csv(rv_sp, "output/Ruelles_SamplingPoints_Long.csv")
  
# create wide dataset 
# remove Group_S_ID column and recreate without ruelle id 
rv_sp_w <- select(rv_sp, -Group_S_ID)
rv_sp_w <- rv_sp_w %>% 
  dplyr::group_by(RUELLE_ID) %>%
  dplyr::mutate(Group_S_ID = paste0("S", 1:n()))
# pivot wider
rv_sp_w <- pivot_wider(rv_sp_w, 
                       id_cols = RUELLE_ID,
                       names_from = Group_S_ID,
                       values_from = c(lat,long))
# save wide dataset
write_csv(rv_sp_w, "output/Ruelles_SamplingPoints_Wide.csv")
