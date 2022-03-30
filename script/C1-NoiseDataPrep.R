# Packages ------------------------------------------
p <- c("data.table")
lapply(p, library, character.only = T)

# Functions -----------------------------------------
source("R/RenamingFiles.R")

# Renaming Data -------------------------------------
# noise data is extremely large - stored on a separate drive 
# there is a separate folder for each ruelle with .wav files named by date-time 
# need .wav files to have ruelle ID in name
# (ONLY RUN ONCE - ALREADY RUN)
#folders <- as.list(list.files(path = "D:/Ruelles-Vertes"))
#lapply(folders, function(x) rename_batch(paste0("D:/Ruelles-Vertes/", x), "WAV"))

# Formatting Data -----------------------------------
# get all .wav file details 
details <- file.info(dir(path = "D:/Ruelles-Vertes/", pattern = ".WAV", recursive = T, full.names = TRUE), extra_cols = FALSE)
# add file names and subfolders as columns without the full path
details$filenames <- list.files(path = "D:/Ruelles-Vertes", pattern = ".WAV", recursive = T, full.names = FALSE, include.dirs = FALSE)
details$subfolder <- sub("/.*", "", details$filenames)    
details$filenames <- sub(".*?\\/", "", details$filenames)
# select just the part of the name that contains the date/time 
details$starttimes <- details$filenames |> (\(.)  sub(".*?\\/", "", .))() |> (\(.)  gsub("\\-.*", "", .))()
# convert into dates and times 
details$starttimes <- as.POSIXct(details$starttimes, format = '%Y%m%d_%H%M%S', tz = 'UTC')

# Filtering Data -------------------------------------
# need to filter files for common dates 
# 2021-08-18 to 2021-09-05
common <- with(details, details[(starttimes >= "2021-08-18" & starttimes <= "2021-09-05"), ])

# label subfolder as factor 
# each Ruelle (subfolder) has ~ 30 GB of data, more manageable to loop through individually
common$subfolder <- as.factor(common$subfolder)


# Store ----------------------------------------------
# save intermediate item
saveRDS(common, "input/sensors/noise_common.rds")
