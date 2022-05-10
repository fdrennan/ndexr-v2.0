#' get_redis_user_state
#' @export get_redis_user_state
get_redis_user_state <- function(user) {
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  state <- redisGet(user)
  redisClose()
  state
}
