#' user_course
#' @export
user_course <- function(id, user) {
  ns <- NS(id)
  state <- get_redis_user_state(ns(user))
  section <- setDefault(state, "introduction")
  fluidRow(
    column(
      3, div(
        uiOutput(ns("currentTime")),
        selectizeInput(ns("section"), h4("Go To"),
          selected = section, choices = c("Introduction", "Chapter 1")
        )
      )
    ),
    column(
      9,
      uiOutput(ns("courseSection"))
    )
  )
}

#' user_course
#' @export
user_course_server <- function(input, output, session, user_name, userSettings) {
  observe({
    ns <- session$ns
    update_state(input, ns(user_name()))
  })

  output$courseSection <- renderUI({
    req(input$section)
    switch(input$section,
      "Introduction" = about_ui("about"),
      div(header_main("under construction"), )
    )
  })

  output$currentTime <- renderUI({
    invalidateLater(1000)
    pp(with_tz(Sys.time(), userSettings$timeZone))
  })
}
