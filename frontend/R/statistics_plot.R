
#' statistics_plot
#' @export
statistics_plot <- function(id = "stats_plot", user, is_admin) {
  # browser()
  ns <- NS(id)
  state <- get_redis_user_state(ns(user))
  hoursAgo <- setDefault(state$hoursAgo, 48)
  dateUnit <- setDefault(state$dateUnit, "1 hour")
  dateUnitUnits <- c("10 min", "30 min", "1 hour", "3 hour", "6 hour")
  if (is_admin) {
    dateUnitUnits <- c(dateUnitUnits, "15 sec", "30 sec", "1 min", "5 min")
  }
  fluidRow(
    column(
      4,
      div(class = "text-center", h4("Plot Inputs")),
      wellPanel(
        selectizeInput(ns("hoursAgo"), label = "Hours Ago", choices = 1:(24 * 2), selected = hoursAgo),
        selectizeInput(
          ns("dateUnit"),
          label = "Unit",
          choices = dateUnitUnits,
          selected = dateUnit
        )
      )
    ),
    column(
      8,
      ndexrSpinner(plotOutput(ns("current_plot")))
    )
  )
}

#' statistics_plot_server
#' @export
statistics_plot_server <- function(input, output, session, user_name, userSettings) {
  observe({
    ns <- session$ns
    update_state(input, ns(user_name()))
  })

  iso <- reactive({
    invalidateLater(60000)
    req(input$hoursAgo)
    req(userSettings$timeZone)
    req(input$dateUnit)
    list(
      hoursAgo = input$hoursAgo,
      timeZone = userSettings$timeZone,
      dateUnit = input$dateUnit
    )
  })
  iso <- iso %>% debounce(3000)
  output$current_plot <- renderPlot({
    iso <- iso()
    hoursAgo <- iso$hoursAgo
    timeZone <- iso$timeZone
    dateUnit <- iso$dateUnit
    timeUnit <- "minutes"
    geomType <- "bar"
    breaksWidth <- "2 hour"
    breaksBin <- 24

    trunc_time <- strsplit(dateUnit, " ")[[1]][[2]]
    future_promise(
      {
        data <- response_to_robj(
          "plot",
          query = list(
            hours_ago = hoursAgo,
            subreddit_names = "[\"all\"]", trunc_time = trunc_time
          )
        )$data
      },
      future.seed = NULL
    ) %...>%
      (function(data) {
        # browser()
        data <- mutate(data, time = floor_date(ymd_hms(time), unit = dateUnit))
        p <- data %>% ggplot() +
          aes(x = time, y = n_obs) +
          geom_col()
        p <- p + scale_x_datetime(
          breaks = breaksWidth,
          labels = date_format("%H:%M", tz = timeZone)
        ) + ggtitle("Submissions collected in submissions table")
        p <- p + theme(
          axis.text.x = element_blank(), axis.ticks.x = element_blank(),
          axis.text.y = element_blank(), axis.ticks.y = element_blank()
        )

        p + theme_ndexr()
      })
  })
}
