library(httr)
library(jsonlite)

#' response_to_robj
#' @param url
#' @export response_to_robj
response_to_robj <- function(url) {
  response <- GET(url)
  response <- fromJSON(content(response, "text", encoding = "UTF-8"))
  response
}

data <- response_to_robj("localhost:8000/plot")
