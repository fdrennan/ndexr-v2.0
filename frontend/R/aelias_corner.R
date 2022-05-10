#' aelias_corner
#' @export
aelias_corner <- function(id) {
  fluidRow(
    column(6,
      offset = 2,
      p("I want to write aelia and daddy's name"),
      p("aelia and daddy"),
      p("where's is d?"),
      p("d"),
      p(";loiuy uiop[]"),
      div(class = "flex-center", tags$image(src = "images/aelia/owl.png"))
    )
  )
}
