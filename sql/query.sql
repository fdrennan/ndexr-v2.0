select subreddit, author, title, selftext
from postgres.public.submissions
order by created_utc desc
limit 100;

select count(*) as n_obs
from submissions;

select subreddit, count(*) as n_obs
from submissions
group by subreddit
order by n_obs;

select *
from submissions
where title ilike '%solana%';

select count(distinct subreddit)
from submissions
where subreddit ilike '%crypto%';

select  subreddit, count(*) as n_obs
from submissions
group by subreddit
order by n_obs desc;


select *
from submissions
where subreddit ilike '%gonewild%';
-- group by subreddit, author


create table submissions_count
(
    submissions_viewed   bigint
);

update userbase
set permissions = 'user'
where username = 'a';

select *
from submissions
where subreddit in ('politics')

select subreddit from submissions where subreddit ~* '^politics|pics|';
select * from submissions where selftext ilike any (array['%%']);

create materialized view subreddit_summary as (
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
);

select *
from subreddit
where selftext ilike '%ukraine%' or title ilike '%ukraine%' or subreddit ilike '%ukraine%'


insert into userbase (username, password, permissions, name, email)
values ('fdrennan', 'thirdday1', 'admin', 'Freddy', 'drennanfreddy@gmail.com');
update userbase;

update userbase
set email = 'drennanfreddy@gmail.com'
where username='fdrennan';

delete
from userbase
where username != 'fdrennan';