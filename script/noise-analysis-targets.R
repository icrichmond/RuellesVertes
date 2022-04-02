
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
  ),
  tar_target(
    merge_noise,
    merge(
      wav_noise,
      wav_filtered,
      by = 'path'
    )
  ),
  tar_target(
    summ_noise, 
    summarise_noise(merge_noise)
  ),
  tar_target(
    noise_outputs,
    write.csv(summ_noise, "output/SummarizedNoiseData.csv")
  )
)


