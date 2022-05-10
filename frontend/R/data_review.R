#' data_review
#' @export data_review
data_review <- function(id = "data_review", username) {
  ns <- NS(id)
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  state <- redisGet(username)
  searchTerm <- setDefault(state$searchTerm, "")
  subredditTable <- setDefault(state$subredditTable, "")
  exclusionQuery <- setDefault(state$exclusionQuery, "all")
  limit <- setDefault(state$limit, 20)
  # invalidateReview <- setDefault(state$invalidateReview, 60)
  redisClose()

  fluidRow(
    column(
      10,
      offset = 1,
      wellPanel(
        selectizeInput(
          ns("subredditTable"), "Subreddit Name",
          choices = subredditTable,
          selected = subredditTable,
          options = list(create = TRUE), multiple = TRUE
        ),
        selectizeInput(ns("searchTerm"), "Search Term",
          choices = searchTerm,
          selected = searchTerm,
          options = list(create = TRUE), multiple = TRUE
        ),
        selectizeInput(ns("exclusionQuery"), "Exclusion",
          selected = exclusionQuery, choices = c("any", "all"),
          multiple = FALSE
        ),
        numericInput(ns("limit"), "Limit", value = limit),
        actionButton(ns("submit"), "Update Table", class = "bt"),
        downloadButton(ns("downloadData"), "Download")
      )
    ),
    uiOutput(ns("datareview"))
  )
}

#' data_review_server
#' @export data_review_server
data_review_server <- function(input, output, session, userSettings, user_name) {
  observeEvent(input$submit, {
    update_state(input, user_name())
  })

  dataSubset <- reactive({
    req(input$submit)
    searchTerm <- input$searchTerm
    subredditTable <- input$subredditTable
    exclusionQuery <- input$exclusionQuery
    con <- postgres_connector()
    on.exit(dbDisconnect(con))
    subreddits <- paste0("'%", subredditTable, "%'", collapse = ", ")
    searchTerm <- paste0("'%", searchTerm, "%'", collapse = ", ")
    limit <- input$limit
    data <-
      dbGetQuery(
        con,
        glue::glue("select * from submissions
                where subreddit ilike any (array[{subreddits}]) and
                selftext ilike {exclusionQuery} (array[{searchTerm}]) and
                title ilike {exclusionQuery} (array[{searchTerm}])
                order by created_utc desc
                limit {limit};")
      )
    data <-
      data %>%
      mutate(
        created_utc = as_datetime(
          created_utc,
          tz = "America/Denver"
        ),
        seconds_ago = Sys.time() - created_utc,
        created_utc = as.character(created_utc)
      )
  })

  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("redpul_export_", as.integer(Sys.time()), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(dataSubset(), file, row.names = FALSE)
    }
  )

  output$datareview <- renderUI({
    data <- dataSubset()
    data <- split(data, 1:nrow(data))
    fluidRow(
      class = "justify-content-center",
      map(data, function(x) {
        thumbnail <- x$thumbnail
        url <- x$url

        if (path_ext(url) %in% c("jpg", "gif", "png", "jpeg")) {
          url <-
            tags$a(href = x$url, tags$img(src = x$url, width = "100%"), target = "_blank")
        } else {
          url <- NULL
        }
        # column(3, url)
        #
        column(
          3,
          withTags(
            div(
              a(
                href = paste0("https://reddit.com", x$permalink),
                h5(class = "card-title", x$title),
                target = "_blank"
              ),
              a(
                href = paste0("https://reddit.com/r/", x$subreddit),
                paste0("r/", x$subreddit),
                target = "_blank"
              ),
              a(
                href = paste0("https://reddit.com/u/", x$author),
                paste0("u/", x$author),
                target = "_blank"
              ),
              url
            )
          )
        )
      })
    )
  })
}
