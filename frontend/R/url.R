#' url_ui
#' @export url_ui
url_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("urlTable"))
}

#' url_ui_server
#' @export url_ui_server
url_ui_server <- function(input, output, session, query_results) {
  # URL Tab -----------------------------------------------------------------
  output$urlTable <- renderUI({
    data <- query_results()
    data <-
      data %>%
      group_by(url) %>%
      summarise(
        n_obs = n(), n_subreddit = n_distinct(subreddit),
        n_author = n_distinct(author),
        title = title[[1]]
      ) %>%
      arrange(desc(n_author)) %>%
      split(1:nrow(.)) %>%
      head(50)

    fluidRow(class = "flex-start", map(
      data, function(x) {
        column(4,
          class = "shadow p-3 mb-5 bg-white rounded",
          wellPanel(
            a(href = x$url, target = "_blank", h4(x$title, class = "text-left")),
            div(
              class = "flex-around",
              p(glue::glue("Observations {x$n_obs}")),
              p(glue::glue("Subreddits {x$n_subreddit}")),
              p(glue::glue("Authors {x$n_author}"))
            )
          )
        )
      }
    ))
  })
}
