#' update_state
#' @export update_state
update_state <- function(input, user, len = 25, exclude_names = c(
                           "_state", "_rows_current", "_all"
                         )) {
  if (is.reactivevalues(input)) {
    input <- reactiveValuesToList(input)
  }
  cli_alert_info("Storing state for {user}")
  # names_input <- names(input)
  # browser()
  # names_input <- names_input[rowSums(map_dfc(exclude_names, ~ str_detect(names_input, .))) == 0]
  input <- map(input, function(inpt) {
    purrr::discard(inpt, ~ length(.) > 5)
  })
  # browser()
  # input <- purrr::keep(input, ~ length(.) <= len)
  if (length(input)) {
    try_con <- try(redisConnect(host = Sys.getenv("REDIS_HOST")))
    if (inherits(try_con, "try-error")) {
      cli_alert_danger("Failed to store state")
      return()
    }
    state <- redisGet(user)
    state <- update.list(state, input)
    state$redis_timestamp <- Sys.time()
    state$user_name <- user
    con <- mongo("user_history", "redpul", Sys.getenv("MONGO_URI"))
    con$insert(state)
    # print(toJSON(input, pretty = TRUE))
    redisSet(user, state)
    redisClose()
  }
}

#' update_state_val
#' @export update_state_val
update_state_val <- function(val, user, len = 25, exclude_names = c(
                               "_state", "_rows_current", "_all"
                             )) {



  # if (length(input)) {
  try_con <- try(redisConnect(host = Sys.getenv("REDIS_HOST")))
  if (inherits(try_con, "try-error")) {
    cli_alert_danger("Failed to store state")
    return()
  }
  state <- redisGet(user)
  state <- update.list(state, val)
  state$redis_timestamp <- Sys.time()
  state$user_name <- user
  con <- mongo("user_history", "redpul", Sys.getenv("MONGO_URI"))
  con$insert(state)
  redisSet(user, state)
  redisClose()
  # }
}
