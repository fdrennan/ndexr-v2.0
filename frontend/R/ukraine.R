#' #' ukraine
#' #' @export ukraine
#' ukraine <- function(id = "ukraine") {
#'   ns <- NS(id)
#'   tagList(
#'     h3("Submissions mentioning City in Ukraine", class = "text-center"),
#'     wellPanel(
#'       selectizeInput(ns("city"), "City", selected = "all", choices = c(
#'         "kharkiv", "kyiv", "luhansk", "bucha", "donetsk", "kherson",
#'         "lviv", "mariupol", "sevastopol", "sumy", "bar", "ukrainsk",
#'         "vasylkiv"
#'       )),
#'       checkboxInput(ns("ignoreFilter"), "Don't filter on city, just show me most recent", value = FALSE),
#'       actionButton(ns("submitForm"), "Search")
#'     ),
#'     ndexrSpinner(plotOutput(ns("ukraine_global"))),
#'     ndexrSpinner(uiOutput(ns("ukraine_submission_ui")))
#'   )
#' }
#'
#' #' ukraine_server
#' #' @export ukraine_server
#' ukraine_server <- function(input, output, session) {
#'   ukpd <- eventReactive(input$submitForm, {
#'     ukpd <- make_ukraine_plot_data()
#'     ukpd
#'   })
#'
#'   output$ukraine_global <- renderPlot({
#'     ukpd <- ukpd()
#'     req(ukpd)
#'     if (!input$ignoreFilter) {
#'       ukpd <- filter(ukpd$data, word == input$city)
#'     } else {
#'       ukpd <- ukpd$data
#'     }
#'     ukpd %>%
#'       ggplot() +
#'       aes(x = hour, y = n) +
#'       geom_col() +
#'       scale_y_continuous(label = scales::comma) +
#'       facet_wrap(~word, scales = "free_y") +
#'       theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1))
#'   })
#'
#'   output$ukraine_submission_ui <- renderUI({
#'     df <- ukpd()$df
#'     if (!input$ignoreFilter) {
#'       df <-
#'         df %>%
#'         filter(word == input$city)
#'     }
#'
#'     df <-
#'       df %>%
#'       distinct() %>%
#'       split(1:nrow(.)) %>%
#'       map(
#'         function(x) {
#'           minutes_ago <-
#'             difftime(with_tz(Sys.time(), "UTC"), x$created_utc, units = "secs") %>%
#'             round(2)
#'
#'           div(
#'             hr(),
#'             a(href = x$url, h4(x$title, class = "text-left")),
#'             h5(glue::glue("minutes_ago, {seconds_ago}")),
#'             a(href = glue::glue("https://reddit.com/r/{x$subreddit}"), h4(x$subreddit, class = "text-left")),
#'             a(href = glue::glue("https://reddit.com/u/{x$author}"), h4(x$author, class = "text-left")),
#'             p(x$text, class = "text-left")
#'           )
#'         }
#'       )
#'   })
#' }
#'
#'
#' #' get_ukraine_data
#' #' @export get_ukraine_data
#' get_ukraine_data <- function() {
#'   data <- submission_search(
#'     search_terms = "ukraine",
#'     limit = 50000
#'   )
#'
#'   data <-
#'     data %>%
#'     distinct() %>%
#'     select(title, selftext, created_utc, id, url, subreddit, author) %>%
#'     arrange(desc(created_utc))
#'
#'   data
#' }
#'
#' #' get_ukraine_cities
#' #' @export get_ukraine_cities
#' get_ukraine_cities <- function() {
#'   ukraine_cities <-
#'     read_html("https://en.wikipedia.org/wiki/List_of_cities_in_Ukraine") %>%
#'     html_table() %>%
#'     .[[1]] %>%
#'     clean_names() %>%
#'     mutate(city_name = str_to_lower(city_name))
#' }
#'
#' #' make_ukraine_plot_data
#' #' @export make_ukraine_plot_data
#' make_ukraine_plot_data <- function(df = get_ukraine_data()) {
#'   df <-
#'     df %>%
#'     mutate(
#'       created_utc = as.POSIXct(created_utc, origin = "1970-01-01"),
#'       hour = floor_date(created_utc, "5 minutes"), text = selftext
#'     ) %>%
#'     unnest_tokens(word, selftext) %>%
#'     inner_join(get_ukraine_cities(), by = c("word" = "city_name"))
#'
#'
#'   data <-
#'     df %>%
#'     group_by(word) %>%
#'     mutate(total_count = n()) %>%
#'     group_by(hour, word, total_count) %>%
#'     count() %>%
#'     ungroup()
#'
#'   city_data <-
#'     data %>%
#'     distinct(word, total_count) %>%
#'     mutate(
#'       freq = total_count / sum(total_count),
#'       norm_freq = freq / max(freq)
#'     ) %>%
#'     arrange(desc(norm_freq))
#'
#'   data <- inner_join(data, city_data)
#'
#'   list(data = data, df = df)
#' }
