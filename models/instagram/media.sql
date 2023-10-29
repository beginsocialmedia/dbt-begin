WITH stg_media as (
    SELECT m.like_count,
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
    FROM `begin-data.instagram_raw.media` AS m
    LEFT JOIN `begin-data.instagram_raw.media_insights` AS mi
           ON m.id = mi.id
    WHERE (m.id NOT IN (SELECT id
                        FROM `begin-data.instagram_raw.stories`))
       OR (m.like_count IS NULL)
       OR (m.comments_count IS NULL)
),

-- First CTE Above

stg_media_2 as (
    SELECT users.username,
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
    FROM stg_media AS md
    LEFT JOIN `begin-data.instagram_raw.users` as users
           ON md.business_account_id = users.id
    -- WHERE username = 'beginsocialmedia' -- profile filtering
),

-- Second CTE Above

media as (
    SELECT md.username,
           FLOOR(
               COALESCE(md.like_count, 0) * 0.164 +
               COALESCE(md.comments_count, 0) * 0.297 +
               COALESCE(md.saved, 0) * 0.539 /
               md.followers_count * 10000
           ) AS score,
           md.like_count,
           md.comments_count,
           md.saved,
           COALESCE(md.shares, 0) AS shares,
           COALESCE(md.like_count, 0) + COALESCE(md.comments_count, 0) + COALESCE(md.saved, 0) + COALESCE(shares, 0) AS engagement,
           COALESCE(md.plays, 0) AS plays,
           COALESCE(md.reach, 0) AS reach,
           COALESCE(md.impressions, 0) AS impressions,
           md.permalink,
           md.id,
           md.media_url,
           md.media_type,
           md.timestamp AS date
    FROM stg_media_2 as md
)

-- Final CTE above

SELECT *
FROM media as md