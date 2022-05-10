insert into submissions_history (approved_by, archived, author, banned_by, clicked, created, created_utc, domain, downs, gilded, hidden, hide_score, id, is_self, likes, locked, name, num_comments, over_18, permalink, quarantine, score, selftext, selftext_html, stickied, subreddit, subreddit_id, thumbnail, title, ups, url)
select *
    from submissions_backup
    order by created_utc desc
on conflict do nothing;

delete from submissions
where to_timestamp(created_utc) < date_trunc('day', now() - interval '1 day');