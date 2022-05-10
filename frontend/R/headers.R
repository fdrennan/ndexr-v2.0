#' headers
#' @export
headers <- function() {
  sass(
    sass_file("www/styles.scss"),
    output = "www/styles.css"
  )

  theme <- ndexr_colors()

  mycss <- make_css(
    list(
      "body",
      c("color", "background", "font-size"),
      c(theme$ndexr$text, theme$ndexr$background, "1.4rem")
    ),
    list(
      ".background-primary", "background", theme$ndexr$background
    ),
    list(
      ".well",
      c("color", "background"),
      c(theme$ndexr$text, theme$ndexr$well)
    ),
    list(
      ".shiny-input-panel",
      c("color", "background"),
      c(theme$ndexr$text, theme$ndexr$well)
    ),
    list(".footer", c("color"), theme$ndexr$text),
    list("a", c("color", "text-decoration"), c(theme$ndexr$link, "none")),
    list(".btn", c("color", "background"), c(theme$ndexr$text, theme$ndexr$code)),
    list("ul", "background-color", theme$ndexr$code),
    list(".selected", "background-color", theme$ndexr$background),
    list("ul li", "color", theme$ndexr$text),
    list("a:visited a:hover a:active a:selected", c("color", "text-decoration"), c(theme$ndexr$text, "none")),
    list(".dataTable", c("background-color", "color"), c(theme$ndexr$well, theme$ndexr$text)),
    list("tr td", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(".form-control", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(".items", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(".item", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(".selectize-dropdown-content", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(".selectize-input.full", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(".option", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(" .tabbable > .nav > li > a", c("background-color", "color"), c(theme$ndexr$background, theme$ndexr$text)),
    list(" .tabbable > .nav > li[class=active] > a", c("background-color", "color"), c(theme$ndexr$well, theme$ndexr$text))
  )


  withTags(
    head(
      includeCSS("www/styles.css"),
      extendShinyjs(text = "shinyjs.reset_app = function() {history.go(0)}", functions = "reset_app"),
      useShinyjs(),
      style(mycss),
      link(rel = "icon", type = "image/png", href = "images/icons/dumpsterfire.jpg"),
      style(".shiny-output-error:after{contentsr: 'sorry, I guess I broke it.'; visibility: visible}"),
      style(".shiny-output-error{visibility: hidden}"),
      style(type = "text/css", "#statistics-current_plot.recalculating { opacity: 1; }"),
      script(
        src = 'https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p'
      )
    )
  )
}
