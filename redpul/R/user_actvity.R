#' user_activity
#' @export user_activity
user_activity <- function(n_hours = 336) {
  mongo_uri <- Sys.getenv("MONGO_URI")
  con <- mongolite::mongo(
    collection = "user_history", db = "redpul", url = mongo_uri
  )

  data <-
    con$aggregate(
      '[
        {
            "$project" : {
                "user_name" : "$user_name",
                "redis_timestamp" : "$redis_timestamp",
                "_id" : 0
            }
        },
        {
            "$group" : {
                "_id" : null,
                "distinct" : {
                    "$addToSet" : "$$ROOT"
                }
            }
        },
        {
            "$unwind" : {
                "path" : "$distinct",
                "preserveNullAndEmptyArrays" : false
            }
        },
        {
            "$replaceRoot" : {
                "newRoot" : "$distinct"
            }
        }
    ]'
    )

  data <-
    data %>%
    filter(!(user_name %in% c("fdrennan", "asdf"))) %>%
    mutate(user_name = unlist(user_name)) %>%
    filter(
      redis_timestamp >= Sys.time() - hours(n_hours)
    ) %>%
    mutate(
      redis_timestamp = floor_date(redis_timestamp, "6 hours")
    ) %>%
    group_by(user_name, redis_timestamp) %>%
    count(name = "n_obs")

  data
}
