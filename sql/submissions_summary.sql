create materialized view submission_lookup as (
with base as (
    select *, over_18_obs::numeric/n_obs::numeric as explicitness
    from (
         select subreddit, sum(over_18::integer) as over_18_obs, count(*) as n_obs
    from submissions
    group by subreddit
             ) x
), subreddit_lookup as (
    select b.over_18_obs, b.n_obs, b.explicitness, s.*
    from base b
    inner join submissions s on b.subreddit=s.subreddit
), subreddit as (
    select over_18_obs, n_obs, explicitness, author, created_utc,
       domain, downs, name, num_comments, over_18, permalink, url, thumbnail, selftext, title, subreddit
    from subreddit_lookup
)

select *
from subreddit
)