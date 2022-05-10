#' backend
#' @export backend
backend <- function(id = "backend", username, is_admin) {
  if (!is_admin) {
    response <-
      return(div())
  }
  ns <- NS(id)
  browser()
  state <- get_redis_user_state(ns(username))

  subredditNames <- setDefault(state$subredditNames, "all")
  pullLoopSleep <- setDefault(state$pullLoopSleep, 0)
  trollFound <- setDefault(state$trollFound, FALSE)
  over18 <- setDefault(state$over18, TRUE)
  refreshStatistics <- setDefault(state$refreshStatistics, TRUE)
  dumpSubmissions <- setDefault(state$dumpSubmissions, FALSE)
  pulseSleep <- setDefault(state$pulseSleep, 5)

  div(
    tabsetPanel(
      id = "admin_tabs",
      tabPanel(
        h3("Submission Parameters"),
        fluidRow(
          column(
            6,
            submissionParametersUI(subredditNames, pullLoopSleep, trollFound, over18, ns)
          ), column(
            6,
            pulseUI(refreshStatistics, dumpSubmissions, pulseSleep, ns)
          )
        )
      ),
      tabPanel(
        h3("User Activity"),
        fluidRow(
          ndexrSpinner(plotlyOutput(ns("user_activity")))
        )
      )
    )
  )
}


#' backend_server
#' @export backend_server
backend_server <- function(input, output, session, userSettings, user_name) {
  ns <- session$ns
  user <- reactive({
    req(user_name())
  })

  observe({
    # browser()
    update_state(input, ns(user()))
  })


  observeEvent(input$deletedata, {
    backup()
    delete_submission()
  })

  observeEvent(input$backup, {
    backup()
  })

  output$user_activity <- renderPlotly({
    invalidateLater(60000, session)
    state <- get_redis_user_state(user())
    timeZone <- setDefault(state$timeZone, "UTC")
    data <- response_to_robj("user_activity", drop_data = T)

    data <- data %>%
      mutate(redis_timestamp = floor_date(ymd_hms(redis_timestamp), unit = "30 minutes"))

    p <-
      data %>%
      mutate(redis_timestamp = as.POSIXct(redis_timestamp, tz = "1970-01-01"))


    p$user <- p$user_name %>%
      strsplit("-") %>%
      map_chr(~ unlist(last(.)))

    p <-
      p %>%
      filter(!user %in% c("fdrennan", "a")) %>%
      ggplot() +
      aes(x = redis_timestamp, y = n_obs, colour = user) +
      geom_col(aes(fill = user)) +
      # facet_grid(user_name ~ ., scales = 'free_y') +
      scale_x_datetime(
        breaks = breaks_width("2 day"),
        labels = date_format(
          "%m-%d",
          tz = timeZone
        )
      )

    p <- p + theme_ndexr()

    ggplotly(p)
  })
}


submissionParametersUI <- function(subredditNames, pullLoopSleep, trollFound, over18, ns) {
  div(
    wellPanel(
      h3("Submissions"),
      textInput(
        ns("subredditNames"), h4("Subreddit"),
        value = subredditNames
      ),
      numericInput(
        ns("pullLoopSleep"), h4("Pull Sleep"),
        value = pullLoopSleep, min = 1, max = Inf
      ),
      checkboxInput(
        ns("trollFound"),
        h4("Pull Subreddits from r/all"),
        value = trollFound
      ),
      checkboxInput(
        ns("over18"),
        h4("Over 18"),
        value = over18
      ),
      actionButton(ns("backup"), h4("Backup submissions")),
      actionButton(ns("deletedata"), h4("Delete submissions and backup"))
    )
  )
}


pulseUI <- function(refreshStatistics, dumpSubmissions, pulseSleep, ns) {
  div(
    wellPanel(
      h3("Pulse"),
      checkboxInput(ns("refreshStatistics"), h4("Refresh Statistics"), value = refreshStatistics),
      checkboxInput(ns("dumpSubmissions"), h4("Dump Submissions"), value = dumpSubmissions),
      numericInput(ns("pulseSleep"), h4("Pulse Sleep"), value = pulseSleep),
      actionButton(ns("submit"), h4("Submit"), class = "bt")
    )
  )
}


#' MOVE_TO_PLUMBER
#' backup
#' @export backup
backup <- function() {
  withProgress(message = "Backing up submissions...", value = 0, {
    incProgress(.5)
    response_to_robj("delete")
    incProgress(.5)
  })
}

#' delete_submission
#' @export
delete_submission <- function() {
  withProgress(message = "Deleting submissions...", value = 0, {
    incProgress(.5)
    con <- postgres_connector()
    on.exit(dbDisconnect(con))
    dbExecute(con, "delete from submissions where true;")
    incProgress(.5)
  })
}
