with
    user_lifetime_insights as (
        select page_id, metric, business_account_id, value
        from `begin-data.instagram_raw.user_lifetime_insights`
    )

select *
from user_lifetime_insights
