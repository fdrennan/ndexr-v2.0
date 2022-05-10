use extendr_api::prelude::*;
use roux::Subreddit;
use roux::User;
use serde_json::json;

pub async fn redpul_pull(sub: &str) -> Vec<String> {
    let subreddit = Subreddit::new(sub);
    rprintln!("Pulling {:#?}", sub);
    // Now you are able to:
    let top = subreddit.latest(100, None).await.unwrap();
    let mut svec = Vec::new();
    for x in top.data.children.into_iter() {
        let data = x.data;
        let domain = data.domain;
        let banned_by = match data.banned_by {
            Some(x) => x,
            None => "".to_string(),
        };
        let subreddit = data.subreddit;
        let selftext_html = match data.selftext_html {
            Some(x) => x,
            None => "".to_string(),
        };
        let selftext = data.selftext;
        let likes = match data.likes {
            Some(x) => x,
            None => false,
        };
        let id = data.id;
        let gilded = data.gilded;
        let archived = data.archived;
        let clicked = data.clicked;
        let author = data.author;
        let score = data.score;
        let approved_by = match data.approved_by {
            Some(x) => x,
            None => "".to_string(),
        };
        let over_18 = data.over_18;
        let hidden = data.hidden;
        let num_comments = data.num_comments;
        let thumbnail = data.thumbnail;
        let subreddit_id = data.subreddit_id;
        let hide_score = data.hide_score;
        let downs = data.downs;
        let ups = data.ups;
        let stickied = data.stickied;
        let is_self = data.is_self;
        let permalink = data.permalink;
        let locked = data.locked;
        let name = data.name;
        let created = data.created;
        let url = match data.url {
            Some(x) => x,
            None => "".to_string(),
        };
        let quarantine = data.quarantine;
        let title = data.title;
        let created_utc = data.created_utc;

        let data = json!({
            "domain": domain,
            "banned_by": banned_by,
            "subreddit": subreddit,
            "selftext_html": selftext_html,
            "selftext": selftext,
            "likes": likes,
            "id": id,
            "gilded": gilded,
            "archived": archived,
            "clicked": clicked,
            "author": author,
            "score": score,
            "approved_by": approved_by,
            "over_18": over_18,
            "hidden": hidden,
            "num_comments": num_comments,
            "thumbnail": thumbnail,
            "subreddit_id": subreddit_id,
            "hide_score": hide_score,
            "downs": downs,
            "ups": ups,
            "stickied": stickied,
            "is_self": is_self,
            "permalink": permalink,
            "locked": locked,
            "name": name,
            "created": created,
            "url": url,
            "quarantine": quarantine,
            "title": title,
            "created_utc": created_utc,
        });
        svec.push(data.to_string())
    }
    rprintln!("Got {:#?}", sub);
    svec
}


pub async fn redpul_pull_author(username: &str) -> Vec<String> {
    let user = User::new(username);
    // Now you are able to:
    let subs = user.submitted().await.unwrap();
    let mut svec = Vec::new();
    for x in subs.data.children.into_iter() {
        let data = x.data;
        let domain = data.domain;
        let banned_by = match data.banned_by {
            Some(x) => x,
            None => "".to_string(),
        };
        let subreddit = data.subreddit;
        let selftext_html = match data.selftext_html {
            Some(x) => x,
            None => "".to_string(),
        };
        let selftext = data.selftext;
        let likes = match data.likes {
            Some(x) => x,
            None => false,
        };
        let id = data.id;
        let gilded = data.gilded;
        let archived = data.archived;
        let clicked = data.clicked;
        let author = data.author;
        let score = data.score;
        let approved_by = match data.approved_by {
            Some(x) => x,
            None => "".to_string(),
        };
        let over_18 = data.over_18;
        let hidden = data.hidden;
        let num_comments = data.num_comments;
        let thumbnail = data.thumbnail;
        let subreddit_id = data.subreddit_id;
        let hide_score = data.hide_score;
        let downs = data.downs;
        let ups = data.ups;
        let stickied = data.stickied;
        let is_self = data.is_self;
        let permalink = data.permalink;
        let locked = data.locked;
        let name = data.name;
        let created = data.created;
        let url = match data.url {
            Some(x) => x,
            None => "".to_string(),
        };
        let quarantine = data.quarantine;
        let title = data.title;
        let created_utc = data.created_utc;

        let data = json!({
            "domain": domain,
            "banned_by": banned_by,
            "subreddit": subreddit,
            "selftext_html": selftext_html,
            "selftext": selftext,
            "likes": likes,
            "id": id,
            "gilded": gilded,
            "archived": archived,
            "clicked": clicked,
            "author": author,
            "score": score,
            "approved_by": approved_by,
            "over_18": over_18,
            "hidden": hidden,
            "num_comments": num_comments,
            "thumbnail": thumbnail,
            "subreddit_id": subreddit_id,
            "hide_score": hide_score,
            "downs": downs,
            "ups": ups,
            "stickied": stickied,
            "is_self": is_self,
            "permalink": permalink,
            "locked": locked,
            "name": name,
            "created": created,
            "url": url,
            "quarantine": quarantine,
            "title": title,
            "created_utc": created_utc,
        });
        svec.push(data.to_string())
    }
    rprintln!("Got {:#?}", username);
    svec
}
