#' Search NHANES Data Using Your Search Query
#'
#' Generates a list of all the NHANES datasets that match the your search term.
#'
#' This helps users to inspect what datasets are present in the NHANES data 
#' related to their search term.They can then use the result to identify the 
#' dataset that they want. Then using the search result users can pick the year,
#' dataset, component, or dataset_id of that particular data they want. These 
#' inputs will go into the preview function and the data download function.
#' @param query Any search term in text that the user wants information. There 
#' should be one search query at a time e.g "demographic", "weight", 
#' "spirometry". To get a list of all data available in a given publicly 
#' available dataset, user can search for the dataset name e.g. "demographics",
#' or "examination", or "laboratory" or "questionnaire".
#'
#' @return A data frame listing matching NHANES files and associated metadata. 
#' If no matches are found, user will get a message that "No matches found for:".
#'
#' @details
#' This function uses the internal NHANES mapping table to resolve
#' dataset availability across survey cycles. It does not perform any
#' downloads or external requests.
#'
#' @examples
#' # Example 1. Search for term demographic
#' search_nhanes("demographic")
#'  
#' # Example 2. Search for term spirometry
#' search_nhanes("spirometry")
#' \donttest{
#' # Example 3. Search for term tuberculosis
#' search_nhanes("tuberculosis")
#' 
#' # Example 4. Search for term blood_pressure
#' search_nhanes("blood_pressure")
#' 
#' # Example 5. Search for the whole list within the laboratory dataset
#' search_nhanes("laboratory") 
#' }
#' @export


search_nhanes <- function(query) {
  
  map <- load_nhanes_map()
  
  if (missing(query) || nchar(query) == 0) {
    stop("Please provide a search term.", call. = FALSE)
  }
  
  # search across relevant fields
  hits <- grepl(query, map$dataset, ignore.case = TRUE) |
    grepl(query, map$dataset_id, ignore.case = TRUE) |
    grepl(query, map$component, ignore.case = TRUE) |
    grepl(query, map$file_code, ignore.case = TRUE)
  
  res <- map[hits, ]
  
  if (nrow(res) == 0) {
    message("No matches found for:", query)
    return(invisible(NULL))
  }
  
  # collapse to dataset level
  summary <- stats::aggregate(
    cbind(start_year, end_year) ~ dataset + component + dataset_id + file_code,
    data = res,
    FUN = function(x) c(min = min(x), max = max(x))
  )
  
  # flatten columns
  summary$start_year <- summary$start_year[, "min"]
  summary$end_year   <- summary$end_year[, "max"]
  
  summary$years <- paste0(summary$start_year, "-", summary$end_year)
  
  summary <- summary[, c("dataset", "component", "dataset_id", "file_code", "start_year", "end_year", "years")]
  
  names(summary) <- c("Dataset", "Component", "Dataset_id", "File code", "Start Year", "End Year", "Cycle")
  
  return(summary)
}