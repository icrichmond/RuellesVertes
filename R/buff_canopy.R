buff_canopy <- function(sens, cc) {
  
  # produce buffers every 10 m
  b <- seq(10, 100, by = 10)
  
  # calculate buffers at each distance for all sensors
  buffers <- purrr::map(.x = b,
                        .f = function(x){st_buffer(sens, x)}) %>%
    purrr::set_names(., nm = paste0("buffer", b))
  
  # intersect buffers with canopy
  ints <- purrr::map(.x = buffers, .f = function(x){
    
    x <- x %>% mutate(totarea = st_area(geometry))
    
    can <- aggregate(cc, x, FUN = function(y) sum(y == 4)/length(y)) %>% 
      st_as_sf() %>% 
      rename(percan = `660_IndiceCanopee_2019.tif`)
    
    impgr <- aggregate(cc, x, FUN = function(y) sum(y == 1)/length(y)) %>% 
      st_as_sf() %>% 
      rename(perimpgr = `660_IndiceCanopee_2019.tif`)
    
    veggr <- aggregate(cc, x, FUN = function(y) sum(y == 3)/length(y)) %>% 
      st_as_sf() %>% 
      rename(perveggr = `660_IndiceCanopee_2019.tif`)
    
    build <- aggregate(cc, x, FUN = function(y) sum(y == 2)/length(y)) %>% 
      st_as_sf() %>% 
      rename(perbuild = `660_IndiceCanopee_2019.tif`)
    
    wat <- aggregate(cc, x, FUN = function(y) sum(y == 5)/length(y)) %>% 
      st_as_sf() %>% 
      rename(perwat = `660_IndiceCanopee_2019.tif`)
    
    df <- data.frame(RuelleID = x$RuelleID, 
                     totarea = x$totarea,
                     percan = can$percan,
                     perimpgr = impgr$perimpgr,
                     perveggr = veggr$perveggr,
                     perbuild = build$perbuild,
                     perwat = wat$perwat)
    
    })%>%
    purrr::set_names(., nm = paste0("int", b))
  
  ints <- purrr::map(.x = ints, .f = function(x){st_make_valid(x)})
  
  
  return(ints)
}