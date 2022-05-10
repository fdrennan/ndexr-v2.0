#' about_ui
#' @export
about_ui <- function(id = "about") {
  ns <- NS(id)
  uiOutput(ns("mainUI"))
}

#' about_server
#' @export
about_server <- function(input, output, session, user_name) {
  observe({
    update_state(input, session$ns(user_name()))
  })


  output$mainUI <- renderUI({
    ns <- session$ns
    # browser()
    fluidRow(
      column(8, offset = 2, div(
        class = "flex-around",
        actionButton(ns("prev"), "prev"),
        actionButton(ns("next_pg"), "next")
      )),
      column(8, offset = 2, uiOutput(ns("introduction")))
    )
  })

  run_it <- reactive({
    currentPage <- input$next_pg - input$prev
    currentPage
  })

  output$introduction <- renderUI({
    user <- user_name()
    ns <- session$ns
    run <- run_it() %>% as.character()

    extendr_link <- text_right("https://github.com/extendr/extendr", "extendr")
    shiny_link <- text_right("https://shiny.rstudio.com/", "Shiny")
    plumber_link <- text_right("https://www.rplumber.io/", "Plumber")
    redis_link <- text_right("https://redis.io/", "Redis")

    page_introduction <- div(
      style = "display: flex; justify-content: left;",
      fluidRow(
        header_main("intro"),
        pp("This application is the culmination of a lot of work."),
        pp("It's a dream of mine to build a really cool website, but I'm also interested in teaching what I know - which can take from development time.
           I'm a fan of history and geopolitics, and looking at Reddit data in real-time can help with understanding more about the history we are witnessing first hand all across the world."),
        pp("So this site is all of that combined. I created this application as a platform for teaching how to make the site you are logged into right now.
           I will teach you how to create your own ndexr.com equivalent, for your own use cases."),
        pp("We're going to build shit by taking the best ideas from multiple paradigms of software development and create a framework for building complex applications."),
        pp("If you're still reading this, I appreciate you and I look forward to sharing more about this with you.
           I don't guarantee anything here follows best practices of any particular industry -
           I am showing you how I build this application which is good enough to get to you in the first place.
           I will always appreciate feedback for any of the information I may share with you on this site and am looking forward to sharing this journey with you.")
      )
    )

    out <- switch(as.character(run),
      "0" = page_introduction,
      "10" = p("fr you pushed that 10 times"),
      tags$image(src = "images/memes/pulp_fiction_wut.gif", width = "100%")
    )
    div(
      fluidRow(
        out,
        div(class = "text-right", h4(glue::glue("pg {as.character(run)}")))
      )
    )
  })
}


#' header_main
#' @export
header_main <- function(text, fn = h1, class = "text-left font-weight-bold") {
  div(
    fn(text, class = class, style = "padding: 2px;")
  )
}

#' pp
#' @export
pp <- function(...) {
  div(style = "padding-top: 10px;", p(...))
}
