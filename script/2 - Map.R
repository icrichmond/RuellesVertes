# Ruelles Vertes Site Selection 
# Authors: Isabella Richmond & Emily Kroft 

#### Load Packages ####
easypackages::packages("sf", "tidyverse", "mapview")

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
# ggplot works well for mapping sf objects