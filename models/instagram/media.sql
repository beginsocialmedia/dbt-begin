with
    stg_media as (
        select
            m.like_count,
            m.comments_count,
            mi.saved,
            mi.shares,
            mi.plays,
            mi.id,
            m.permalink,
            mi.business_account_id,
            m.media_url,
            mi.reach,
            mi.impressions,
            m.media_type,
            m.timestamp
        from `begin-data.instagram_raw.media` as m
        left join `begin-data.instagram_raw.media_insights` as mi on m.id = mi.id
        where
            (m.id not in (select id from `begin-data.instagram_raw.stories`))
            or (m.like_count is null)
            or (m.comments_count is null)
    ),

    -- First CTE Above
    stg_media_2 as (
        select
            users.username,
            md.like_count,
            md.comments_count,
            md.saved,
            md.shares,
            md.plays,
            md.id,
            md.permalink,
            users.followers_count,
            md.media_url,
            md.reach,
            md.impressions,
            md.media_type,
            md.timestamp
        from stg_media as md
        left join
            `begin-data.instagram_raw.users` as users
            on md.business_account_id = users.id
    -- WHERE username = 'beginsocialmedia' -- profile filtering
    ),

    -- Second CTE Above
    media as (
        select
            md.username,
            floor(
                coalesce(md.like_count, 0) * 0.164
                + coalesce(md.comments_count, 0) * 0.297
                + coalesce(md.saved, 0) * 0.539 / md.followers_count * 10000
            ) as score,
            md.like_count,
            md.comments_count,
            md.saved,
            coalesce(md.shares, 0) as shares,
            coalesce(md.like_count, 0)
            + coalesce(md.comments_count, 0)
            + coalesce(md.saved, 0)
            + coalesce(shares, 0) as engagement,
            coalesce(md.plays, 0) as plays,
            coalesce(md.reach, 0) as reach,
            coalesce(md.impressions, 0) as impressions,
            md.permalink,
            md.id,
            md.media_url,
            md.media_type,
            md.timestamp as date
        from stg_media_2 as md
    )

-- Final CTE above
select *
from media as md
