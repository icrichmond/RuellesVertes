# note from Dr. Buxton: set bin size large (~ 1 sec) to reduce computational load
# Approach: 
# 1. Extract 1 week (7 days) of the sound data for each ruelle
# 2. for the 7 days of data, extract data recorded from 7:00-9:00, 12:00-14:00, and 17:00 - 19:00 for three different soundscapes
# 3. Calculate ACI and NDSI for each soundscape
# 4. If this produces a single ACI and NDSI value for each soundscape in each ruelle (so three values for each ruelle - one for morning, one for afternoon and one for evening), we are all good. If not, then average the values for each soundscape, to get a single ACI and NDSI value for morning, afternoon and evening for each ruelle.

# Data ----------------------------------------------
files <- readRDS("input/sensors/noise_common.rds")


# Noise Analysis -------------------------------------

testf <- as.list(by(morning, morning$subfolder, FUN = rownames))

testf <- lapply(testf, function(x) lapply(x, function(x){
  w <- readWave(x) # need to figure out names
  a <- ACI(w) # need to export as df
  n <- NDSI(soundscapespec(w)) # need to wrap in figure call 
}))
# Function --------------------------------------------
noise <- function(files, startdate, enddate){
  
  # packages 
  p <- c("data.table", "tuneR", "seewave")
  lapply(p, library, character.only = T)
  
  # define the subset of dates you are interested in 
  subfiles <- files[(files$starttimes > startdate & files$starttimes < enddate),] 
  
  # want three soundscapes - morning, afternoon, evening for each ruelle
  source("R/TimeCategories.R")
  morning <- timecat(subfiles, subfiles$starttimes, 070000, 090000)
  afternoon <- timecat(subfiles, subfiles$starttimes, 120000, 140000)
  evening <- timecat(subfiles, subfiles$starttimes, 170000, 190000)
  
  # do a noise analysis for each soundscape (morning, afternoon, evening)
  cats <- list(morning, afternoon, evening)
  names(cats) = c("morning", "afternoon", "evening")
  
  # get rownames by subfolder for each time category
  subs <- lapply(cats, function(x) as.list(by(x, x$subfolder, FUN = rownames)))
  
  # loop through subfolders for each time category and perform noise analysis
  return(subs)
  
  
}

n <- noise(files, "2021-08-15", "2021-08-22")
