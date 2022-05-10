library(shiny)
library(dotenv)
library(sass)
library()
#' body_ui
#' @export
main_ui <- function (id)
{
  ns <- NS(id)
  header <- ns('ui')
  div(
    h3(header),
    uiOutput(ns("main"))
  )
}

#' body_server
#' @export
main_server <- function (input, output, session)
{
  ns <- session$ns
  output$main <- renderUI({
    header <- ns('server')
    h3(header)
  })
}

#' @export
ui <- function(incoming) {
  main_ui('main')
}

#' server
#' @export
server <- function(input, output) {
  callModule(main_server, 'main')
}


shinyApp(ui = ui, server = server)
