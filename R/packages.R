# Packages ----------------------------------------------------------------
library(targets)
library(tarchetypes)

library(data.table)
library(parsedate)

library(tuneR)
library(seewave)

# This package helps detect function conflicts
library(conflicted)
conflict_prefer('between', 'data.table', 'dplyr')
library(qs)

library(stars)
library(sf)
library(purrr)
library(dplyr)
library(stringr)
library(ggspatial)
library(ggplot2)
library(openxlsx)
library(tidyr)