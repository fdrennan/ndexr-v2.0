#' plot_subreddit_timeseries
#' @param hours_ago Max number of hours from present time to display
#' @param split_explicit Specify if obs are explicit or not
#' @param subreddit_name Name of subreddit to filter on
#' @param trunc_time Floor of time
#' @importFrom dplyr mutate filter group_by summarise tbl `%>%` collect
#' @importFrom purrr map
#' @importFrom xts xts
#' @importFrom dygraphs dygraph
#' @importFrom DBI dbDisconnect
#' @export plot_subreddit_timeseries
plot_subreddit_timeseries <- function(hours_ago = 24, subreddit_names,
                                      split_explicit = TRUE,
                                      trunc_time = "minutes", table = "submissions") {
  con <- postgres_connector()

  on.exit({
    message("Removing connection to Postgres")
    dbDisconnect(conn = con)
  })

  data <- tbl(con, table) %>%
    mutate(time = date_trunc(trunc_time, to_timestamp(created))) %>%
    filter(time >= local(Sys.time() - 60 * 60 * hours_ago))

  if (!is.na(subreddit_names) & (!subreddit_names == "all")) {
    data <- data %>%
      filter(subreddit %in% subreddit_names)
  }

  if (split_explicit) {
    data <-
      data %>%
      mutate(explicit = if_else(over_18, "explicit", "unknown")) %>%
      group_by(time, explicit)
  } else {
    data <-
      data %>%
      group_by(time)
  }
  data <-
    data %>%
    summarise(n_obs = as.numeric(n()), .groups = "drop") %>%
    collect()

  data
}
