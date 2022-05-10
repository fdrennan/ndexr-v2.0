
library(redpul)
con <- postgres_connector()

ukraine_data <-
  submission_search(
    search_terms = "ukraine",
    table = "submissions_history",
    limit = 100000,
    search_cols = c("title", "selftext", "subreddit")
  )

d <-
  ukraine_data %>%
  mutate(
    created_utc = floor_date(created_utc, "60 minutes"),
  )

d %>%
  group_by(title, selftext) %>%
  mutate(n_submissions = n()) %>%
  ungroup() %>%
  select(title, selftext, n_submissions, subreddit, author) %>%
  distinct() %>%
  arrange(desc(n_submissions)) %>%
  DT::datatable(
    rownames = FALSE, options = list(
      ajax = list(
        serverSide = TRUE, processing = TRUE,
        url = "https://datatables.net/examples/server_side/scripts/jsonp.php",
        dataType = "jsonp"
      )
    )
  )
d <- d %>%
  group_by(created_utc) %>%
  count(name = "n_obs") %>%
  ggplot() +
  aes(x = with_tz(created_utc, "America/Denver"), y = as.numeric(n_obs)) +
  geom_col()
