model_targets <- c(
  
  tar_file_read(
    rv,
    'input/RuelleVerte_data_all_metadata_2024Jul.csv',
    read.csv(!!.x)
  ),
  
  tar_target(
    model_max_temp,
    model_data(temp_plot, rv, road_area, "Avg_max_daily_temp")
  ),
  
  tar_target(
    model_min_temp,
    model_data(temp_plot, rv, road_area, "Avg_min_daily_temp")
  ),
  
  tar_target(
    model_noise,
    model_data(temp_plot, rv, road_area, "mean_NDSI")
  ),
  
  tar_target(
    model_habitat,
    model_data(temp_plot, rv, road_area, "Floral_coverage_per_m2")
  ),
  
  tar_target(
    model_food,
    model_data(temp_plot, rv, road_area, "Food_coverage_per_m2")
  ),
  
  tar_target(
    figure_2,
    create_figure_2(rv)
  ),
  
  tar_target(
    figure_3,
    create_figure_3(temp_plot, road_area, rv)
  ),
  
  tar_render(
    model_tables,
    'output/ModelTables.qmd'
  ),
  
  tar_render(
    model_boxwhisker,
    'output/BoxWhisker.qmd'
  )
  
  
  
)