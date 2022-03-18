# Function taken from: https://stackoverflow.com/questions/47557066/add-a-suffix-to-filenames-based-on-subfolder-names-within-a-directory-in-r

# An auxiliary function
rename_file <- function(str, extra){
  file_name <- tools::file_path_sans_ext(str)
  file_ext <- tools::file_ext(str)
  return(paste0(file_name, '-', extra, '.', file_ext))
}

rename_batch <- function(path = "./",
                         extension = 'WAV'){
  library(stringr)
  
  # Separate files from folders
  l <- list.files(path)
  files <- l[grepl(paste0("\\." , extension), l)]
  folders <- list.dirs(path, F, F)
  
  present_folder <- 
    stringr::str_extract(path, '(?<=/)([^/]+)$')
  
  # Check if there is a / at the end of path and removes it
  # for consistency
  path_len <- nchar(path)
  last <- substr(path, path_len, path_len)
  if (last == '/') {
    path <- substr(path, 1, path_len - 1)
  }
  
  if (length(files) > 0) {
    file_updtate <- paste0(path, '/', files)
    file.rename(file_updtate, rename_file(file_updtate, present_folder))
  }
  
  if (length(folders) > 0) {
    for (i in paste0(path, '/',  folders)) {
      cat('Renaming in:', i, '\n')
      rename_batch(i)
    }
    
  }    
}