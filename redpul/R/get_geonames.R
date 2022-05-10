#' get_geonames
#' @export get_geonames
get_geonames <- function(q, country = "") {
  data <- glue("https://www.geonames.org/search.html?q={q}&country={country}") %>%
    read_html() %>%
    html_table(convert = F) %>%
    .[[2]]

  names(data) <- to_snake_case(unlist(data[2, ]))
  data <- data[3:nrow(data), -1]
  data$id <- paste0(q, country, "_", seq(1, nrow(data)))
  data
}
