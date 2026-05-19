#' @title NHANES Data Search, Preview, and Download Tools
#'
#' @description
#' Search, preview, and download data from the National Health and 
#' Nutrition Examination Survey (NHANES) across survey cycles. The package 
#' provides functions to identify relevant datasets by keyword, inspect 
#' available .XPT files before downloading, and organize retrieved data locally.
#'
#' The package is designed to simplify working with NHANES by allowing users to:
#' \itemize{
#' \item Search datasets using keywords or dataset names and retrieve name of 
#' component and dataset_id across cycles using \code{search_nhanes()}. E.g 
#' search_nhanes("alcohol") will generate a list of datasets, component, 
#' dataset_id, file code, start year, end year and cycle for all the data that 
#' have alcohol in their component name. User can note the component name or 
#' dataset_id that can be passed to the \code{preview_nhanes_downloads()}
#' and \code{get_nhanes_data()}
#' \item Preview the list of data being downloaded before downloading using 
#' \code{preview_nhanes_downloads()}. E.g. preview_nhanes_data (
#' years = 2001:2005, datasets = "questionnaire", components = "ALQ") or 
#' preview_nhanes_data (years = 2001:2005, datasets = "questionnaire", 
#' components = "alcohol_use")
#' \item Retrieve dataset identifiers across survey cycles
#' \item Download .XPT data files and save them systematically locally using 
#' \code{get_nhanes_data()}. E.g. get_nhanes_data (years = 2001:2005, 
#' datasets = "questionnaire", components = "ALQ", base_dir = NULL) or 
#' get_nhanes_data (years = 2001:2005, datasets = "questionnaire", 
#' components = "alcohol_use"). 
#' Multiple datasets and components can also be passed. Example 
#' get_nhanes_data (years = 2001:2005, 
#' datasets = c("demographics", "questionnaire"), components = c("DEMO", ALQ"),
#' base_dir = "user defined directory")
#' }
#' By default, base_dir = NULL and the data files are downloaded to a temporary 
#' directory in a subfolder named 'NHANES_data' (within tempdir()). 
#' Users may optionally specify base_dir to control where files are saved.  
#' Users can choose to work with individual dataset or combine them as needed.
#'
#' @details
#' NHANES data are released in 2-year cycles and may vary in structure across 
#' years. This package does not enforce merging or harmonization, allowing 
#' researchers full flexibility in how datasets are used and combined.
#'
#' Data are sourced from the CDC NHANES website:
#' https://wwwn.cdc.gov/nchs/nhanes/
#'
#' @author
#' Sushma Dahal
#' 
#' @keywords internal
 "_PACKAGE"