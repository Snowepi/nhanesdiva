#Download related helper function like URL Builder
#' @keywords internal #this should start with #'

get_nhanes_url <- function(year, file_code) {
  
  if (!curl::has_internet()) {
    stop("No internet connection. Cannot reach NHANES website.", call. = FALSE)
  }
  
  paste0(
    "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/",
    year,
    "/DataFiles/",
    file_code, ".XPT"
  )
}

#Safe download
#' @keywords internal #this should start with #'

download_nhanes_file <- function(yr, file_code, dest) {
  
  url <- get_nhanes_url(year=yr, file_code = file_code)
  
  tryCatch({
    utils::download.file(url, dest, mode = "wb")
    TRUE
  }, warning = function(w) {
   warning("No files found.", call. = FALSE)
    FALSE
  }, error = function(e) {
    warning("No files found.", call. = FALSE)
    FALSE
  })
}


