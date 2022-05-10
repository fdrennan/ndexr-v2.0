#' submission_email_request
#' @export submission_email_request
submission_email_request <- function(..., query = NULL) {
  message <- jsonlite::toJSON(...)
  conn <- amqp_connect(host = Sys.getenv("RABBIT_HOST"))
  amqp_bind_queue(conn, "submission_request", "redpul", routing_key = "#")
  amqp_publish(conn, message, exchange = "redpul", routing_key = "#")
}

#' send_submission_email
#' @export send_submission_email
send_submission_email <- function() {
  conn <- amqp_connect(host = Sys.getenv("RABBIT_HOST"))
  while (length(resp <- amqp_get(conn, "submission_request")) > 0) {
    if (!exists("subdata")) {
      con <- postgres_connector()
      on.exit(dbDisconnect(con))
      cli_alert_info("Pulling recent submissions")
      subdata <- tbl(con, "submissions") %>%
        distinct() %>%
        collect()
    }
    resp <- fromJSON(rawToChar(resp$body))
    searchTerms <- resp$searchTerms
    cli_alert_info("Subsetting")
    subdata <- filter_submissions(subdata, search_terms = searchTerms) %>%
      head(20000)
    cli_alert_info("Emailing")
    send_email(resp$email, subdata, subject = glue("ndexr search"))
    cli_alert_success("Sent")
    subdata
  }
}
