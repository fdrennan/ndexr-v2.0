create table userbase
(
    username text,
    password text,
    permissions text,
    name text,
    UNIQUE(username)
);

ALTER TABLE userbase
ADD email text;