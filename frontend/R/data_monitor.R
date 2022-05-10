#' data_monitor
#' @export data_monitor
data_monitor <- function(id, user) {
  ns <- NS(id)
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  state <- redisGet(user)
  timeUnit <- setDefault(state$timeUnit, "minutes")
  refreshMs <- setDefault(state$refreshMs, 10000)
  hoursAgo <- setDefault(state$hoursAgo, 5)
  geomType <- setDefault(state$geomType, "bar")
  breaksBin <- setDefault(state$breaksBin, 30)
  breaksWidth <- setDefault(state$breaksWidth, "min")
  redisClose()

  fluidRow(
    column(
      3,
      numericInput(
        ns("refreshMs"), "Plot Refresh",
        value = refreshMs, min = 0, max = Inf
      ),
      numericInput(
        ns("hoursAgo"), "Lookback (Hours)",
        value = hoursAgo, min = 1 / 30, max = 24 * 31 * 12
      ),
      selectizeInput(ns("timeUnit"), "Units",
        selected = timeUnit,
        choices = c("minutes", "seconds", "hours", "days")
      ),
      selectizeInput(
        ns("geomType"), "Plot Type",
        selected = geomType,
        choices = c("bar", "line")
      ),
      selectInput(
        ns("breaksWidth"), "Breaks Width",
        selected = breaksWidth,
        choices = c("sec", "min", "hour", "day", "week", "month", "year")
      ),
      numericInput(
        ns("breaksBin"), "Breaks Bin",
        value = breaksBin, min = 1, max = "100"
      )
    ),
    column(
      9,
      plotOutput(ns("plot"))
    ),
    column(
      12,
      actionButton(ns("submit"), "Submit", class = "bt btn-primary btn-block")
    )
  )
}

#' data_monitor_server
#' @export data_monitor_server
data_monitor_server <- function(input, output, session, moduleInputs, user_name) {
  observeEvent(input$submit, {
    update_state(input, user_name())
  })


  output$plot <- renderPlot({
    invalidateLater(input$refreshMs)
    input$submit

    build_ndexr_plot(
      hoursAgo = input$hoursAgo,
      timeUnit = input$timeUnit,
      geomType = input$geomType,
      timeZone = moduleInputs$timeZone,
      breaksWidth = input$breaksWidth,
      breaksBin = input$breaksBin
    )
  })
}
