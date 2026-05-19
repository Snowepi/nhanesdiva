#to load the map
#'@keywords internal 

load_nhanes_map <- local({
  
  map_cache <- NULL
  
  function() {
    if (!is.null(map_cache)) return(map_cache) #caching the map file so that it does not load every time
    
    path <- system.file("extdata", "nhanes_map.rds", package = "nhanesdiva") 
    
    if (path == "") {
      stop("NHANES map file not found.", call. = FALSE)
    }
    
    map_cache <<- readRDS(path)
    map_cache
  }
})

