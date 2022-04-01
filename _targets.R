# === Targets -------------------------------------------------------------
# Alec Robitaille & Isabella Richmond


# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)


tar_option_set(format = 'qs')



# Variables ---------------------------------------------------------------

# Sampling 



# Temperature



# Noise 

folder_path <- file.path('D:', 'Ruelles-Vertes/')

## note: change these dates as needed for different analysis
min_date <- as.POSIXct('2021-08-10')
max_date <- as.POSIXct('2021-08-22')


# Analysis ----------------------------------------------------------------
source(file.path('script', 'sampling-selection-targets.R'))
source(file.path('script', 'temperature-analysis-targets.R'))
source(file.path('script', 'noise-analysis-targets.R'))


# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)

