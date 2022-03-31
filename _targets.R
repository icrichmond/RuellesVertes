# === Targets -------------------------------------------------------------



# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)


tar_option_set(format = 'qs')




# Variables ---------------------------------------------------------------
# TODO: fix this to your drive
folder_path <- file.path('input', 'Ruelles-Vertes')

min_date <- as.Date('2021-08-15')
max_date <- as.Date('2021-08-22')



# Targets: Noise ----------------------------------------------------------
c(
  tar_target(
    wav_paths,
    get_wav_paths(folder_path)
  ),
  tar_target(
    cat_wav,
    categorize_wav(
      wav_paths
    )
  ),
  tar_target(
    filter_wav,
    filter_wav(
      cat_wav,
      min_date = min_date,
      max_date = max_date,
    )
  )
)




# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)

