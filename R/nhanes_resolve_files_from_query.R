#Wrapper that keeps the original interface. This will allow user to still pass tuberculosis (component) instead of TB (dataset_id)

#'@keywords internal #letting R know that this is a internal function that user do not need to deal with

resolve_files_from_query <- function(dataset, query, yr, map) {
  map <- load_nhanes_map()
  
  ids <- resolve_dataset_ids(dataset, query, map)
  
  if (length(ids) == 0) return(NULL)
  
  resolve_files(dataset, ids, yr, map)
}
