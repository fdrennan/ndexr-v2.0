#' browse_ui
#' @export
browse_ui <- function(id) {
  ns <- NS(id)
  # browser(
  fluidRow(
    div(
      class = "flex-around",
      actionButton(ns("prev"), "prev"),
      actionButton(ns("next_pg"), "next")
    ),
    ndexrSpinner(uiOutput(ns("browseUI")))
  )
}

#' browse_ui_server
#' @export
browse_ui_server <- function(input, output, session, query_results) {
  run_it <- reactive({
    val <- input$next_pg - input$prev
    val
  })


  output$browseUI <- renderUI({
    data <- query_results()
    resp <- run_it() %>% as.numeric()
    # browser()
    ns <- session$ns

    if (nrow(data) < 6) {
      chunk <- 1:nrow(data)
    } else {
      chunk <- (1:6) + (6 * resp)
    }
    data <- data[chunk, ]
    data <- data %>% split(1:nrow(.))
    fluidRow(
      map(
        data,
        ~ display_submissions(., ns)
      )
    )
  })
}

#' display_submissions
#' @export
display_submissions <- function(x, ns) {
  time <- as.POSIXct(x$created_utc, origin = "1970-01-01")
  mins_ago <- as.character(round(difftime(Sys.time(), time, units = "mins"), 3))
  title <- stringr::str_remove(x$title, "<.*>")
  title <- trimws(title)
  permalink <- paste0("https://reddit.com", x$permalink)
  url_html <- if (str_detect(x$url, ".jpg")) {
    a(href = x$url, img(src = x$url, alt = "s", style = "width: 100%; z-index: 0;"))
  } else {
    div()
  }

  id <- x$id
  column(
    6,
    wellPanel(
      a(href = permalink, h4(x$title, class = "text-left")),
      div(
        class = "flex-between",
        div(
          a(href = paste0("https://reddit.com/u/", x$author), h5(glue::glue("u/{x$author}")))
        ),
        div(
          a(href = paste0("https://reddit.com/r/", x$subreddit), h5(glue::glue("r/{x$subreddit}")))
        )
      ),
      url_html,
      h5(glue::glue("{mins_ago} mins ago"))
    )
  )
}
