drop materialized view plotting_counts_day;
create materialized view plotting_counts_day as (
    select created_date, count(*) as n_obs
    from (
         select date_trunc('day', to_timestamp(created_utc)) as created_date
         from submissions_history
             ) x
    group by created_date
);

drop materialized view plotting_counts_hour;
create materialized view plotting_counts_hour as (
    select created_date, count(*) as n_obs
    from (
         select date_trunc('hour', to_timestamp(created_utc)) as created_date
         from submissions_history
             ) x
    group by created_date
);

drop materialized view plotting_counts_minute;
create materialized view plotting_counts_minute as (
    select created_date, count(*) as n_obs
    from (
         select date_trunc('minute', to_timestamp(created_utc)) as created_date
         from submissions_history
             ) x
    group by created_date
);


select count(*)
from submissions_history