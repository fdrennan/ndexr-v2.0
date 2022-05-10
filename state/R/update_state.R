#' update_state
#' @export update_state
update_state <- function(input, user, len = 25, exclude_names = c(
                           "_state", "_rows_current", "_all"
                         )) {
  if (is.reactivevalues(input)) {
    input <- reactiveValuesToList(input)
  }
  # names_input <- names(input)
  # browser()
  # names_input <- names_input[rowSums(map_dfc(exclude_names, ~ str_detect(names_input, .))) == 0]
  input <- map(input, function(inpt) {
    purrr::discard(inpt, ~ length(.) > 5)
  })
  # browser()
  # input <- purrr::keep(input, ~ length(.) <= len)
  if (length(input)) {
    redisConnect(host = Sys.getenv("REDIS_HOST"))
    state <- redisGet(user)
    state <- update.list(state, input)
    state$redis_timestamp <- Sys.time()
    state$user_name <- user
    con <- mongo("user_history", "redpul", Sys.getenv("MONGO_URI"))
    con$insert(state)
    cli_alert_info("input")
    # print(toJSON(input, pretty = TRUE))
    cli_alert_info("state")
    # print(toJSON(state, pretty = TRUE))
    redisSet(user, state)
    redisClose()
  }
}
