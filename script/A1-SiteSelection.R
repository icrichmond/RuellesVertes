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
# ruelles already have unique IDs
# 8 ruelles have two separate locations assigned to the same RUELLE_ID
# select these 8 
rv_m <- subset(rv_r, RUELLE_ID == "RPP-H-1000003" | 
                 RUELLE_ID == "RPP-H-1000008" | 
                 RUELLE_ID == "RPP-H-1000012" | 
                 RUELLE_ID == "RPP-H-1000014" |
                 RUELLE_ID == "RPP-H-1000044" |
                 RUELLE_ID == "RPP-H-1000070" |
                 RUELLE_ID == "RPP-I-1000010" |
                 RUELLE_ID == "RPP-I-1000102")
# separate polygons
rv_m <- st_cast(rv_m, "MULTIPOLYGON") %>% st_cast("POLYGON")
# label separate polygons with the same RUELLE_ID a & b
rv_m <- rv_m %>% 
  dplyr::group_by(RUELLE_ID) %>%
  dplyr::mutate(RUELLE_ID = paste0(RUELLE_ID, ".", 1:n()))
rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, fixed(".1"), "a")
rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, fixed(".2"), "b")
rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, fixed(".3"), "c")
# RPP-H-1000044.b and RPP-H-1000003.c are not representative of the actually ruelles
# remove these from dataset 
rv_m <- subset(rv_m, RUELLE_ID != "RPP-H-1000003c" &
                 RUELLE_ID != "RPP-H-1000044b")
rv_m$RUELLE_ID <- str_replace(rv_m$RUELLE_ID, "RPP-H-1000044c", "RPP-H-1000044b")
# remove original rows of the 8 unique ruelles from rv_r dataset and replace
rv_r <- subset(rv_r, RUELLE_ID != "RPP-H-1000003" & 
                 RUELLE_ID != "RPP-H-1000008" & 
                 RUELLE_ID != "RPP-H-1000012" & 
                 RUELLE_ID != "RPP-H-1000014" &
                 RUELLE_ID != "RPP-H-1000044" &
                 RUELLE_ID != "RPP-H-1000070" &
                 RUELLE_ID != "RPP-I-1000010" &
                 RUELLE_ID != "RPP-I-1000102")
rv_r <- rbind(rv_m, rv_r)


# transform to projection with units as metres with Quebec Albers 
rv_r <- st_transform(rv_r, crs = "+init=epsg:6624")
# save cleaned shapefiles as .rds objects
saveRDS(rv_r, "output/ruelles-sampling/RuellesRosemont.rds")
# save ruelles as a shapefile so that sampling points can be calculated in QGIS 
write_sf(rv_r, dsn = 'output/ruelles-shp/', layer = 'cleanruellesrosemont',  driver="ESRI Shapefile")
st_write(rv_r, "output/ruelles-sampling/rosemontruelles.kml", driver = "kml")
# get the extent of our study area so we can clip the roads layer 
bb <- st_bbox(rv_r)

## Montreal Parks ##
# read in parks shapefile 
parcs <- read_sf("input/parcs/Espace_Vert.shp")
# filter for Montreal's large parks 
parcs <- st_transform(parcs, crs="+init=epsg:6624")
parcs <- st_crop(parcs,bb)
saveRDS(parcs, "output/parks/ParksRosemont.rds")

## Montreal Roads ##
# for mapping 
rds <- read_sf("input/roads/road_segment_1.shp")
# reproject and clip so that it roads are in the same projection
rds <- st_transform(rds, crs = "+init=epsg:6624")
rds <- st_crop(rds, bb)
# select only major roads
mjrds <- subset(rds, rdcls_en == "Freeway" | rdcls_en == "Expressway-Highway" |
                  rdcls_en == "Arterial")
saveRDS(mjrds, "output/roads/MajorRoadsRosemont.rds")

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
saveRDS(lns_ss, "output/ruelles-sampling/FinalRuelles.rds")


#### Final Sites ####
# Emily created create three sampling points along the ruelles in QGIS
# 1/4 in, 1/2 in, 3/4 in 
# import shapefile 
spt <- read_sf("output/sampling_points/ruellessites.shp")
spt <- st_transform(spt, crs = "+init=epsg:6624")
# id column has some accidental duplicates so will generate
# unique ID based on row number and remove original id column 
spt <- spt %>% 
  tibble::rowid_to_column("Uniq_S_ID") %>%
  dplyr::select(-id)
saveRDS(spt, "output/ruelles-sampling/ruellessitesID.rds")
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
# join rv_sp to spt to save kml layer for google maps 
rv_sp <- arrange(rv_sp, Uniq_S_ID)
spt <- select(spt, -c(lat,lon))
spt_kml <- inner_join(rv_sp, spt)
spt_kml <- st_as_sf(spt_kml)
st_write(spt_kml, "output/ruelles-sampling/ruellessitesID.kml", driver = "kml")

# save as long dataset 
write_csv(rv_sp, "output/ruelles-sampling/Ruelles_SamplingPoints_Long.csv")
  
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
write_csv(rv_sp_w, "output/ruelles-sampling/Ruelles_SamplingPoints_Wide.csv")
