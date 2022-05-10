#' postgres_connector
#' @importFrom RPostgres Postgres
#' @importFrom DBI dbConnect
#' @param host The hostame, Sys.getenv('POSTGRES_HOST')
#' @param port The port, Sys.getenv('POSTGRES_PORT')
#' @param user The port, Sys.getenv('POSTGRES_USER')
#' @param password The port, Sys.getenv('POSTGRES_PASSWORD')
#' @export postgres_connector
postgres_connector <- function(host = Sys.getenv("POSTGRES_HOST"),
                               port = Sys.getenv("POSTGRES_PORT"),
                               user = Sys.getenv("POSTGRES_USER"),
                               password = Sys.getenv("POSTGRES_PASSWORD"),
                               dbname = Sys.getenv("POSTGRES_DB")) {
  dbConnect(Postgres(),
    host = host,
    port = port,
    user = user,
    password = password,
    dbname = dbname
  )
}
