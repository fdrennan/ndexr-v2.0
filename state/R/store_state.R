#' store_state
#' @export store_state
store_state <- function(input, id, max_len = 30) {
  cli::cli_alert_info("Storing {id}")
  message(glue("Storing data {id}"))
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  input <- reactiveValuesToList(input)
  input <- keep(input, ~ length(.) <= max_len)
  redisSet(id, input)
  redisClose()
}
