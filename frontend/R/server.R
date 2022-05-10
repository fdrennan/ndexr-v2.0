#' server
#' @export server
server <- function(input, output, session) {
  user_base <- tibble::tibble(
    user = c("a", "b"),
    password = c("a", "b"),
    permissions = c("admin", "standard"),
    name = c("User One", "User Two")
  )


  user_name <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = "user",
    pwd_col = "password",
    log_out = reactive(logout_init())
  )

  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(user_name()$user_auth)
  )

  callModule(userMetaServer, "user", user_name)
}
