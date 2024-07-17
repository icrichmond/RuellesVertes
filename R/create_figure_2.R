create_figure_2 <- function(rv, temp_plot) {
  
  b50 <- temp_plot$buffer50 |>
    mutate(RuelleID = str_replace_all(RuelleID, "-", "_"))
  
  full <- left_join(rv, b50, by = "RuelleID")
  
  
  
}