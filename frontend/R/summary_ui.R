#' summary_ui
#' @export
summary_ui <- function(id) {
  ns <- NS(id)
  div(
    # useShinyjs(),
    div(
      ndexrSpinner(uiOutput(ns("summaryTab"))),
      ndexrSpinner(plotOutput(ns("searchPlot")))
    )
  )
}

#' summary_ui_server
#' @export
summary_ui_server <- function(input, output, session, query_results) {
  output$summaryTab <- renderUI({
    data <- query_results()
    ns <- session$ns
    n_subreddit <- n_distinct(data$subreddit)
    n_authors <- n_distinct(data$author)
    n_submission <- nrow(data)
    div(
      h3("Summary"),
      wellPanel(
        div(
          class = "flex-around",
          div(h3("Submissions"), p(n_submission)),
          div(h3("Authors"), p(n_authors)),
          div(
            h3("Subreddits"), p(n_subreddit)
          )
        )
      )
    )
  })

  # Graphics Tab ------------------------------------------------------------
  output$searchPlot <- renderPlot({
    data <- query_results()

    has_name <- imap_dfc(
      setNames(data$params[[1]]$searchTerms, data$params[[1]]$searchTerms),
      function(x, i) {
        out <- str_detect(
          data[[data$params[[1]]$columns]], x
        )
        names(out) <- paste0(i)
        out
      }
    )

    data <- bind_cols(data, has_name)

    p_data <-
      data %>%
      mutate(
        created_utc = floor_date(ymd_hms(created_utc, tz = "UTC"), unit = "2 hours")
      ) %>%
      pivot_longer(cols = names(has_name), names_to = "query", values_to = "value") %>%
      group_by_at(vars("created_utc", query)) %>%
      summarise_at(vars(value), sum) %>%
      group_by(created_utc) %>%
      mutate(ratio = value / sum(value)) %>%
      ungroup()

    p_data %>%
      ggplot() +
      aes(x = created_utc, y = value, fill = query) +
      geom_col() +
      # facet_grid(~ )
      theme_ndexr() +
      ggtitle(glue::glue("Search Results for {data$params[[1]]$columns}"))
  })
}
