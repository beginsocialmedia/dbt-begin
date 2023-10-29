WITH user_insights AS (
    SELECT u.username,
           COALESCE(ui.reach, 0) AS reach,
           COALESCE(ui.impressions, 0) AS impressions,
           COALESCE(ui.website_clicks, 0) AS website_clicks,
           COALESCE(ui.profile_views, 0) AS profile_views,
           COALESCE(ui. follower_count) AS follower_count,
           "date"
    FROM `begin-data.instagram_raw.users` AS u
    LEFT JOIN `begin-data.instagram_raw.user_insights` AS ui
    ON u.id = ui.business_account_id
)
SELECT *
FROM user_insights