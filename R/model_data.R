model_data <- function(temp_plot, rv, road_area, var){
  
  
  # Indicate Which ES Vars to Select
  rv.vars <- rv %>% 
    select(c("RuelleID", "Food_coverage_per_m2", "Floral_coverage_per_m2",
             "mean_NDSI", "Avg_max_daily_temp", "Avg_min_daily_temp",
             "Ruelle_length_m","Ruelle_area_m2", "Groundcover_avg", "Midstorey_avg", "Canopy_avg",
             "PublicArt", "PlayEquipment","WildlifeSupport","MaintainedGardens","StructureCondition")) %>%
    mutate_if(is.character, as.factor)
  rv.vars$RuelleID <- gsub("_", "-", rv.vars$RuelleID)
  
  # scale numeric variables
  rv.vars.s <- rv.vars %>%
    mutate_if(is.numeric, ~as.numeric(scale(.x)))
  
  # save altogether for figs
  rv.vars.full <- inner_join(rv.vars, rv.vars.s, by = "RuelleID", suffix = c("", "_s"))
  saveRDS(rv.vars.full, 'output/RV_vars.rds')
  
  
  # Buffer distances
  b <- c(50, 100)
  
  # select relevant buffers from the list
  temp_plot <- temp_plot[c('buffer50', 'buffer100')]
  
  # add road area 
  temp_plot[['buffer50']]$road_area_m2 <- road_area[['buffer50']]$road_area_m2
  temp_plot[['buffer100']]$road_area_m2 <- road_area[['buffer100']]$road_area_m2
  
  # add missing variables
  rv_na <- drop_na(rv)
  full_plot <- lapply(temp_plot, function(x){cbind(x, mean_NDSI = rv_na$mean_NDSI)})
  full_plot <- lapply(full_plot, function(x){cbind(x, Floral_coverage_per_m2 = rv_na$Floral_coverage_per_m2)})
  full_plot <- lapply(full_plot, function(x){cbind(x, Food_coverage_per_m2 = rv_na$Food_coverage_per_m2)})
  
  # scale numeric variables
  full_plot_s <- lapply(full_plot, function(x){t <- x %>% mutate_if(is.numeric, ~as.numeric(scale(.x)))})
  
  # save for plotting
  df50 <- inner_join(full_plot$buffer50, full_plot_s$buffer50, inner_join, by = "RuelleID", suffix = c("", "_s"))
  df100 <- inner_join(full_plot$buffer100, full_plot_s$buffer100, inner_join, by = "RuelleID", suffix = c("", "_s"))
  
  lis <- list(df50, df100)
  names(lis) <- c('buffer50', 'buffer100')
  
  saveRDS(lis, 'output/buffer_vars.rds')
  

  # Models ------------------------------------------------------
  
  # model
  veg <- lm(rv.vars.s[,var] ~ Groundcover_avg + Midstorey_avg + Canopy_avg + 
                  Ruelle_length_m + Ruelle_area_m2, data = rv.vars)
  

  aes1 <- lm(rv.vars.s[,var] ~ PublicArt + PlayEquipment + StructureCondition, data = rv.vars)
  
  aes2 <- lm(rv.vars.s[,var] ~ WildlifeSupport + MaintainedGardens, data = rv.vars)
  
  buff <- map(.x = full_plot_s, .f = function(x){lm(x[,var] ~ perveggr + perbuild + percan + road_area_m2, data = x)}) %>%
    set_names(., nm = paste0(var, "_", b))
  
  # diagnostics
  win <- list(veg, aes1, aes2)
  names(win) <- c(paste0("veg_", var), paste0("aes1_", var), paste0("aes2_", var))
  
  mod <- list(win, buff)
  mod_figs <- purrr::map(.x = mod, .f = function(x){imap(x, resid_plots)})
  
  pdf(paste0("graphics/diagnostics/", var, "_diagnostics.pdf"))
  print(mod_figs)
  dev.off()
  
  return(mod)
  
  
}
