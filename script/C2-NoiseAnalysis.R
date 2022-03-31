# note from Dr. Buxton: set bin size large (~ 1 sec) to reduce computational load
# Approach: 
# 1. Extract 1 week (7 days) of the sound data for each ruelle
# 2. for the 7 days of data, extract data recorded from 7:00-9:00, 12:00-14:00, and 17:00 - 19:00 for three different soundscapes
# 3. Calculate ACI and NDSI for each soundscape
# 4. If this produces a single ACI and NDSI value for each soundscape in each ruelle (so three values for each ruelle - one for morning, one for afternoon and one for evening), we are all good. If not, then average the values for each soundscape, to get a single ACI and NDSI value for morning, afternoon and evening for each ruelle.

# Data ----------------------------------------------
files <- readRDS("input/sensors/noise_common.rds")



# Noise Analysis -------------------------------------


# going to be lists of morning, afternoon, evening 
# then lists of folders, then lists of values



df <- lapply(subtest, function(x) do.call("rbind", x))

dfcalc <- lapply(df, function(x) x %>% 
                   rename(ACI = unlist.a. , 
                          NDSI = unlist.n.) %>%
                   summarise(meanACI = mean(ACI), 
                          sdACI = sd(ACI), 
                          rangeACI = list(range(ACI)),
                          meanNDSI = mean(NDSI), 
                          sdNDSI = sd(NDSI), 
                          rangeNDSI = list(range(NDSI))))

dfall <- do.call("rbind", dfcalc) 
dfall$RuelleID <- rownames(dfall)



# for in the actual function 
u <- subtest |> (\(x) unlist(x, recursive = F))() |> (\(x) unlist(x, recursive = F))()
mn <- unlist(m)
names(u) <- mn
df <- do.call("rbind", u)



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
  noisedata <- lapply(subs, function(x) lapply(x, function(y) lapply(y, function(z) {
    # read files as waves and name that list
    w <- readWave(z)
    
    # calculate ACI for each file 
    a <- ACI(w) 
    
    # calculate NDSI 
    n <- NDSI(soundscapespec(w, plot = F))
    
    # remove extremely large wave files
    rm(w) 
    
    # create a dataframe for both measures for each wave file
    d <- data.frame(unlist(a), unlist(n))
    
  })))
  
  return(noisedata)
  
  # clean data to usable format
  
}

n <- noise(files, "2021-08-15", "2021-08-22")
