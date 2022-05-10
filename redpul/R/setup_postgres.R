# #' postgres_setup
# #' @importFrom DBI dbExistsTable dbExecute
# #' @importFrom readr read_file
# #' @param connection
# #' @export postgres_setup
# postgres_setup <- function(connection) {
#   con <- postgres_connector()
#   on.exit(dbDisconnect(conn = con))
#   if (!dbExistsTable(con, "submissions")) {
#     dbExecute(con, read_file("sql/submissions.sql"))
#   }
# }
