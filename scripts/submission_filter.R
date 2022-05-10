library(state)
library(dplyr)
library(dbplyr)
library(stringr)
library(lubridate)
library(ggplot2)

con <- postgres_connector()

data <-
  tbl(con, "submissions") %>%
  # filter(str_detect(str_to_lower(selftext), "ukraine")) %>%
  select(created_utc, author, subreddit, title, selftext, url) %>%
  collect()
# filter(to_timestamp(created_utc) >= local(Sys.Date() - 1)) %>%
# arrange(desc(created_utc)) %>%
# collect() %>%
# mutate(
#   created_utc = as_datetime(
#     created_utc,
#     tz = "America/Denver"
#   ) %>% floor_date("1 minute")
# ) %>%
# group_by(created_utc) %>%
# summarise(n_obs = n())

#
# ggplot(data) +
#   aes(x = created_utc, y = n_obs) +
#   geom_col()

unique_subreddits <- unique(data$subreddit)

data %>%
  group_by(url) %>%
  count(sort = T)
