#' domain_ui
#' @export
domain_ui <- function(id) {
  ns <- NS(id)
  ndexrSpinner(DT::DTOutput(ns("domainUI")))
}

#' domain_server
#' @export
domain_server <- function(input, output, session, query_results) {
  output$domainUI <- DT::renderDT(server = TRUE, {
    data <- query_results()
    data <- url_parse(data$url)
    domains <- unique(data$domain)
    domains <- domains[str_detect(unique(domains), "\\.")]
    domains <- domains[!is.na(domains)]
    domains <- n_chunks(domains, floor(length(domains) / 20))
    len_dmns <- length(domains)
    withProgress(message = "Domain Lookup", value = 0, {
      domains <- imap(
        domains,
        function(dmn, n) {
          prog <- round(as.numeric(n) / len_dmns * 100, 0)
          # prog <- glue::glue('{val}%')
          data <-
            response_to_robj("urllookup",
              drop_data = T,
              query = list(urlvec = toJSON(dmn)),
              fun = POST
            )
          incProgress(1 / len_dmns, detail = glue::glue("{prog}%"))
          data
        }
      )
    })


    domains <- bind_rows(domains)
    domains <-
      domains %>%
      mutate_all(as.factor)

    domains$url <- map_chr(domains$url, ~ as.character(a(href = glue::glue("https://{.}"), em(.), target = "_blank")))
    domains <- domains %>% select(url, contains("country"), everything())
    domains <- DT::datatable(
      domains,
      class = "text-left", escape = FALSE,
      filter = list(position = "top", clear = FALSE)
    )
  })
}
