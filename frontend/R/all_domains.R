#' all_domains
#' @export all_domains
all_domains <- function(id, user_name) {
  ns <- NS(id)
  tabPanel(
    "All Domains",
    # em("Query Search + Domain tab - scan url in Query for domains, new are added to `All Domains`"),
    ndexrSpinner(DT::DTOutput(ns("domainDataUI"))),
    div(
      class = "flex-end",
      actionButton(ns("refreshAllDomains"), h4("Refresh"))
    )
  )
}

#' all_domains_server
#' @export
all_domains_server <- function(input, output, session) {
  output$domainDataUI <- DT::renderDT({
    input$refreshAllDomains
    future_promise(
      {
        con <- postgres_connector()
        on.exit(dbDisconnect(con))
        domains <- tbl(con, "urls") %>%
          distinct() %>%
          collect() %>%
          mutate_all(as.factor)
        domains$url <- map_chr(domains$url, ~ as.character(a(href = glue::glue("https://{.}"), em(.), target = "_blank")))
        domains <- domains %>% select(url, contains("country"), everything())
      },
      future.seed = NULL
    ) %...>%
      (function(data) {
        DT::datatable(
          data,
          class = "text-left", escape = FALSE,
          filter = list(position = "top", clear = FALSE), options = list(autoWidth = TRUE)
        )
      })
  })
}
