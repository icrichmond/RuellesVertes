# Goal is to produce a quick analysis of the noise data including ACI, NDSI, and L10
# note from Dr. Buxton: set bin size large (~ 1 sec) to reduce computational load
# note from Marie: use seewave package to tackle ACI and NDSI 
# Approach: 
# 1. Extract 1 week (7 days) of the sound data for each ruelle
# 2. for the 7 days of data, extract data recorded from 7:00-9:00, 12:00-14:00, and 17:00 - 19:00 for three different soundscapes
# 3. Calculate ACI and NDSI for each soundscape
# 4. If this produces a single ACI and NDSI value for each soundscape in each ruelle (so three values for each ruelle - one for morning, one for afternoon and one for evening), we are all good. If not, then average the values for each soundscape, to get a single ACI and NDSI value for morning, afternoon and evening for each ruelle.


# Packages ------------------------------------------
p <- c("data.table", "dplyr", "tuneR", "seewave")
lapply(p, library, character.only = T)

# Functions -----------------------------------------
timecat <- function(dataframe, datecolumn, starttime, endtime){ 
  dataframe |>
    mutate(times = as.numeric(format(datecolumn, "%H%M%S"))) |>
    filter(between(times, starttime, endtime)) %>%
    select(-times)
}

# Data ----------------------------------------------
files <- readRDS("input/sensors/noise_common.rds")

# each Ruelle (subfolder) has ~ 30 GB of data, more manageable to loop through individually
files$subfolder <- as.factor(files$subfolder)

# define the subset of dates you are interested in 
subfiles <- files[(files$starttimes> "2021-08-15" & files$starttimes < "2021-08-22"),]

# want three soundscapes - morning, afternoon, evening for each ruelle 
morning <- timecat(subfiles, subfiles$starttimes, 070000, 090000)
afternoon <- timecat(subfiles, subfiles$starttimes, 120000, 140000)
evening <- timecat(subfiles, subfiles$starttimes, 170000, 190000)


# Noise Analysis -------------------------------------

testf <- as.list(by(morning, morning$subfolder, FUN = rownames))

testf <- lapply(testf, function(x) lapply(x, function(x){
  w <- readWave(x) # need to figure out names
  a <- ACI(w) # need to export as df
  s <- soundscapespec(w)
  n <- NDSI(s) # need to wrap in figure call 
}))
