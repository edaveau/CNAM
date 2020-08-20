pacman::p_load(data.table, stringr)

data_path <- "~/R/DataVisualisation"
setwd(data_path)

data_dirs <- list.dirs()
data_dirs <- data_dirs[grepl("Region", data_dirs)]
data_dirs <- strsplit(data_dirs, "[[:space:]]")

for(directory in data_dirs){
  
  dataset_list <- list.files(path = directory, full.names = TRUE)

  df <- lapply(dataset_list, fread, quote = "")
  df <- rbindlist(df, fill = TRUE)
  
  file_year <- as.character(str_extract_all(string = directory, pattern = "\\d+"))
  file_name <- paste0("data", file_year, ".csv")
  
  write.csv(x = df, file = file_name)
  
  rm(df)
  
}
