#this function is to get the dataset_id for each file_code and component. Some that are overridden manually will be loaded later in overridden file

#'@keywords internal #letting R know that this is a internal function that user do not need to deal with

resolve_dataset_ids <- function(dataset, query, map, verbose=FALSE) { #adding verbose= False to not see the message but be still helpful if need to debug doing verbose=TRUE
  map <- load_nhanes_map()
  
  subset <- map[map$dataset == dataset, ] #this will prevent contamination across datasets e.g TB in examination vs questionnaire
  
  hits <- subset[
    grepl(query, subset$component, ignore.case = TRUE) |  #this is how the user input takes either component or the dataset_id
      grepl(query, subset$dataset_id, ignore.case = TRUE),
  ]
  
  ids <- unique(hits$dataset_id)
  
  if (length(ids) == 0) {
    if (verbose) {
    message("No dataset_id found for: ", query, call. = FALSE)
    }
    return(character(0))
  }
  
  if (length(ids) > 1) {
    message("Multiple dataset_ids found: ", paste(ids, collapse = ", "))
  }
  
  ids
}