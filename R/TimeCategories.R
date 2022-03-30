timecat <- function(dataframe, datecolumn, starttime, endtime){ 
  p <- c("dplyr")
  lapply(p, library, character.only = T)
  
  
  dataframe |>
    mutate(times = as.numeric(format(datecolumn, "%H%M%S"))) |>
    filter(between(times, starttime, endtime)) %>%
    select(-times)
}