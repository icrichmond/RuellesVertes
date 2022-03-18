# Packages ------------------------------------------
p <- c("data.table", "tuneR", "seewave")
lapply(p, library, character.only = T)

# Loading Data -------------------------------------
files <- readRDS("input/sensors/noise_common.rds")
# each Ruelle (subfolder) has ~ 30 GB of data, more manageable to loop through individually
files$subfolder <- as.factor(files$subfolder)

# test 
test <- subset(files, subfolder == "AudioMoth_RPP-H-1000003a" & starttimes >= "2021-08-18" & starttimes <= "2021-08-19") 

# Functions -----------------------------------------
# build a function that performs analysis for each ruelle individually 
noise <- function(files){
  
  p <- c("data.table", "tuneR", "seewave")
  lapply(p, library, character.only = T)
  
  for(i in seq_along(levels(files$subfolder))){
    
    fnames <- as.list(rownames(i))
    waves <- lapply(fnames, function(x) readWave(x))
    
    names(waves) <- fnames
    
    pdf("graphics/OscilloWavesTest.pdf")
    osc <- lapply(waves, function(x) oscillo(x))
    print(osc)
    dev.off()
  }
}

noise(test)
