# #' set_redpul_state
# #' @export set_redpul_state
# set_redpul_state <- function(default_subreddits = "all",
#                              hours_ago = 10,
#                              refresh_ms = 15000,
#                              pull_loop_sleep = 5,
#                              plot_units = "seconds",
#                              default_timezone = "UTC") {
#   redisConnect(host = Sys.getenv("REDIS_HOST"))
#   on.exit(redisClose())
#
#   redpul_state <- list(
#     app = list(
#       default_subreddits = default_subreddits,
#       hours_ago = hours_ago,
#       refresh_ms = refresh_ms,
#       plot_units = plot_units,
#       default_timezone = default_timezone
#     ),
#     redpul = list(
#       pull_loop_sleep = pull_loop_sleep
#     )
#   )
#   # browser()
#   redisSet("redpul_state", list(
#     redpul_state
#   ), NX = FALSE)
# }


#' get_redpul_state
#' @export get_redpul_state
get_redpul_state <- function() {
  redisConnect(host = Sys.getenv("REDIS_HOST"))
  on.exit(redisClose())
  fromJSON(redisGet("redpul_state")[[1]])
}
