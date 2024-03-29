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
            ROUND(COALESCE(mi.ig_reels_avg_watch_time, 0) / 1000.0, 2) as reels_avg_watch_time,
            ROUND(COALESCE(mi.ig_reels_video_view_total_time, 0) / 1000.0, 2) as reels_video_view_total_time,
            COALESCE(m.thumbnail_url, m.media_url) as media_url,
            COALESCE(mi.reach, 0) as reach,
            COALESCE(mi.impressions, mi.plays) as impressions,
            COALESCE(mi.total_interactions, 0) as engagement,
            m.media_type,
            m.timestamp
        from `begin-data.instagram_raw.media` m
        left join `begin-data.instagram_raw.media_insights` mi 
        on m.id = mi.id
        where
            (m.like_count is not null)
            or (m.comments_count is not null)
            or (m.id is not null)
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
            md.engagement,
            reels_avg_watch_time,
            reels_video_view_total_time,
            md.media_type,
            md.timestamp
        from stg_media as md
        left join
            `begin-data.instagram_raw.users` as users
            on md.business_account_id = users.id
        where
            md.saved is not null
            and users.username is not null
            and md.id is not null
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
            md.engagement,
            coalesce(md.plays, 0) as plays,
            coalesce(md.reach, 0) as reach,
            coalesce(md.impressions, 0) as impressions,
            reels_avg_watch_time,
            reels_video_view_total_time,
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
