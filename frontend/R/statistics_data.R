
#' statistics_data
#' @export
statistics_data <- function(id, user) {
  ns <- NS(id)
  # state <- get_redis_user_state(ns(user))
  # timeZone <- setDefault(state$timeZone, "UTC")
  # emailMe <- setDefault(state$emailMe, TRUE)
  # current_time <- format(with_tz(Sys.time(), timeZone), "%a %b %d %H:%M:%S %Y")
  fluidRow(
    ndexrSpinner(uiOutput(ns("currentStatistics")))
  )
}

#' statistics_data_server
#' @export
statistics_data_server <- function(input, output, session, user_name) {
  observe({
    ns <- session$ns
    update_state(input, ns(user_name()))
  })

  output$currentStatistics <- renderUI({
    ns <- session$ns

    future_promise(
      {
        con <- postgres_connector()
        statistics <- collect(tbl(con, "statistics"))
      },
      future.seed = NULL
    ) %...>% (
      function(statistics) {
        subreddits <- get_stat(statistics, "n_subreddits")
        authors <- get_stat(statistics, "n_authors")
        submissions <- get_stat(statistics, "n_submissions")
        subreddits_all <- get_stat(statistics, "n_subreddits_all")
        authors_all <- get_stat(statistics, "n_authors_all")
        submissions_all <- get_stat(statistics, "n_submissions_all")

        fluidRow(
          column(
            6, wellPanel(
              div(
                class = "text-left",
                h3("table submissions"),
                div(
                  class = "flex-around",
                  format_statistic("Submissions", submissions),
                  format_statistic("Authors", authors),
                  format_statistic("Subreddits", subreddits)
                )
              )
            )
          ),
          column(
            6, wellPanel(
              div(
                class = "text-left",
                h3("table submissions_history"),
                div(
                  class = "flex-around",
                  format_statistic("Submissions", submissions_all),
                  format_statistic("Authors", authors_all),
                  format_statistic("Subreddits", subreddits_all)
                )
              )
            )
          )
        )
      })
  })



  return(input)
}

#' get_stat
#' @export get_stat
get_stat <- function(table, key) as.numeric(filter(table, name == key)$value)

#' format_statistic
#' @export format_statistic
format_statistic <- function(message, statistic) {
  statistic <- comma(statistic)
  h4(glue::glue("{message}: {statistic}"))
}
