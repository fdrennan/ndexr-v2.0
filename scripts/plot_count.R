library(redpul)

load_dot_env(file = ".env")
print(Sys.getenv())

# response <- redpul::submission_search(
#   limit = 100000, search_terms = 'ukraine',
#   search_cols = c('title', 'selftext'),
#   table = 'submissions_history'
# )


if (FALSE) {
  con <- postgres_connector()
  subreddit_name <- "ukraine"
  subreddit <- tbl(con, "submissions_history") %>%
    filter(subreddit == subreddit_name) %>%
    collect()

  authors <-
    subreddit %>%
    pull(author)

  authors <-
    tbl(con, "submissions_history") %>%
    filter(author %in% local(authors)) %>%
    collect()

  write_rds(authors, "../extdata/ukraine_authors.rda")
}

authors <- read_rds("../extdata/ukraine_authors.rda")


recent_authors <-
  authors %>%
  ungroup() %>%
  select(author, subreddit, created_utc, title, selftext, domain, url) %>%
  arrange(desc(created_utc)) %>%
  group_by(author) %>%
  mutate(row_num = row_number()) %>%
  filter(row_num <= 25)


recent_authors %>%
  group_by(subreddit) %>%
  count(sort = T, name = "n_obs") %>%
  filter(n_obs >= 25) %>%
  as.data.frame()
# count(sort = TRUE, name = 'n_obs')
# authors %>%
#   group_by(author) %>%
#   count(name = 'n_obs') %>%
#   filter(n_obs<=25) %>%
#   arrange(n_obs) %>%
#   rowwise() %>%
#   # pull(n_obs) %>%
#   mutate(
#     resp = (function(author, n_obs) {
#       try({
#         print(n_obs)
#         print(nrow(redpul::grab_and_store(author, author = T)))
#       })
#       TRUE
#     })(author, n_obs)
#   )
