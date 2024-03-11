WITH campaigns AS (
    SELECT
    ANY_VALUE(ads.account_name) AS account_name,
    ANY_VALUE(cmp.account_id) AS account_id,
    ANY_VALUE(cmp.name) AS campaign_name,
    cmp.id AS campaign_id,
    ANY_VALUE(cmp.status) AS status,
    ANY_VALUE(cmp.objective) AS objective,
    ANY_VALUE(cmp.start_time) AS start_time,
    ANY_VALUE(cmp.daily_budget) AS daily_budget,
    ANY_VALUE(cmp.effective_status) AS effective_status,
FROM
    facebook_marketing_raw.campaigns cmp
JOIN
    facebook_marketing_raw.ads_insights ads ON cmp.id = ads.campaign_id
GROUP BY
    cmp.id
)

SELECT *
FROM campaigns