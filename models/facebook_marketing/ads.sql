WITH stg_ads AS (
    SELECT
      JSON_EXTRACT(creative, '$.id') AS creative_id
    FROM
      facebook_marketing_raw.ads
),
stg_ads_2 AS (
    WITH data AS (
        SELECT id,
               url,
               JSON_EXTRACT_ARRAY(images.creatives, '$') AS creative_image
        FROM facebook_marketing_raw.images
    )
    SELECT id,
           url,
           creative
    FROM data, UNNEST(data.creative_image) as creative
),
ads AS (
    SELECT 
        stg_ads_2.id AS image_id,
        stg_ads_2.url AS image_url,
        stg_ads_2.creative
    FROM stg_ads
    JOIN stg_ads_2 ON stg_ads.creative_id = ARRAY_TO_STRING([stg_ads_2.id], '')
)

SELECT *
FROM ads