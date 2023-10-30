with
    user_data as (
        select
            u.username,
            u.followers_count,
            u.media_count,
            u.profile_picture_url,
            u.name,
            u.biography,
            u.id
        from `begin-data.instagram_raw.users` as u
    )
select *
from user_data
