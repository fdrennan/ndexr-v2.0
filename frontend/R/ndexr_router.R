#' #' ndexr_router
#' #' @export
#' ndexr_router <- function() {
#'   make_router(
#'     route(
#'       "/",
#'       div(
#'         login_ui("login", title = "ndexr login"),
#'         uiOutput("main_user_panel")
#'       )
#'     ),
#'     route("about", about_ui("about_ui")),
#'     route("signup", signup())
#'   )
#' }
