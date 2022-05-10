library(plumber)
library(redpul)
library(tictoc)
library(DBI)
library(jsonlite)
library(state)
library(lubridate)
library(rvest)
library(snakecase)
library(stringr)
dotenv::load_dot_env()
pkgs <- installed.packages()
redpul_version <- pkgs[pkgs[, 1] == "redpul", ][["Built"]]

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* @filter cors
cors

#* Return Data for Plotting
#* @serializer unboxedJSON
#* @param hours_ago
#* @param subreddit_names
#* @param split_explicit
#* @get /plot
function(hours_ago = 30,
         split_explicit = TRUE,
         subreddit_names = '["all"]',
         trunc_time = "minutes") {
  hours_ago <- as.numeric(hours_ago)
  subreddit_names <- as.character(subreddit_names)
  subreddit_names <- fromJSON(subreddit_names)
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    message = "Success!",
    console = list(
      args = list(
        hours_ago = hours_ago,
        split_explicit = split_explicit,
        subreddit_names = subreddit_names,
        trunc_time = trunc_time
      ),
      runtime = 0
    )
  )
  # print(response)
  response <- capture_environment(
    plot_subreddit_timeseries(
      hours_ago = hours_ago,
      split_explicit = split_explicit,
      subreddit_names = subreddit_names,
      trunc_time = trunc_time
    ), response
  )
  return(response)
}

#* Delete all data
#* @serializer unboxedJSON
#* @get /delete
function(delete_time = 1) {
  delete_time <- as.numeric(delete_time)
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    message = "Success!",
    console = list(
      runtime = 0,
      delete_time = delete_time
    )
  )


  tic()
  con <- postgres_connector()
  on.exit(dbDisconnect(con))
  dbExecute(
    con, "insert into submissions_history (approved_by, archived, author, banned_by, clicked, created, created_utc, domain, downs, gilded, hidden, hide_score, id, is_self, likes, locked, name, num_comments, over_18, permalink, quarantine, score, selftext, selftext_html, stickied, subreddit, subreddit_id, thumbnail, title, ups, url)
          select *
            from submissions
          order by created_utc desc
          on conflict do nothing;"
  )

  dbExecute(
    con, "delete from submissions
          where to_timestamp(created_utc) < date_trunc('day', now() - interval '1 day');"
  )
  response$runtime <- toc()
  # print(response)
  return(response)
}


#* Find Submissions
#* @serializer unboxedJSON
#* @param search_terms
#* @param limit
#* @param arrange_by
#* @get /subreddit
function(arrange_by = '["subreddit"]',
         search_terms = '["news"]',
         search_cols = '["title"]',
         table = "submissions",
         limit = 100) {
  limit <- as.numeric(limit)
  search_terms <- fromJSON(search_terms)
  arrange_by <- fromJSON(arrange_by)
  search_cols <- fromJSON(search_cols)
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    message = "Success!",
    params = list(
      limit = limit,
      search_terms = search_terms,
      arrange_by = arrange_by,
      table = table,
      search_cols = search_cols
    )
  )
  print(response)
  response <- capture_environment(
    submission_search(
      search_cols = search_cols, table = table,
      limit = limit,
      search_terms = search_terms,
      arrange_by = arrange_by
    ),
    response
  )
  response$nrows <- nrow(response)
  print(response$nrows)
  return(response)
}


#* Get and Store geonames data
#* @serializer unboxedJSON
#* @get /incoming_users
function() {
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    message = "Success!"
  )

  response <- capture_environment(
    incoming_users(),
    response
  )
  # print(response)
  return(response)
}

#* @serializer unboxedJSON
#* @get /user_activity
function() {
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    message = "Success!"
  )

  response <- capture_environment(
    user_activity(),
    response
  )
  # print(response)
  return(response)
}


#* @serializer unboxedJSON
#* @get /pullsub
function(subreddits, author = FALSE, tablename = "submissions") {
  author <- as.logical(author)
  subreddits <- fromJSON(subreddits)
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    args = list(
      author = author,
      subreddits = subreddits,
      tablename = tablename
    ),
    message = "Success!"
  )

  response <- capture_environment(
    redpul::grab_and_store(subreddits, author, tablename),
    response
  )
  # print(response)
  return(response)
}


#* @serializer unboxedJSON
#* @post /urllookup
function(urlvec = '["www.reddit.com","v.redd.it","youtu.be","i.redd.it","www.cbc.ca","youtube.com","www.forbes.com"]') {
  urlvec <- fromJSON(urlvec)
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    args = list(
      urlvec = urlvec
    ),
    message = "Success!"
  )

  response <- capture_environment(
    {
      con <- postgres_connector()
      on.exit(dbDisconnect(con))

      # browser()

      file <- system.file("extdata", "GeoLite2-Country.mmdb", package = "rgeolocate")
      data <- tibble(
        url = urlvec,
        nsvals = map_chr(urlvec, nslookup)
      )
      existing <- tbl(con, "urls") %>%
        # collect %>%
        filter(nsvals %in% local(data$nsvals)) %>%
        collect()

      if (nrow(existing) == nrow(data)) {
        return(existing)
      }

      if (nrow(existing) <= nrow(data)) {
        if (nrow(existing) > 0) {
          data <- anti_join(data, existing, by = "nsvals")
        }

        if (nrow(data) == 0) {
          return(existing)
        }

        data <- split(data, 1:nrow(data))

        data <- map_dfr(
          data,
          function(x) {
            print(x)
            data <- maxmind(x$nsvals, file, c(
              "continent_name", "country_code", "country_name"
            ))
            bind_cols(x, data)
          }
        )
        data <- bind_rows(existing, data)
        dbxUpsert(con, "urls", data, where_cols = "nsvals", skip_existing = TRUE)
      }

      data
    },
    response
  )
  # print(response)
  return(response)
}
