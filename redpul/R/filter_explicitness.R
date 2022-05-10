
#' search_submission_column
#' @export search_submission_column
search_submission_column <- function(column = "title", search_terms, limit, table = "submissions") {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))

  submissions <- tbl(con, table) %>%
    arrange(desc(created_utc))

  for (query in search_terms) {
    submissions <-
      submissions %>%
      filter(
        str_detect(
          str_to_lower(.data[[column]]),
          local(query)
        )
      )
  }

  submissions <- head(submissions, limit)
  collect(submissions)
}

#' filter_submissions
#' @export filter_submissions
filter_submissions <- function(data, search_terms = c("ukraine")) {
  map_dfr(
    search_terms,
    function(st) {
      filter_criteria <- map_dfc(data, function(x) {
        str_detect(x, paste0(search_terms, collapse = "|"))
      }) %>% rowSums()

      data <- data[
        filter_criteria > 0,
      ]
      data$search_term <- st
      data
    }
  ) %>% distinct()
}

# library(redpul)
# params <- list(email = 'drennanfreddy@gmail.com', search_terms = c('amq', 'ukraine'))
# redpul::submission_email_request(params)
# redpul::send_submission_email()
#
