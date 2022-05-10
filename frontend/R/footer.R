#' footer
#' @export footer
footer <- function() {
  current_year <- year(Sys.Date()) %>% as.character()
  div(
    br(), # spooky things happen if removed
    div(
      class = "text-right",
      a(href = "https://www.linkedin.com/in/freddydrennan/", h5("Contact")),
      a(href = "https://calendly.com/fdren", h5("Schedule a Chat"))
    ),
    div(
      class = "flex-between",
      h6("ndexr: A real-time Reddit data processing engine"),
      h6(glue::glue("Copyright {current_year}"))
    )
  )
}
