# Packages ------------------------------------------
p <- c("data.table")
lapply(p, library, character.only = T)

# Functions -----------------------------------------
source("R/RenamingFiles.R")

# Renaming Data -------------------------------------
# noise data is extremely large - stored on a separate drive 
# there is a separate folder for each ruelle with .wav files named by date-time 
# need .wav files to have ruelle ID in name
# (ONLY RUN ONCE)
folders <- as.list(list.files(path = "D:/Ruelles-Vertes"))
lapply(folders, function(x) rename_batch(paste0("D:/Ruelles-Vertes/", x), "WAV"))

# Formatting Data -----------------------------------
# get all .wav file details 
details <- file.info(dir(path = "D:/Ruelles-Vertes/", pattern = ".WAV", recursive = T, full.names = TRUE), extra_cols = FALSE)
# add file names as a column without the full path
details$filenames <- list.files(path = "D:/Ruelles-Vertes", pattern = ".WAV", recursive = T, full.names = FALSE, include.dirs = FALSE)
details$filenames <- sub(".*?\\/", "", details$filenames)
# select just the part of the name that contains the date/time 
details$starttimes <- details$filenames |> (\(.)  sub(".*?\\/", "", .))() |> (\(.)  gsub("\\-.*", "", .))()
# convert into dates and times 
details$starttimes <- as.POSIXct(details$starttimes, format = '%Y%m%d_%H%M%S', tz = 'UTC')

# Filtering Data -------------------------------------
# need to filter files for common dates 
# 2021-08-18 to 2021-09-05


