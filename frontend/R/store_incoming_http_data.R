#' store_incoming_http_data
#' @export store_incoming_http_data
store_incoming_http_data <- function(incoming) {
  incoming_data <- as.list(incoming)
  HEADERS <- as.list(incoming_data$HEADERS)
  incoming_data <- purrr::keep(incoming_data, is.character)
  incoming_data$HEADERS <- NULL
  incoming_http <- imap_dfr(incoming_data, function(x, y) {
    names(y) <- x
    x
  })
  mongo_uri <- Sys.getenv("MONGO_URI")
  con <- mongolite::mongo(
    collection = "http_incoming", db = "redpul", url = mongo_uri
  )
  incoming_http$systime <- as.double(Sys.time())
  con$insert(incoming_http)
}
