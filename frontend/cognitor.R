# library(frontend)
# library()
library(shinyjs)
library(cognitoR)
# conflict_prefer('cognitoR', 'login_ui')
options(shiny.port = 5000)
# setwd('/home/freddy/Projects/current/redpul/frontend')

# debug(login_setup)
shinyApp(
  ui = function() {
    fluidPage(
      # Load UI logout
      logout_ui("logout"),
      # Load UI Cognito.
      cognito_ui("cognito"),
      # Output to show some content.
      uiOutput("content")
    )
  },
  server = function(input, output, session) {
    # debug(cognito_server)
    # Call Cognito module. ####
    cognitomod <- callModule(cognito_server, "cognito")
    # browser()
    # Call Logout module ####
    logoutmod <- callModule(
      logout_server,
      "logout",
      reactive(cognitomod$isLogged),
      sprintf("You are logged in as '%s'", cognitomod$userdata$email)
    )

    # To Click on button logout of logout module, call logout in cognito module. ####
    observeEvent(logoutmod(), {
      cognitomod$logout()
    })

    # Check if user is already logged, and show a content. ####
    observeEvent(cognitomod$isLogged, {
      # browser()
      if (cognitomod$isLogged) {
        # User is logged
        userdata <- cognitomod$userdata
        # Render user logged.
        output$content <- renderUI({
          p(paste("User: ", unlist(userdata$username)))
        })
      }
    })
  }
)
