library(dplyr)
library(redpul)
library(purrr)
library(RPostgres)
library(DBI)
library(readr)
library(dbx)
library(dotenv)
library(dbplyr)
library(cli)
library(rredis)
library(state)
library(tictoc)

load_dot_env(file = ".env")

# conn <- amqp_connect(host = Sys.getenv("RABBIT_HOST"))
# amqp_declare_exchange(conn, "redpul", type = "fanout")
# amqp_declare_queue(conn, "submission_request")
# amqp_bind_queue(conn, "submission_request", "redpul", routing_key = "#")

repeat {
  con <- postgres_connector()
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  redisUser <- "fdrennan"
  state <- redisGet(redisUser)
  pulseSleep <- setDefault(state$pulseSleep, 5)
  cli_alert_info("Sleeping for {pulseSleep} seconds")
  Sys.sleep(pulseSleep)
  refreshStatistics <- setDefault(state$refreshStatistics, TRUE)
  dumpSubmissions <- setDefault(state$dumpSubmissions, FALSE)
  deleteTime <- setDefault(state$deleteTime, 1e9)
  submissionsTotalObserved <- setDefault(state$submissionsTotalObserved, 0)

  # cli_alert_info("Checking if emails need to be sent")
  # send_submission_email()
  redisClose()
  if (refreshStatistics) {
    cli_alert_info("Refreshing materialized view")
    tic()
    dbExecute(con, "refresh materialized view statistics;")
    toc()
    tic()
    dbExecute(con, "refresh materialized view submission_lookup;")
    toc()
  }

  if (dumpSubmissions) {
    response <- response_to_robj(glue("delete?delete_time={deleteTime}"))
    submissionsTotalObserved <- submissionsTotalObserved + response$data
    update_state(
      list(submissionsTotalObserved = submissionsTotalObserved),
      redisUser
    )
    cli_alert_info("{submissionsTotalObserved} observations counted")
  }

  dbDisconnect(con)
}
