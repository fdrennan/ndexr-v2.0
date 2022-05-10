#' query_generator
#' @export query_generator
query_generator <- function(id, username, is_admin) {
  ns <- NS(id)
  state <- get_redis_user_state(ns(username))
  searchTerms <- setDefault(state$searchTerms, "nato")
  columns <- setDefault(state$columns, "title")
  div(
    header_main("Build a Query"),
    wellPanel(
      div(
        selectizeInput(ns("searchTerms"), h4("Search"),
          selected = searchTerms, choices = searchTerms,
          options = list(create = TRUE), multiple = TRUE
        ),
        selectizeInput(ns("columns"), h4("Columns"),
          selected = columns, multiple = TRUE,
          choices = c("title", "selftext", "url", "subreddit", "author")
        ),
        selectizeInput(ns("searchHistorical"), h4("Table"),
          selected = "current", multiple = FALSE,
          choices = if (is_admin) c("submissions", "submissions_history") else "submissions"
        )
      ),
      div(
        class = "flex-between",
        downloadLink(ns("dbSearch"), h3("Download")),
        actionButton(ns("searchSubmit"), h4("Search"),
          class = "btn-primary"
        )
      )
    )
  )
}

#' query_generator_server
#' @export
query_generator_server <- function(input, output, session, userSettings, user_name) {
  observe({
    update_state(input, session$ns(user_name()))
  })

  searched_data <- eventReactive(input$searchSubmit, {
    req(length(input$searchTerms) > 0)
    data <- tryCatch(
      {
        data <-
          response_to_robj(
            "subreddit",
            query = list(
              search_terms = toJSON(input$searchTerms),
              search_cols = toJSON(input$columns),
              table = input$searchHistorical,
              limit = 200000
            ), drop_data = T
          )

        data <-
          data %>%
          as_tibble() %>%
          mutate(created_utc = with_tz(created_utc, userSettings$timeZone)) %>%
          arrange(desc(created_utc))
        data
      },
      error = function(err) {
        showNotification(glue::glue("Oops, something went wrong in pulling data from api"), type = "error")
      }
    )
    # browser()
    data$params <- list(params = reactiveValuesToList(input))
    data
  })

  output$dbSearch <- downloadHandler(
    filename = function() {
      paste("data-", as.integer(Sys.time()), ".csv", ssrep = "")
    },
    content = function(con) {
      write.csv(searched_data(), con)
    }
  )
  searched_data
}
