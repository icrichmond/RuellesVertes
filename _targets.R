# === Targets -------------------------------------------------------------
# Alec Robitaille & Isabella Richmond


# Source ------------------------------------------------------------------
library(targets)
tar_source('R')


# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')
options(timeout=1200)


# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()


# Variables ---------------------------------------------------------------

# Noise 
# folder path to all .wav files
### NOTE !!! #### 
# For your own project/needs: make sure to change this file path to wherever you have .wav files stored 
# For reproducing this analysis: change this line to 
#folder_path <- file.path('input/example-audio-files/')
folder_path <- file.path('D:/', 'Ruelles-Vertes/')


## note: change these dates as needed for noise different analysis
min_date <- as.POSIXct('2021-08-10', tz = "UTC")
max_date <- as.POSIXct('2021-08-22', tz = "UTC")



# Scripts -----------------------------------------------------------------
tar_source('script')


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)
