# === Targets -------------------------------------------------------------



# Source ------------------------------------------------------------------
lapply(dir('R', '*.R', full.names = TRUE), source)


tar_option_set(format = 'qs',
               workspace_on_error = TRUE)




# Variables ---------------------------------------------------------------




# Paths -------------------------------------------------------------------





# Targets: all ------------------------------------------------------------
# Automatically grab all the "targets_*" lists above
lapply(grep('targets', ls(), value = TRUE), get)

