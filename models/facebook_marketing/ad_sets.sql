WITH ad_sets AS (
    SELECT
    ANY_VALUE(ads.account_name) AS account_name,
    ANY_VALUE(adsets.account_id) AS account_id,
    ANY_VALUE(ads.campaign_name) AS campaign_name,
    ANY_VALUE(ads.campaign_id) AS campaign_id,
    ANY_VALUE(adsets.name) AS ad_set_name,
    adsets.id AS ad_set_id,
    ANY_VALUE(adsets.start_time) AS start_time,
    ANY_VALUE(adsets.effective_status) AS effective_status,
FROM
    facebook_marketing_raw.ad_sets adsets
JOIN
    facebook_marketing_raw.ads_insights ads ON adsets.campaign_id = ads.campaign_id
GROUP BY
    adsets.id
)

SELECT *
FROM ad_sets