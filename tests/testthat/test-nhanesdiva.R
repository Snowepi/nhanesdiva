test_that("nhanes_search returns results for valid query", {
  res <- search_nhanes("diabetes")
  expect_true(nrow(res) > 0)
})

test_that("nhanes_search returns empty for nonsense query", {
  res <- search_nhanes("asdlkfjasldkfj")
  expect_true(is.null(res), 0)
})

test_that("nhanes_search returns empty for numeric query", {
  res <- search_nhanes(2000)
  expect_true(is.null(res), 0)
})


test_that("download works when online", {
  skip_on_cran()
  skip_if_offline()
  
  temp <- withr::local_tempdir()
  
  res <- get_nhanes_data(
    years = 1999, 
    datasets = "demographics", 
    components = "DEMO",
    path = temp)
  
  expect_type(res, "character")
  expect_true(file.exists(res))
})

test_that("download fails if there is no internet", {
  skip_on_cran()
  skip_if(curl::has_internet())
  
  expect_error(
    get_nhanes_data(years = 1999, datasets = "demographics", components = "DEMO"),
    "No internet connection"
  )
})
