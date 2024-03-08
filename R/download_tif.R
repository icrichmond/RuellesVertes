download_tif <- function(url, dest){
  
  temp <- tempfile()
  
  download.file(url, temp, mode = "wb")
  
  unzip(temp, exdir = dest)
  
  star <- read_stars(paste0(file.path(dest), "/660_IndiceCanopee_2019.tif"))
  
  return(star)
}