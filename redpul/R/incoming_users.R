#' incoming_users
#' @export incoming_users
incoming_users <- function() {
  mongo_uri <- Sys.getenv("MONGO_URI")
  con <- mongolite::mongo(
    collection = "http_incoming", db = "redpul", url = mongo_uri
  )

  incoming_counts <-
    con$find() %>%
    mutate(
      systime = with_tz(
        as.POSIXct(systime, origin = "1970-01-01"), "America/Denver"
      ) %>% floor_date("1 minute")
    ) %>%
    filter(!is.na(systime))

  incoming_counts <-
    incoming_counts %>%
    group_by(systime) %>%
    summarise(
      n = n()
    )

  incoming_counts
}
