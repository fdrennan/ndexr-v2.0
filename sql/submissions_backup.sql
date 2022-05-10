create table submissions_history
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

create table submissions_backup as (
    select *
    from submissions
    where to_timestamp(created_utc) < date_trunc('day', now() - interval '2 day')
    order by created_utc desc
);

