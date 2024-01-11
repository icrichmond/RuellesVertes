model_data <- function(temp_plot, rv, var){
  
  
  # Bind list of buffers together 
  temp <- do.call(rbind, Map(cbind.data.frame, temp_plot, name = names(temp_plot)))
  greenness.vars <- temp %>% 
    select(c("RuelleID", "perveggr", "percan", "name")) %>% 
    pivot_wider(names_from = name, values_from = c(perveggr, percan))
  
  # Indicate Which ES Vars to Select
  rv.vars <- rv %>% 
    select(c("RuelleID", "Food_coverage_per_m2", "Floral_coverage_per_m2",
             "mean_NDSI", "Avg_max_daily_temp", "Avg_min_daily_temp",
             "X50m_road_buffer" ,"X60m_road_buffer", "X70m_road_buffer" ,
             "X80m_road_buffer", "X90m_road_buffer" ,"X100m_road_buffer" ,
             "X200m_road_buffer", "X300m_road_buffer" ,"X400m_road_buffer" ,
             "X500m_road_buffer", "Ruelle_length_m","Ruelle_area_m2", "Groundcover_avg", "Midstorey_avg", "Canopy_avg",
             "PublicArt", "PlayEquipment","WildlifeSupport","MaintainedGardens","StructureCondition")) %>%
    mutate_if(is.character, as.factor)
  rv.vars$RuelleID <- gsub("_", "-", rv.vars$RuelleID)
  
  
  # Join
  full <- left_join(rv.vars, greenness.vars, by = "RuelleID")
  
  # Buffer distances
  b <- c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
  
  # add NDSI
  rv_na <- drop_na(rv)
  full_plot <- lapply(temp_plot, function(x){cbind(x, mean_NDSI = rv_na$mean_NDSI)})
  full_plot <- lapply(full_plot, function(x){cbind(x, Floral_coverage_per_m2 = rv_na$Floral_coverage_per_m2)})
  full_plot <- lapply(full_plot, function(x){cbind(x, Food_coverage_per_m2 = rv_na$Food_coverage_per_m2)})
  
  
  # Models ------------------------------------------------------
  
  # model
  veg <- lm(full[,var] ~ Groundcover_avg + Midstorey_avg + Canopy_avg + 
                  Ruelle_length_m + Ruelle_area_m2, data = full)
  

  aes1 <- lm(full[,var] ~ PublicArt + PlayEquipment + StructureCondition, data = full)
  
  aes2 <- lm(full[,var] ~ WildlifeSupport + MaintainedGardens, data = full)
  
  buff <- map(.x = full_plot, .f = function(x){lm(x[,var] ~ perimpgr + perveggr + perbuild + percan, data = x)}) %>%
    set_names(., nm = paste0(var, "_", b))
  
  # diagnostics
  win <- list(veg, aes1, aes2)
  names(win) <- c(paste0("veg_", var), paste0("aes1_", var), paste0("aes2_", var))
  
  mod <- list(win, buff)
  mod_figs <- purrr::map(.x = mod, .f = function(x){imap(x, resid_plots)})
  
  pdf(paste0("graphics/diagnostics/", var, "_diagnostics.pdf"))
  print(mod_figs)
  dev.off()
  
  
}