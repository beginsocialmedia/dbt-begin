WITH user_lifetime_insights AS (
    SELECT page_id,
           metric,
           business_account_id,
           "value"
    FROM begin_db.instagram_raw.user_lifetime_insights
)

SELECT *
FROM user_lifetime_insights