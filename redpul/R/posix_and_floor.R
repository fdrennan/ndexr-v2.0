#' posix_and_floor
#' @export
posix_and_floor <- function(x) {
  floor_date(
    as.POSIXct(x, origin = "1970-01-01"), "6 hour"
  )
}
