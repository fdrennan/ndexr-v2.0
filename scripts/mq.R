library(longears)
library(dplyr)
library(jsonlite)
library(purrr)

dotenv::load_dot_env()

submission_email_request <- function(email, query = NULL) {
  message <- list(email = email) %>% jsonlite::toJSON()
  conn <- amqp_connect(host = Sys.getenv("RABBIT_HOST"))
  amqp_declare_exchange(conn, "redpul", type = "fanout")
  amqp_declare_queue(conn, "submission_request")
  amqp_bind_queue(conn, "submission_request", "redpul", routing_key = "#")
  amqp_publish(conn, message, exchange = "redpul", routing_key = "#")
}

send_submission_email <- function() {
  conn <- amqp_connect(host = Sys.getenv("RABBIT_HOST"))
  i <- 0
  while (length(resp <- amqp_get(conn, "submission_request")) > 0) {
    a <- fromJSON(rawToChar(resp$body))
    print(a)
  }
}


walk(letters, submission_email_request)
send_submission_email()

# repeat {
#   Sys.sleep(3)
#   message("Restarting")
# browser()
# conn <- amqp_connect()
# while (length(resp <- amqp_get(conn, "my.queue1")) > 0) {
#   print(rawToChar(resp$body))
# }
#
# while (length(resp <- amqp_get(conn, "my.queue2")) > 0) {
#   print(rawToChar(resp$body))
# }
# }
