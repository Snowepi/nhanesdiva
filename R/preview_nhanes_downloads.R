#' Preview NHANES Files to Be Downloaded
#'
#' Generates a preview of NHANES datasets that match the specified
#' years, datasets, and components of the dataset without downloading any files.
#' This helps users inspect what data will be retrieved before
#' running a download operation, reducing unnecessary storage use.
#'
#' @param years Vector of survey years to search (e.g., c(2011, 2013)).
#'
#' @param datasets Character vector of NHANES dataset names to include in the 
#' search. This will be any of the four datasets: "demographics", "examination", 
#' "laboratory", or "questionnaire".
#'
#' @param components Character vector of NHANES components. The components can 
#' include the name of the component of the dataset such as 
#' "demographic_variables_sample_weights", "dietary_interview_individual_foods",
#' or it can also include the name of the dataset_id "DEMO" or "DRXIFF" 
#' respectively. However for some datasets using dataset_id may also result 
#' the list of dataset that contains that id as a part of its dataset_id. For 
#' example in the dataset examination, component 
#' spirometry_pre_and_post_bronchodilator has the dataset_id "SPX". Likewise 
#' in the same dataset, component spirometry_raw_curve_data had dataset_id 
#' "SPXRAW". So if users write "SPX" as component, list of data for "SPXRAW" 
#' will also be shown. In cases like this it is recommended to write the exact 
#' component name instead of dataset_id. 
#' 
#' Users can look at the names of the component or dataset_id by typing their 
#' desired search query in the nhanes_search to see the list of dataset, 
#' components, dataset_id. for their search term 
#' e.g nhanes_search("tuberculosis"), nhanes_search("dietary"), 
#' nhanes_search("spirometry"). 
#'
#' @return A data frame listing matching NHANES files and associated metadata.
#' If no matches are found, an empty data frame is returned.
#'
#' @details
#' This function uses the internal NHANES mapping table to resolve dataset 
#' availability across survey cycles. It does not perform any downloads or 
#' external requests.
#'
#' @examples
#' # Example 1. Preview dataset that have dataset_id "DEMO" within the
#' # demographics dataset for year 2011 and 2013
#' preview_nhanes_downloads(
#'   years = c(2011, 2013),
#'   datasets = "demographics",
#'   components = "DEMO" 
#' )
#' \donttest{
#' # Example 2. Preview dataset that have component name 
#' # "cardiovascular_fitness", and "cadmium_lead_total_mercury_blood"
#' # within dataset examination and laboratory for the years 1999, 2001 and 2017
#' preview_nhanes_downloads(
#'   years = c(1999, 2001, 2017),
#'   datasets = c("examination", "laboratory"),
#'  components = c("cardiovascular_fitness", "cadmium_lead_total_mercury_blood")
#' )
#' 
#' # Example 3. The above input can alternatively written using the dataset_id 
#' # in the component section as follows using CVX which is the dataset_id for 
#' # cardivascular_fitness and PBCD which is dataset_id for 
#' # cadmium_lead_total_mercury_blood. The names of the dataset_id and the 
#' # components can be found using \code{search_nhanes()}
#' preview_nhanes_downloads(
#'   years = c(1999:2002, 2017),
#'   datasets = c("examination", "laboratory"),
#'   components = c("CVX", "PBCD")
#' )
#' }
#'
#' @export


preview_nhanes_downloads <- function(years, datasets, components) {
  map <- load_nhanes_map()

  out <- list()

  for (yr in years) {
    for (ds in datasets) {
      for (comp in components) {

        files <- resolve_files_from_query(ds, comp, yr, map)

        if (!is.null(files)) {
          out[[length(out) + 1]] <- data.frame(
            Year = yr,
            files,
            row.names = NULL
          )
        }
      }
    }
  }
  
  if (length(out) == 0) {
    return(data.frame())
  }

result<- do.call(rbind, out)
#we dont want the row names, as the row number from the main map file is of no use to users, rather confusing
rownames(result) <- NULL

# Rename columns
colnames(result) <- c("Year", "Cycle", "Dataset", "File_code", "Component", "Dataset_id", "Start year", "End year")

#remove unwanted variables: the output is messy with lots of repeating information. So I dont want the start year and end year to show
result$"Start year"<- NULL
result$"End year" <- NULL


return(result)
 }