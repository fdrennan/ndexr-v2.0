#' navbar
#' @export navbar
navbar <- function() {
  withTags(
    nav(
      ul(
        # li(a(href = "https://ndexr.com/book", h3("Book"))),
        # li(a(href = route_link("ukraine"), h3("Ukraine"))),
        # li(a(href = route_link("about"), h3("About"))),
        li(a(href = route_link("signup"), h3("Sign Up"))),
        li(a(href = route_link("/"), h3("Log In")))
      )
    )
  )
}
