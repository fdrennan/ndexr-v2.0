#' grab_and_store
#' @export grab_and_store
grab_and_store <- function(x, author = FALSE, tablename = "submissions") {
  subreddit_vecs <- split(x, ceiling(seq_along(x) / 10))

  data <- map(
    subreddit_vecs, function(x) {
      data <- try(redpul_find(x, author))
      if (inherits(data, "try-error")) {
        return()
      }
      con <- postgres_connector()
      on.exit(dbDisconnect(con))
      dbxUpsert(con, tablename, data, where_cols = "id", skip_existing = TRUE)
      data
    }
  )

  data

  data <- bind_rows(data)
}
