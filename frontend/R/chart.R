
## chart module ----------------------------------------------------------------
#' chartUI
#' @export chartUI
chartUI <- function(id) {
  ns <- NS(id)
  plotOutput(ns("distPlot"))
}

#' chartModule
#' @export chartModule
chartModule <- function(input, output, session, setup, user_name) {
  output$distPlot <- renderPlot({
    req(setup$bins)
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = setup$bins + 1)
    hist(x,
      breaks = bins,
      col = "darkgray",
      border = "white"
    )
  })
}
