#' geo
#' @export geo
geo <- function(id, user) {
  ns <- NS(id)
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  state <- redisGet(user)
  qGeo <- setDefault(state$qGeo, "Brazoria")
  countryGeo <- setDefault(state$countryGeo, "")
  redisClose()

  fluidRow(
    textInput(ns("qGeo"), "Query", qGeo),
    textInput(ns("countryGeo"), "Country", countryGeo),
    actionButton(ns("submit"), "Submit"),
    tableOutput(ns("response"))
  )
}

#' geo_server
#' @export geo_server
geo_server <- function(input, output, session, user_name) {
  observeEvent(input$submit, {
    update_state(input, user_name())
  })

  data <- eventReactive(input$submit, {
    qGeo <- str_replace_all(input$qGeo, " ", "+")
    countryGeo <- input$countryGeo
    response <- response_to_robj(glue::glue("geonames?q={qGeo}&country={countryGeo}"))
    response$data
  })

  output$response <- renderTable(data())
}
