#' userMeta
#' @export userMeta
userMeta <- function(id = "userMeta") {
  ns <- NS(id)
  uiOutput(ns("userMetaUI"))
}


#' userMetaServer
#' @export userMetaServer
userMetaServer <- function(input, output, session, user_name) {
  output$userMetaUI <- renderUI({
    ns <- NS("user")
    div(
      h1("Main Panel"),
      textInput(ns("test"), "Text")
    )
  })

  return(input)
}
