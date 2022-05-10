#' get_users
#' @export get_users
get_users <- function() {
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  dbReadTable(con, "userbase")
}
