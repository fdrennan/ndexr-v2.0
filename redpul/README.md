
# redpul

``` r
# install.packages("devtools")
devtools::install_github("fdrennan/redpul")
```

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(redpul)
# Find a bunch of subreddits and then pull their most recent 100 submissions
submissions <- redpul_find('all')
#> Pulling "all"
#> Got "all"
#> Finishing up on R side

recent_posts <-
  submissions %>%
  filter(!over_18) %>%
  pull(subreddit) %>%
  unique() %>%
  redpul_find()
#> Pulling "u_news247planet"
#> Pulling "Worldnews_Headline"
#> Pulling "AskReddit"
#> Pulling "Chiraqology"
#> Pulling "buffalobills"
#> Pulling "PokemonMasters"
#> Pulling "pesmobile"
#> Pulling "VHS"
#> Pulling "headphones"
#> Pulling "buildapc"
#> Pulling "Republican"
#> Pulling "unsplashcats"
#> Pulling "tf2"
#> Pulling "UplandMe"
#> Pulling "antimeme"
#> Pulling "Worldbox"
#> Pulling "SnakeRescue"
#> Pulling "ico"
#> Pulling "WomenOfWrestlingPlot"
#> Pulling "u_estella_hot"
#> Pulling "Bioshock"
#> Pulling "NoFap"
#> Pulling "RoyaleHighTrading"
#> Pulling "ARK"
#> Pulling "Meditation"
#> Pulling "cryptohangout"
#> Pulling "GachaClub"
#> Pulling "ralsei"
#> Pulling "pokemonmemes"
#> Pulling "teenagers"
#> Pulling "Marijuana"
#> Pulling "BlancaSoler"
#> Pulling "AARP_Politics"
#> Pulling "aww"
#> Pulling "u_Geraldine666666"
#> Pulling "ASX_Bets"
#> Pulling "GBO2"
#> Pulling "servicedogs"
#> Pulling "CardanoNFTs"
#> Pulling "fakehistoryporn"
#> Pulling "NonCredibleDefense"
#> Pulling "90sHipHop"
#> Pulling "Tufting"
#> Pulling "SummonSign"
#> Pulling "u_purplemanacards"
#> Pulling "careerguidance"
#> Pulling "picrew"
#> Pulling "u_kathie_dirty"
#> Pulling "u_televisionbuzz"
#> Pulling "cocaine"
#> Pulling "Komi_san"
#> Pulling "SuperActionStatue"
#> Pulling "findareddit"
#> Pulling "news"
#> Pulling "PokemonLegendsArceus"
#> Pulling "BNBTrader"
#> Got "u_Geraldine666666"
#> Got "AskReddit"
#> Got "unsplashcats"
#> Got "findareddit"
#> Got "u_kathie_dirty"
#> Got "Worldnews_Headline"
#> Got "teenagers"
#> Got "buildapc"
#> Got "PokemonMasters"
#> Got "u_estella_hot"
#> Got "Tufting"
#> Got "buffalobills"
#> Got "cryptohangout"
#> Got "UplandMe"
#> Got "headphones"
#> Got "ARK"
#> Got "RoyaleHighTrading"
#> Got "u_purplemanacards"
#> Got "Republican"
#> Got "Marijuana"
#> Got "SummonSign"
#> Got "NoFap"
#> Got "picrew"
#> Got "fakehistoryporn"
#> Got "pokemonmemes"
#> Got "tf2"
#> Got "GBO2"
#> Got "Chiraqology"
#> Got "GachaClub"
#> Got "news"
#> Got "Komi_san"
#> Got "BlancaSoler"
#> Got "Meditation"
#> Got "u_news247planet"
#> Got "90sHipHop"
#> Got "VHS"
#> Got "cocaine"
#> Got "SnakeRescue"
#> Got "CardanoNFTs"
#> Got "careerguidance"
#> Got "Worldbox"
#> Got "PokemonLegendsArceus"
#> Got "NonCredibleDefense"
#> Got "AARP_Politics"
#> Got "ralsei"
#> Got "ico"
#> Got "SuperActionStatue"
#> Got "WomenOfWrestlingPlot"
#> Got "servicedogs"
#> Got "u_televisionbuzz"
#> Got "Bioshock"
#> Got "pesmobile"
#> Got "aww"
#> Got "antimeme"
#> Got "BNBTrader"
#> Got "ASX_Bets"
#> Finishing up on R side

glimpse(recent_posts)
#> Rows: 5,539
#> Columns: 31
#> $ approved_by   <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", …
#> $ archived      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ author        <chr> "news247planet", "news247planet", "news247planet", "news…
#> $ banned_by     <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", …
#> $ clicked       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ created       <dbl> 1642909413, 1642909409, 1642909402, 1642909396, 16429093…
#> $ created_utc   <dbl> 1642909413, 1642909409, 1642909402, 1642909396, 16429093…
#> $ domain        <chr> "news247planet.com", "news247planet.com", "news247planet…
#> $ downs         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ gilded        <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ hidden        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ hide_score    <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR…
#> $ id            <chr> "sak9ta", "sak9rw", "sak9ow", "sak9mk", "sak9kw", "sak9j…
#> $ is_self       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ likes         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ locked        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ name          <chr> "t3_sak9ta", "t3_sak9rw", "t3_sak9ow", "t3_sak9mk", "t3_…
#> $ num_comments  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ over_18       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ permalink     <chr> "/r/u_news247planet/comments/sak9ta/recent_curbs_kick_in…
#> $ quarantine    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ score         <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ selftext      <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", …
#> $ selftext_html <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", …
#> $ stickied      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
#> $ subreddit     <chr> "u_news247planet", "u_news247planet", "u_news247planet",…
#> $ subreddit_id  <chr> "t5_57y7rn", "t5_57y7rn", "t5_57y7rn", "t5_57y7rn", "t5_…
#> $ thumbnail     <chr> "https://b.thumbs.redditmedia.com/IqOVM1V14pHWaJ2QKPFcJ9…
#> $ title         <chr> "Recent curbs kick in as India sees surge in Covid-19 in…
#> $ ups           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ url           <chr> "https://news247planet.com/wp-content/uploads/2022/01/45…

recent_posts %>%
  group_by(subreddit) %>%
  count(sort = TRUE)
#> # A tibble: 56 × 2
#> # Groups:   subreddit [56]
#>    subreddit         n
#>    <chr>         <int>
#>  1 90sHipHop       100
#>  2 AARP_Politics   100
#>  3 antimeme        100
#>  4 ARK             100
#>  5 AskReddit       100
#>  6 ASX_Bets        100
#>  7 aww             100
#>  8 Bioshock        100
#>  9 BNBTrader       100
#> 10 buffalobills    100
#> # … with 46 more rows
```

[RabbitMQ](http://localhost:15672/)
# redpul
