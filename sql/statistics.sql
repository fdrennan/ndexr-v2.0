create materialized view statistics as (
  select 'n_submissions' as name, count(*) as value
  from submissions
  union
  select 'n_authors' as name, count(distinct author) as value
  from submissions
  union
  select 'n_subreddits' as name, count(distinct subreddit) as value
  from submissions
  union
  select 'n_submissions_all' as name, count(*) as value
  from submissions_history
  union
  select 'n_authors_all' as name, count(distinct author) as value
  from submissions_history
  union
  select 'n_subreddits_all' as name, count(distinct subreddit) as value
  from submissions_history
);
