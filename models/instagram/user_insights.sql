with
    user_insights as (
        select
            u.username,
            coalesce(ui.reach, 0) as reach,
            coalesce(ui.impressions, 0) as impressions,
            coalesce(ui.website_clicks, 0) as website_clicks,
            coalesce(ui.profile_views, 0) as profile_views,
            coalesce(ui.follower_count) as follower_count,
            date
        from `begin-data.instagram_raw.users` as u
        left join
            `begin-data.instagram_raw.user_insights` as ui
            on u.id = ui.business_account_id
    )
select *
from user_insights
