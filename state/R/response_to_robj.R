#' response_to_robj
#' @param url The location of the api endpoint, excluding host and port
#' @import httr
#' @import jsonlite
#' @export
response_to_robj <- function(url, drop_data = FALSE, query = list(), fun = GET) {
  host <- Sys.getenv("API_HOST")
  port <- Sys.getenv("API_PORT")
  url <- paste0("http://", host, ":", port, "/api/", url)
  response <- fun(url, query = query)
  response <- fromJSON(content(response, "text", encoding = "UTF-8"))
  # print(response$message)
  if (hasName(response, "error")) stop(data$error)

  if (drop_data) {
    response <- response$data
  }

  response
}
