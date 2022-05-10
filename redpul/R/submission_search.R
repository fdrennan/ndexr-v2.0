#' submission_search
#' @export submission_search
submission_search <- function(limit = 10,
                              arrange_by = c("subreddit"),
                              search_terms = c("ukraine"),
                              search_cols = c("title", "selftext"),
                              table = "submissions") {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))

  search_cols <- map_dfr(
    search_cols,
    function(x) {
      map_dfr(search_terms, function(y) {
        search_submission_column(
          column = x,
          search_terms = tolower(y),
          limit = limit,
          table = table
        )
      })
    }
  )

  search_cols <-
    search_cols %>%
    mutate(created_utc = as.POSIXct(created_utc, origin = "1970-01-01")) %>%
    distinct()
}
