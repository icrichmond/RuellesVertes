# === Targets -------------------------------------------------------------
# Alec Robitaille & Isabella Richmond


# Source ------------------------------------------------------------------
library(targets)
tar_source('R')


# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')


# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()


# Variables ---------------------------------------------------------------

# Noise 
# folder path to all .wav files
folder_path <- file.path('D:', 'Ruelles-Vertes/')

## note: change these dates as needed for noise different analysis
min_date <- as.POSIXct('2021-08-10', tz = "UTC")
max_date <- as.POSIXct('2021-08-22', tz = "UTC")


# Analysis ----------------------------------------------------------------
source(file.path('script', 'sampling-selection-targets.R'))
source(file.path('script', 'temperature-analysis-targets.R'))
source(file.path('script', 'noise-analysis-targets.R'))
source(file.path('script', 'model-targets.R'))

# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)
