#' table_ui
#' @export
table_ui <- function(id) {
  ns <- NS(id)
  DT::DTOutput(ns("tableUI"))
}

#' table_ui_server
#' @export
table_ui_server <- function(input, output, session, userSettings, query_results) {
  # Table Tab ---------------------------------------------------------------
  output$tableUI <- DT::renderDT(server = TRUE, {
    df <- query_results() %>%
      transmute(
        title,
        author = as.factor(author),
        subreddit = as.factor(subreddit),
        domain = as.factor(domain),
        created_tz = as.POSIXct(created_utc, origin = "1970-01-01"),
        local_tz =
          as.character(
            with_tz(
              created_tz,
              userSettings$timeZone
            )
          ),
        selftext = selftext,
        url
      )
    # browser()
    dt <- DT::datatable(
      df,
      class = "text-left",
      filter = list(position = "top", clear = FALSE), options = list(autoWidth = TRUE)
    )
    dt
  })
}
