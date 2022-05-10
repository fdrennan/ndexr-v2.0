
#' data_search
#' @param id A namespace id, shared with a server - data_search_server
#' @param username The username of the customer
#' @description data_search
#' @export data_search
data_search <- function(id = "search", username, is_admin) {
  ns <- NS(id)
  fluidRow(
    column(
      5,
      fluidRow(
        column(
          6,
          header_main("Subreddit"),
          pull_reddit("pull_reddit", username, "all", "subreddit"),
          header_main("Author"),
          pull_reddit("pull_reddit_author", username, "AutoModerator", "author")
        ),
        column(
          6,
          query_generator("query_generator", username, is_admin),
          ndexrSpinner(uiOutput(ns("queryPanel")))
        )
      )
    ),
    column(
      7,
      div(
        header_main("Output"),
        tabsetPanel(
          # tabPanel("Filters", ),
          tabPanel("Summary", ndexrSpinner(summary_ui("summary_ui"))),
          tabPanel("Shared", ndexrSpinner(url_ui("url"))),
          tabPanel("Recent", browse_ui("browse_ui")),
          # tabPanel("Table", ndexrSpinner(table_ui("table_ui"))),
          tabPanel("Domains", ndexrSpinner(domain_ui("domain_ui"))),
          tabPanel("Table", DT::DTOutput(ns("table")))
          # tabPanel("All Domains", all_domains("all_domains"))
        )
      )
    )
  )
}


#' data_search_server
#' @export
data_search_server <- function(input, output, session, userSettings, query_results, user_name) {
  # Making data, or downloading.
  observe({
    update_state(input, session$ns(user_name()))
  })

  output$queryPanel <- renderUI({
    ns <- session$ns
    data <- query_results()
    timeZone <- userSettings$timeZone
    min_date <- min(data$created_utc) %>% as.Date() - 1
    max_date <- max(data$created_utc) %>% as.Date() + 1
    # browser()
    div(
      class = "text-left",
      wellPanel(
        div(h3("Filters"), class = "text-center"),
        div(
          # class = "flex-start",
          dateRangeInput(
            ns("daterange"),
            label = "Dates", start = min_date, end = max_date, min = min_date, max = max_date
          )
          # selectizeInput(ns("querySearchTerms"), div(h4("Terms Searched")),
          #                selected = data$params$params$searchTerms, multiple = TRUE,
          #                choices = data$params$params$searchTerms
          # )
        ),
        em(glue::glue("Updated at {with_tz(Sys.time(), timeZone)}"))
        # timeInput(ns("time1"), "Time:"),
        # timeInput(ns("time2"), "Time:", value = Sys.time()),
        # div(class = "text-right", actionButton(ns("submit"), "Submit"))
      )
    )
  })


  filtered_query <- reactive({
    req(input$daterange)
    data <- query_results()
    # browser()
    # strip_time <- function(x) {
    #   format(as.POSIXct(x, format = "%Y-%m-%d %H:%M:%S"), format = "%H:%M:%S") %>%
    #     hms() %>%
    #     as.numeric()
    # }
    # browser()
    data <-
      data %>%
      filter(
        between(created_utc, as.POSIXct(input$daterange[[1]]), as.POSIXct(input$daterange[[2]]))
        # between(strip_time(data$created_utc), strip_time(input$time1), strip_time(input$time2))
      )
    # data
    # browser()
    showNotification("Data updated", duration = 5)


    data
  })

  output$table <- renderDT(server = TRUE, {
    data <- filtered_query() %>%
      arrange(desc(created_utc)) %>%
      select(author, subreddit, created_utc, title, domain) %>%
      mutate(author = as.factor(author), subreddit = as.factor(subreddit), domain = as.factor(domain))
    DT::datatable(
      data,
      class = "text-left",
      filter = list(position = "top", clear = FALSE),
      options = list(autoWidth = TRUE)
    )
  })

  filtered_query
}
