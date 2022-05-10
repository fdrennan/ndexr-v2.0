create table submissions
(
    approved_by   text,
    archived      boolean,
    author        text,
    banned_by     text,
    clicked       boolean,
    created       double precision,
    created_utc   double precision,
    domain        text,
    downs         double precision,
    gilded        integer,
    hidden        boolean,
    hide_score    boolean,
    id            text,
    is_self       boolean,
    likes         boolean,
    locked        boolean,
    name          text,
    num_comments  integer,
    over_18       boolean,
    permalink     text,
    quarantine    boolean,
    score         double precision,
    selftext      text,
    selftext_html text,
    stickied      boolean,
    subreddit     text,
    subreddit_id  text,
    thumbnail     text,
    title         text,
    ups           double precision,
    url           text,
    UNIQUE (id)
);

create materialized view statistics as (
select 'n_subreddits' as name, count(distinct subreddit) as value
from submissions
union
select 'n_authors' as name, count(distinct author) as value
from submissions
union
select 'n_submissions' as name, count(*) as value
from submissions

                                      )