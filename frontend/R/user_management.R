# #' user_management
#' @export
user_management <- function(id = "user_management") {
  ns <- NS(id)

  fluidRow(
    ndexrSpinner(uiOutput(ns("existingUsers")))
  )
}

#' user_management_server
#' @export
user_management_server <- function(input, output, session, user_name, is_admin) {
  user <- reactive({
    user_name()
  })

  observe({
    user <- user()
    ns <- session$ns
    # browser()
    req(input$usernamesSelector)
    # browser()
    input <- list(
      hit = input$hit
    )
    update_state(input, ns(user), exclude_names = "existingUsers")
  })

  user_data <- reactive({
    # browser()
    data <-
      get_users() %>%
      select(-name)
  })

  output$existingUsers <- renderUI({
    data <- user_data()
    # browser()
    ns <- session$ns
    usernames <- data$username


    fluidRow(
      column(
        8,
        offset = 2,
        fluidRow(
          column(4, offset = 2, div(class = "text-left", tableHTML(data, rownames = FALSE, collapse = "separate", spacing = "5px 2px")))
        )
      )
    )
    # tableHTML(data)
  })
}
