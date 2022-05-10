#' #' plot_subreddit_timeseries
#' #' @import dplyr
#' #' @importFrom purrr map
#' #' @importFrom xts xts
#' #' @importFrom dygraphs dygraph
#' #' @param df A dataframe with the columns time, n_obs, and explicit
#' #' @export plot_subreddit_timeseries
#' plot_subreddit_timeseries <- function(df) {
#'   xts_data <-
#'     df %>%
#'     mutate(time = as.POSIXct(.data$time, tz = Sys.getenv("TZ"))) %>%
#'     split(df$explicit) %>%
#'     map(function(df) {
#'       xts(df$n_obs,
#'         order.by = df$time
#'       )
#'     })
#'
#'   data_for_plot <- cbind(
#'     explicit = xts_data$explicit,
#'     unknown = xts_data$unknown
#'   )
#'
#'   dygraph(data_for_plot)
#' }
