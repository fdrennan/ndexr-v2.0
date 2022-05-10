#' #' response_to_robj
#' #' @param url The location of the api endpoint, excluding host and port
#' #' @import httr
#' #' @import jsonlite
#' #' @export response_to_robj
#' response_to_robj <- function(url) {
#'   host <- Sys.getenv("API_HOST")
#'   port <- Sys.getenv("API_PORT")
#'   url <- paste0("http://", host, ":", port, "/", url)
#'   response <- GET(url)
#'   response <- fromJSON(content(response, "text", encoding = "UTF-8"))
#'   response
#' }


#' text_right
#' @export
text_right <- function(url, name) {
  a(href = url, name, class = "text-right", target = "_blank")
}
