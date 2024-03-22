# Packages ----------------------------------------------------------------
library(targets)
library(tarchetypes)
library(renv)

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
library(broom.mixed)
library(patchwork)
library(openxlsx)
library(tidyr)
library(units)

library(gt)
library(gtsummary)

library(marginaleffects)
library(dotwhisker)

conflict_prefer('filter', 'dplyr', 'stats')