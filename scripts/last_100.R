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
library(dplyr)
library(stringr)
library(ggplot2)

load_dot_env(file = ".env")

con <- postgres_connector()
cli_alert_info("Pulling latest 100 submissions.")

redpul::grab_and_store()

sbrdt <- subreddits$subreddit
sbrdt <- split(sbrdt, ceiling(seq_along(sbrdt) / 20))


walk(
  sample(sbrdt), function(x) {
    try(
      dbxUpsert(con, "submissions", redpul_find(x), where_cols = "id")
    )
    Sys.sleep(60)
  }
)
# last_100_submissions <- redpul_find(subreddits$subreddit)

dbDisconnect(con)
