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

load_dot_env(file = ".env")

repeat {
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  state <- redisGet("fdrennan")
  subredditNames <- setDefault(state$subredditNames, "all")
  pullLoopSleep <- setDefault(state$pullLoopSleep, 5)
  cli_alert_info("Sleeping for {pullLoopSleep} seconds")
  Sys.sleep(pullLoopSleep)
  trollFound <- setDefault(state$trollFound, FALSE)
  over18 <- setDefault(state$over18, FALSE)

  redisClose()
  print(toJSON(state, pretty = TRUE))
  con <- postgres_connector()
  if (!dbExistsTable(con, "submissions")) {
    submissions_sql <- read_file("sql/submissions.sql")
    cli_alert_info("Creating Submissions Table")
    dbExecute(con, submissions_sql)
  }
  cli_alert_info("Pulling latest 100 submissions.")
  last_100_submissions <- redpul_find(subredditNames)
  glimpse(last_100_submissions)
  if (!over18) {
    last_100_submissions <-
      last_100_submissions %>%
      filter(!over_18)
  }
  dbxUpsert(con, "submissions", last_100_submissions, where_cols = "id")
  if (trollFound) {
    subreddits <- unique(last_100_submissions$subreddit)
    subreddits <- redpul_find(subreddits)
    if (!over18) {
      subreddits <-
        subreddits %>%
        filter(!over18)
    }
    dbxUpsert(con, "submissions", subreddits, where_cols = "id")
  } else {
    message("Skipping swarm")
  }
  dbDisconnect(con)
}
