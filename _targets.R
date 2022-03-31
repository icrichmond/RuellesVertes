# === Targets -------------------------------------------------------------



# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)


tar_option_set(format = 'qs')




# Variables ---------------------------------------------------------------
# TODO: fix this to your drive
folder_path <- file.path('input', 'Ruelles-Vertes')

# TODO: fix these dates
min_date <- as.POSIXct('2021-08-10')
max_date <- as.POSIXct('2021-08-22')



# Targets: Noise ----------------------------------------------------------
targets_noise <- c(
  tar_target(
    wav_files,
    dir(folder_path, full.names = TRUE, recursive = TRUE),
    format = 'file'
  ),
  tar_target(
    wav_paths,
    parse_wav_paths(wav_files)
  ),
  tar_target(
    wav_categorized,
    categorize_wav(
      wav_paths
    )
  ),
  tar_target(
    wav_filtered,
    filter_wav(
      wav_categorized,
      min_date = min_date,
      max_date = max_date
    )
  ),
  tar_target(
    wav_noise,
    calc_noise(wav_filtered),
    pattern = map(wav_filtered)
  )
)




# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)

