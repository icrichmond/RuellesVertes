# Packages ------------------------------------------
p <- c("data.table")
lapply(p, library, character.only = T)

# Functions -----------------------------------------
source("R/RenamingFiles.R")

# Renaming Data -------------------------------------
# noise data is extremely large - stored on a separate drive 
# there is a separate folder for each ruelle with .wav files named by date-time 
# need .wav files to have ruelle ID in name 
rename_batch("D:/Ruelles-Vertes/", "WAV")

# Filtering Data --------------------------------------
# need to filter each folder (1 for each Ruelle ID) for common dates 
# 18-08-2021 to 05-09-2021

# get file details 
details = file.info(list.files(path = "D:/Ruelles-Vertes/", pattern="*.WAV"))
details = details[with(details, order(as.POSIXct(mtime))), ]
files = rownames(details)
# select files within specified time frame and write to new folder 