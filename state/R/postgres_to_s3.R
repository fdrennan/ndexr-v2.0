# library(state)
# library(aws.s3)
# library(readr)
# library(glue)
# con <- postgres_connector()
# # Use state to also handle queries to mongo and postgres
# submissions <- tbl(con, "submissions")
#
# Sys.setenv(
#   "AWS_ACCESS_KEY_ID" = Sys.getenv("AWS_ACCESS"),
#   "AWS_SECRET_ACCESS_KEY" = Sys.getenv("AWS_SECRET"),
#   "AWS_DEFAULT_REGION" = Sys.getenv("AWS_REGION")
# )
#
# submissions <-
#   submissions %>%
#   select(title, selftext, author, subreddit, created_utc, url, thumbnail) %>%
#   mutate(
#     created_utc = to_timestamp(created_utc),
#     year_created = date_trunc("year", created_utc),
#     month_created = date_trunc("month", created_utc),
#     day_created = date_trunc("day", created_utc),
#     hour_created = date_trunc("hour", created_utc),
#     minute_created = date_trunc("minute", created_utc),
#     second_created = date_trunc("second", created_utc)
#   )
#
# submissions_to_store <-
#   submissions %>%
#   mutate(
#     today = date_trunc("day", now())
#   ) %>%
#   filter(day_created != today)
#
#
# days_to_store <-
#   submissions_to_store %>%
#   group_by(day_created) %>%
#   count() %>%
#   collect()


# set a "canned" ACL to, e.g., make bucket publicly readable
# bucket_exists('ndexr')
# put_bucket(
#   "ndexr-submissions",
#   headers = list(`x-amz-acl` = "public-read")
# )

# if (!dir.exists("data_output")) {
#   dir.create("data_output")
# }
#
# map(
#   days_to_store$day_created,
#   function(store_day) {
#     # days_data <-
#     #   submissions %>%
#     #   filter(day_created == local(store_day)) %>%
#     #   collect()
#     # if (nrow(days_data) == 0) {
#     #   stop('No data to store')
#     # }
#     # file_name_csv <- glue('data_output/submsisions_{store_day}.csv')
#     # file_name_tar <- glue('data_output/submsisions_{store_day}.tar.gz')
#     # readr::write_csv(days_data, file_name_csv)
#     # tar(file_name_tar, file_name_csv, compression = 'gzip', tar="tar")
#     # aws.s3::put_object(
#     #   file = file_name_tar, object = file_name_tar, bucket = 'ndexr', multipart = TRUE
#     # )
#     char_day <- as.numeric(store_day)
#     dbGetQuery(
#       con,
#       glue("select * from submissions
#                      where created_utc >={as.numeric()}
#                      limit 10")
#     )
#     print(query)
#     dbGetQuery(con, query)
#   }
# )
#
# keyname <- aws.s3::get_bucket("ndexr")$Contents$Key
# data_urls <- paste0("https://ndexr.s3.us-east-2.amazonaws.com/", keyname)
#
# data_urls
#
# store_dayto_s
