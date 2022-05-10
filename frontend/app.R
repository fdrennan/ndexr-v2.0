library(redpul)
library(frontend)
plan(multisession)

dotenv::load_dot_env()

if (Sys.getenv("REDPUL_HOST") == "localhost") {
  devtools::load_all()
  options(shiny.port = 9050)
}

conflict_prefer("headers", "frontend")
conflict_prefer("filter", "dplyr")
conflict_prefer("signup", "frontend")
conflict_prefer("last", "dplyr")
conflict_prefer("cognito_server", "frontend")
conflict_prefer("logout_ui", "frontend")
conflict_prefer("glue", "glue")

ui <- function(incoming) {
  store_incoming_http_data(incoming)

  output <-
    fluidPage(
      title = "ndexr",
      tags$script(HTML('Shiny.addCustomMessageHandler("changetitle", function(x) {document.title=x});')),
      headers(),
      logout_ui("logout"),
      # Load UI Cognito.
      cognito_ui("cognito"),
      uiOutput("main_user_panel")
      # uiOutput("main_user_panel"),
      # div(id = "navbar_hide", navbar()),
      # router$ui,
      # footer()
    )

  output
}

server <- function(input, output, session) {
  # router$server(input, output, session)
  cognitomod <- callModule(cognito_server, "cognito")

  logged_in <- reactive({
    req(cognitomod$isLogged)
    cognitomod$isLogged
  })
  user <- reactive({
    logged_in()
    user <- cognitomod$userdata$username
    req(user)
    user
  })


  is_admin <- reactive({
    req(logged_in())
    user() == "fdrennan"
  })

  email <- reactive({
    req(logged_in())
    cognitomod$userdata$email
  })

  # Call Logout module ####
  logoutmod <- callModule(
    logout_server,
    "logout",
    reactive(cognitomod$isLogged),
    sprintf("You are logged in as '%s'", email())
  )

  # To Click on button logout of logout module, call logout in cognito module. ####
  observeEvent(logoutmod(), {
    cognitomod$logout()
  })



  observeEvent(cognitomod$isLogged, {
    # browser()
    if (cognitomod$isLogged) {
      # User is logged
      # userdata <- cognitomod$userdata
      # Render user logged.
      output$main_user_panel <- renderUI({

        # browser()
        hide(id = "login")
        hide(id = "toggleAuthSU")
        state <- get_redis_user_state(user())
        timeZone <- setDefault(state$timeZone, "UTC")

        if (!is_admin()) {
          hideTab(inputId = "tabs", target = "Admin")
        }

        shinyjs::hide(id = "navbar_hide")

        div(
          {
            if (is_admin()) {
              div(
                class = "panel-bg",
                bsCollapse(
                  bsCollapsePanel(
                    div("Administration"),
                    backend("backend", user(), is_admin())
                  )
                )
              )
            } else {
              div(class = "bummer")
            }
          },
          tabsetPanel(
            tabPanel(
              "Course",
              user_course("user_course", user()),
            ),
            tabPanel(
              "Explore Reddit",
              data_search("search", user(), is_admin())
            ),
            tabPanel(
              "Monitoring",
              {
                if (is_admin()) {
                  div(
                    statistics_data("statistics_data", user()),
                    statistics_plot("statistics_plot", user(), is_admin())
                  )
                } else {
                  div("Coming soon!")
                }
              }
            ),
            tabPanel(
              "Settings",
              settings_ui(user = user())
            )
            # tabPanel(
            #   "Aelia's Corner",
            #   aelias_corner()
            # )
          )
        )
      })
    }
  })


  callModule(about_server, "about", user)
  userSettings <- callModule(settings_server, "user_settings", user)
  callModule(user_course_server, "user_course", user, userSettings)
  callModule(statistics_plot_server, "statistics_plot", user, userSettings)
  callModule(statistics_data_server, "statistics_data", user)
  callModule(backend_server, "backend", userSettings, user)
  query_results <- callModule(query_generator_server, "query_generator", userSettings, user)
  filtered_query <- callModule(data_search_server, "search", userSettings, query_results, user)
  callModule(summary_ui_server, "summary_ui", filtered_query)
  callModule(url_ui_server, "url", query_results)
  callModule(domain_server, "domain_ui", query_results)
  callModule(browse_ui_server, "browse_ui", query_results)
  callModule(table_ui_server, "table_ui", userSettings, query_results)
  callModule(all_domains_server, "all_domains")
  callModule(pull_reddit_server, "pull_reddit", user, "subreddit")
  callModule(pull_reddit_server, "pull_reddit_author", user, "author")
}

shinyApp(
  ui = ui,
  server = server
)
