#' settings_ui
#' @export
settings_ui <- function(id = "user_settings", user) {
  ns <- NS(id)
  state <- get_redis_user_state(ns(user))
  timeZone <- setDefault(state$timeZone, "UTC")
  emailMe <- setDefault(state$emailMe, TRUE)
  div(
    h3("Settings"),
    selectizeInput(
      ns("timeZone"),
      h4("Preferred Time Zone"),
      selected = timeZone,
      choices = OlsonNames()
    ),
    checkboxInput(ns("emailMe"), "Email Me", value = emailMe)
  )
}

#' settings_server
#' @export
settings_server <- function(input, output, session, user_name) {
  observe({
    ns <- session$ns
    update_state(input, ns(user_name()))
  })

  return(input)
}
