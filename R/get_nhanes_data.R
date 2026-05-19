# MAIN FUNCTION: It has two parts. 
# get_nhanes_data downloads and reads the NHANES data for selected cycles and 
# datasets. It then stores them in a list
#' Download NHANES Data
#'
#' Downloads NHANES datasets matching specified years, datasets, and components.
#'
#' It is recommended to use \code{preview_nhanes()} first to inspect available
#' files before downloading.
#'
#' @param years Vector of survey years (e.g., 2011, c(2011, 2013)).
#' @param datasets Character vector of NHANES dataset categories
#'   ("demographics", "examination", "laboratory", "questionnaire").
#' @param components Character vector of dataset components or dataset IDs
#'   (e.g., "DEMO", "PBCD", or specific component names like 
#'   "demographic_variables_sample_weights"). The components can include the 
#'   name of the component of the dataset such as 
#'   "demographic_variables_sample_weights", "dietary_interview_individual_foods", 
#'   or it can also include the name of the dataset_id "DEMO" or "DRXIFF" 
#'   respectively. However for some datasets using dataset_id may also result 
#'   the list of dataset that contains that id as a part of its dataset_id. 
#'   For example in the dataset examination, 
#'   component spirometry_pre_and_post_bronchodilator has the dataset_id "SPX". 
#'   Likewise in the same dataset, component spirometry_raw_curve_data has 
#'   dataset_id "SPXRAW". So if users write "SPX" as component, data for 
#'   "SPXRAW" will also be downloaded. In cases like this it is recommended 
#'   to write the exact component name instead of dataset_id.
#' 
#'  Users are encouraged to use \code{preview_nhanes_downloads()} to review the 
#'  list of data that they are about to download. 
#' @param base_dir Directory where downloaded NHANES .XPT files will be saved.
#' By default, base_dir = NULL and the data files are downloaded to a temporary 
#' directory in a subfolder named 'NHANES_data' (within tempdir()). Files 
#' stored in the temporary directory may be removed when the R session ends. 
#' Users may optionally specify base_dir to control where files are saved. 
#'
#' @return Downloads NHANES .XPT files to a local folder.
#' If no matches are found, no files are downloaded and an empty result is 
#' returned.
#'
#' @details
#' This function retrieves NHANES data from official NHANES sources based on
#' user-specified filters. Internet access is required.
#'
#' Users can explore available datasets and components using:
#' \code{nhanes_search("keyword")}. 
#'
#' If files are downloaded multiple times with the same parameters,
#' existing files in the base_dir will be overwritten.
#'
#' Users may also assign the output of \code{get_nhanes_data()} to an object,
#' for example:
#' data_list <- get_nhanes_data(years = 1999,
#' datasets = "demographics", components = "DEMO").
#' This allows the downloaded file paths to be comined together to inspect the 
#' list of downloaded data.
#'
#' Downloaded datasets can be combined or merged based on the needs of the 
#' analysis. Users should ensure appropriate alignment of identifiers and 
#' variables before combining datasets.
#'
#' @examples
#' \donttest{
#' # Example 1. Download data of one component from one dataset of one cycle
#' #in a default temporary directory in a subfolder named "NHANES_data"
#' get_nhanes_data(
#'   years = 2011,
#'   datasets = "demographics",
#'   components = "DEMO",
#'   base_dir = NULL 
#' )
#' # Example 2. Download data of one component from one dataset of one cycle
#' #in a user defined directory
#' get_nhanes_data(
#'   years = 2011,
#'   datasets = "demographics",
#'   components = "DEMO",
#'   base_dir = "userdefined directory"
#' )
#' # Example 2. Download data from multiple components from multiple
#' # datasets and cycles in the default NHANES_data folder in temporary 
#' # directory
#' get_nhanes_data(
#'   years = c(1999, 2001, 2017),
#'   datasets = c("examination", "laboratory"),
#'   components = c("cardiovascular_fitness", "cadmium_lead_total_mercury_blood")
#' )
#' # Example 3. The above input can alternatively written using the dataset_id 
#' # in the component section as follows
#' get_nhanes_data(
#'   years = c(1999:2002, 2017),
#'   datasets = c("examination", "laboratory"),
#'   components = c("CVX", "PBCD")
#' )
#' }
#' @export

get_nhanes_data <- function(years, datasets, components, base_dir = NULL) {
  
  # DEFAULT directory if user does not specify, NHANES_data folder in tempdir
  if (is.null(base_dir)) {
    base_dir <- file.path(tempdir(), "NHANES_data")
  }
  
  # create directory if user specifies their own directory
  if (!dir.exists(base_dir)) {
    dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  map <- load_nhanes_map()
  
  results <- list()
  
  for (yr in years) {
    
    for (ds in datasets) {
      
      for (comp in components) {
        
        files <- resolve_files_from_query(ds, comp, yr, map)
        
        if (is.null(files) || nrow(files) == 0) next
        
        for (i in seq_len(nrow(files))) {
          
          row <- files[i, ]
          
          file_code  <- row$file_code
          dataset_id <- row$dataset_id
          
          dir_path <- file.path(base_dir, dataset_id, as.character(yr))
          dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
          
          dest <- file.path(dir_path, paste0(file_code, ".XPT"))
          
          success <- download_nhanes_file(yr, file_code, dest)

          if (success) {
            results[[length(results) + 1]] <- dest
          }
        }
      }
    }
  }
  results
}