WITH user_data AS (
    SELECT u.username,
           u.followers_count,
           u.media_count,
           u.profile_picture_url,
           u.name,
           u.biography,
           u.id
    FROM begin_db.instagram_raw.users AS u
)
SELECT *
FROM user_data