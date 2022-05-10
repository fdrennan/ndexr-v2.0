create table urls
(
    url            text,
    nsvals         text,
    continent_name text,
    country_code   text,
    country_name   text,
    UNIQUE (nsvals)
);


select count(*)
from urls

select *
from urls
where country_name='Russia'