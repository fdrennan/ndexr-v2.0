#' build_ndexr_plot
#' @export build_ndexr_plot
build_ndexr_plot <- function(hoursAgo = 24, timeUnit = "minutes", geomType = "bar", timeZone = "UTC",
                             breaksWidth = "2 hour", breaksBin = 24, dateUnit = "5 min") {


  # dateUnit <-
  trunc_time <- strsplit(dateUnit, " ")[[1]][[2]]
  data <- response_to_robj("plot", query = list(
    hours_ago = hoursAgo,
    subreddit_names = '["all"]',
    trunc_time = trunc_time
  ))$data

  # browser()
  data <- mutate(data, time = floor_date(ymd_hms(time), unit = dateUnit))

  p <-
    data %>%
    ggplot() +
    aes(x = time, y = n_obs) +
    geom_col()

  p <- p +
    scale_x_datetime(
      breaks = breaks_width(breaksWidth),
      labels = date_format(
        "%H:%M",
        tz = timeZone
      )
    ) +
    ggtitle("Submissions collected in submissions table")

  p +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    )
}

# build_ndexr_plot()
