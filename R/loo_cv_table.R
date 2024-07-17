loo_cv_table <- function(rv_vars_full, buffer_vars_full){
  
  # drop NAs
  rv_vars_full <- rv_vars_full %>% 
    drop_na()
  
  # select 50 m buffer distance
  full_plot <- buffer_vars_full[[1]]
  
  # remake models
  deps <- c("Avg_max_daily_temp_s", "Avg_min_daily_temp_s", "mean_NDSI_s", 
            "Floral_coverage_per_m2_s", "Food_coverage_per_m2_s")
  
  rv_mods <- lapply(deps, FUN = function(x){
    
    fm <- as.formula(paste(x, "~ Groundcover_avg_s + Midstorey_avg_s + Canopy_avg_s + 
                             Ruelle_length_m_s + Ruelle_area_m2_s"))
    eval(bquote(   lm(.(fm), data = rv_vars_full)))
    })
  
  names(rv_mods) <- deps
  
  buff_mods <- lapply(deps, FUN = function(x){
    fm <- as.formula(paste(x, " ~ perveggr_s + perbuild_s + percan_s + road_area_m2_s"))
    
    eval(bquote(   lm(.(fm), data = full_plot)))
  })
  
  names(buff_mods) <- deps
  
  # run LOO-CV and make a table with statistics
  
  
  cv <- cv.glm(rv_vars_full, rv_mods$Avg_max_daily_temp_s, K = nrow(rv_vars_full))
}