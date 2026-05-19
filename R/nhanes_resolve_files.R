#resolve files using the dataset_id resolved from user input in above step and year

#'@keywords internal #letting R know that this is a internal function that user do not need to deal with

resolve_files <- function(dataset, dataset_ids, yr, map) {
  map <- load_nhanes_map()
  
  subset <- map[
    map$dataset == dataset &
      map$dataset_id %in% dataset_ids &
      map$start_year <= yr &
      map$end_year >= yr,
  ]
  
  if (nrow(subset) == 0) {
    warning("No files found for dataset_id: ",
            paste(dataset_ids, collapse = ", "), #warning if dataset_id exists but not for that year
            " in year: ", yr, call. = FALSE)
    return(NULL)
  }
  
  subset
}