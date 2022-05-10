#' pull_reddit
#' @export pull_reddit
pull_reddit <- function(id, username, redpulFind, authorOrSubreddit) {
  ns <- NS(id)
  # browser()
  state <- get_redis_user_state(ns(username))

  redpulFind <- setDefault(state$redpulFind, "all")
  columns <- setDefault(state$columns, c("title"))
  wellPanel(
    div(
      selectizeInput(ns("redpulFind"), h4("Name"),
        selected = redpulFind, choices = redpulFind,
        options = list(create = TRUE), multiple = TRUE
      ),
      div(style = "flex-grow:1; text-align:right", actionButton(ns("findSubmit"), h4("Pull"), class = "btn-primary"))
    )
  )
}

#' pull_reddit_server
#' @export pull_reddit_server
pull_reddit_server <- function(input, output, session, user_name, classification) {
  observe({
    update_state(input, session$ns(user_name()))
  })

  observeEvent(input$findSubmit, {
    req(nchar(input$redpulFind[[1]]) > 0)
    prog_ind <- length(input$redpulFind)
    withProgress(message = glue::glue("Grabbing {classification}\n"), value = 0, {
      imap(
        input$redpulFind,
        function(x, y) {
          # browser()
          incProgress(1 / prog_ind, detail = glue::glue("Pulling {x}"))
          authorOrSubreddit <- if_else(classification == "author", TRUE, FALSE)
          resp <- response_to_robj("pullsub", list(subreddits = toJSON(x), author = authorOrSubreddit), drop_data = T)
          if (is.null(resp)) {
            showNotification(glue::glue("Failed to pull {x}"), type = "error")
          }
        }
      )
    })
  })
}
