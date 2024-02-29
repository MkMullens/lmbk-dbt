{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}

{{ config(
    materialized='incremental',
    unique_key='unique_key',
    post_hook ='''
    UPDATE lmbk-ga4-bigquery.dbt_development.fct_user_journey TGT
    SET
        TGT.user_id = SRC.user_id
    FROM(
        SELECT
            unique_key
            ,user_id
        FROM(
        SELECT
            A.unique_key
            ,COALESCE(B.user_pseudo_id,C.user_pseudo_id,A.user_pseudo_id) user_id
            ,ROW_NUMBER() OVER(PARTITION BY unique_key ORDER BY B.event_timestamp DESC) R
        FROM lmbk-ga4-bigquery.dbt_development.fct_user_journey A
        LEFT JOIN
            lmbk-ga4-bigquery.dbt_development.dim_ga4__user_session_mapping B
        ON A.session_id = B.session_id
        LEFT JOIN
            lmbk-ga4-bigquery.dbt_development.dim_ga4__user_session_mapping C
        ON A.user_pseudo_id = C.user_pseudo_id
    )
    WHERE R=1
    ) SRC
    WHERE SRC.unique_key = TGT.unique_key;
    '''
) }}

WITH base_table AS (
  SELECT
    (
      SELECT ev.value.int_value FROM UNNEST(event_params) ev WHERE ev.key = 'ga_session_id') session_id,
    event_name,
    event_date,
    event_timestamp,
    user_pseudo_id,
    user_id,
    device,
    geo,
    traffic_source,
    event_params,
    user_properties,
    collected_traffic_source,
    geo.country as country,
    geo.continent as continent ,
    geo.region as region ,
    geo.sub_continent as sub_continent,
    device.category as category ,
    device.mobile_brand_name as mobile_brand_name ,
    device.mobile_model_name as mobile_model_name,
    device.operating_system as operating_system,
    device.operating_system_version as operating_system_version ,
    device.language as language,
    device.web_info.browser as browser ,
    device.web_info.hostname as hostname ,
    ecommerce.purchase_revenue_in_usd as purchase_revenue_in_usd
    
  FROM
    {{ source('ga4', 'events') }}
    {% if is_incremental() %}
       where cast( replace(_table_suffix, 'intraday_', '') as int64) >= {{var('start_date')}}
        and parse_date('%Y%m%d', left( replace(_table_suffix, 'intraday_', ''), 8)) in ({{ partitions_to_replace | join(',') }})
    {% endif %}
),
campaigns_url AS (
  SELECT * FROM(
  SELECT DISTINCT
    session_id
    ,REGEXP_EXTRACT(CASE WHEN c.key = 'page_location' THEN c.value.string_value END, r'[?&]utm_campaign=([^&]*)') utm_campaign
    ,REGEXP_EXTRACT(CASE WHEN c.key = 'page_location' THEN c.value.string_value END, r'[?&]utm_source=([^&]*)') utm_source
    ,REGEXP_EXTRACT(CASE WHEN c.key = 'page_location' THEN c.value.string_value END, r'[?&]utm_medium=([^&]*)') utm_medium
    ,REGEXP_EXTRACT(
    CASE WHEN c.key = 'page_location' THEN c.value.string_value END, 
    r'[?&]fbclid=([^&]*)'
  ) fbclid
  ,ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY event_timestamp) R
  FROM 
    base_table,
    UNNEST (event_params) c
  WHERE c.key = 'page_location'
  )
  WHERE R=1
)
, unnested_events AS (
  SELECT
    A.session_id,
    event_date AS date,
    event_timestamp AS event_timestamp_microseconds,
    user_pseudo_id,
    event_name,
    COALESCE(collected_traffic_source.manual_campaign_name,D.utm_campaign) AS campaign_name,
    COALESCE(collected_traffic_source.manual_source,D.utm_source) AS manual_source,
    COALESCE(collected_traffic_source.manual_medium,D.utm_medium) AS manual_medium,
    collected_traffic_source.gclid gclid,
    collected_traffic_source.dclid dclid,
    collected_traffic_source.srsltid srsltid,
    D.fbclid,
    country,
    continent ,
    region ,
    sub_continent,
    category ,
    mobile_brand_name ,
    mobile_model_name,
    operating_system,
    operating_system_version ,
    language,
    browser ,
    hostname ,
    purchase_revenue_in_usd,
    MAX(CASE WHEN c.key = 'ga_session_id' THEN c.value.int_value END) AS visit_id,
    MAX(CASE WHEN c.key = 'ga_session_number' THEN c.value.int_value END) AS visit_number,
    MAX(CASE WHEN c.key = 'page_title' THEN c.value.string_value END) AS page_title,
    MAX(CASE WHEN c.key = 'page_location' THEN c.value.string_value END) AS page_location,
    MAX(CASE WHEN c.key = 'page_referrer' THEN c.value.string_value END) AS page_referrer
    

  FROM 
    base_table A
    LEFT JOIN UNNEST (event_params) c
    LEFT JOIN campaigns_url D
    ON A.session_id = D.session_id
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
)

, unnested_events_categorised AS (
-- categorizing Page Titles into PDPs and PLPs
  SELECT
  *,
  CASE WHEN ARRAY_LENGTH(SPLIT(page_location, '/')) >= 5 
            AND
            CONTAINS_SUBSTR(ARRAY_REVERSE(SPLIT(page_location, '/'))[SAFE_OFFSET(0)], '+')
            AND (LOWER(SPLIT(page_location, '/')[SAFE_OFFSET(4)]) IN 
                                        ('accessories','apparel','brands','campus+collection','drinkware',
                                          'electronics','google+redesign',
                                          'lifestyle','nest','new+2015+logo','notebooks+journals',
                                          'office','shop+by+brand','small+goods','stationery','wearables'
                                          )
                  OR
                  LOWER(SPLIT(page_location, '/')[SAFE_OFFSET(3)]) IN 
                                        ('accessories','apparel','brands','campus+collection','drinkware',
                                          'electronics','google+redesign',
                                          'lifestyle','nest','new+2015+logo','notebooks+journals',
                                          'office','shop+by+brand','small+goods','stationery','wearables'
                                          )
            )
            THEN 'PDP'
            WHEN NOT(CONTAINS_SUBSTR(ARRAY_REVERSE(SPLIT(page_location, '/'))[SAFE_OFFSET(0)], '+'))
            AND (LOWER(SPLIT(page_location, '/')[SAFE_OFFSET(4)]) IN 
                                        ('accessories','apparel','brands','campus+collection','drinkware',
                                          'electronics','google+redesign',
                                          'lifestyle','nest','new+2015+logo','notebooks+journals',
                                          'office','shop+by+brand','small+goods','stationery','wearables'
                                          )
                  OR 
                  LOWER(SPLIT(page_location, '/')[SAFE_OFFSET(3)]) IN 
                                          ('accessories','apparel','brands','campus+collection','drinkware',
                                            'electronics','google+redesign',
                                            'lifestyle','nest','new+2015+logo','notebooks+journals',
                                            'office','shop+by+brand','small+goods','stationery','wearables'
                                            )
            )
            THEN 'PLP'
        ELSE page_title
        END AS page_title_adjusted 

  FROM 
    unnested_events
)

, ranked_screens AS (
  SELECT
    *,
    DENSE_RANK() OVER (PARTITION BY  user_pseudo_id, session_id ORDER BY event_timestamp_microseconds ASC) page_rank,
    LAG(page_title_adjusted,1) OVER (PARTITION BY  user_pseudo_id, session_id ORDER BY event_timestamp_microseconds ASC) previous_page,
    LEAD(page_title_adjusted,1) OVER (PARTITION BY  user_pseudo_id, session_id ORDER BY event_timestamp_microseconds ASC)  next_page
  FROM 
    unnested_events_categorised

)
, screen_summary AS (
  SELECT
    *,
    MAX(page_rank) OVER (PARTITION BY  user_pseudo_id, session_id) last_page_rank,
    ARRAY_AGG(page_title_adjusted) OVER (PARTITION BY  user_pseudo_id, session_id) pages_on_a_visit
  FROM 
    ranked_screens
)
, screen_summary_agg AS (

  SELECT * EXCEPT(pages_on_a_visit),

    ARRAY_TO_STRING(ARRAY(SELECT DISTINCT * FROM UNNEST(pages_on_a_visit) ORDER BY 1 ASC), '>>') AS screens_on_a_visit
  FROM 
    screen_summary
)
-- ORIGINALLY THIS INTERMEDIATE CTE WAS THE FINAL TABLE
, intermediate AS (

SELECT DISTINCT
  CAST(FORMAT_DATE('%Y-%m-%d', PARSE_DATE('%Y%m%d', date)) AS DATE) AS event_date
  ,CAST(PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%E6S', FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%E6S', TIMESTAMP_MICROS(event_timestamp_microseconds))) AS TIMESTAMP) AS event_timestamp
  ,* EXCEPT(date, event_timestamp_microseconds)
  ,FARM_FINGERPRINT(CONCAT(COALESCE(CAST(event_timestamp_microseconds AS STRING),''),COALESCE(CAST(session_id AS STRING),''),COALESCE(event_name,''),COALESCE(user_pseudo_id,''),COALESCE(CAST(date AS STRING),'')))   unique_key
  ,user_pseudo_id user_id
FROM 
  screen_summary_agg
WHERE session_id IS NOT NULL)

-- SESSION AGG is a cte where for each user_id a single session is being created. (the lastest session_id will be considered as the session)
, session_agg AS (


WITH ranked_sessions AS (
  SELECT distinct
    user_id,
    event_timestamp,
    session_id as session,
    event_date,
    RANK() OVER (PARTITION BY user_id, event_date ORDER BY event_timestamp DESC) AS session_rank
  FROM
    intermediate
)

SELECT
distinct
uj.*
, s.session

FROM
 intermediate as uj
 LEFT JOIN ranked_sessions as s ON s.user_id = uj.user_id AND uj.event_date = s.event_date
WHERE
  session_rank = 1
)
-- FINAL QUERY
-- USING THE PAGE REFF COLUMN CREATED EARLIER TO USE HERE
Select distinct * EXCEPT(page_referrer,manual_source, manual_medium)
,CASE WHEN manual_source = 'unknown' THEN  REGEXP_EXTRACT(page_referrer, r'\b(google|yahoo|linkedin|facebook|quant|instagram|reddit|ecosia|hotels\.cloudbed|upwork|bing|lmbksurfhouse)\b')  ELSE manual_source END as manual_source
, CASE WHEN manual_medium = 'unknown' AND page_referrer LIKE '%google%' THEN 'organic'
      WHEN manual_medium = 'unknown' AND page_referrer LIKE '%lmbksurfhouse.com%' THEN 'referral'
      WHEN manual_medium = 'unknown' AND page_referrer LIKE '%hotels.cloudbeds.com%' THEN 'referral'
  WHEN manual_medium = 'unknown' AND REGEXP_EXTRACT(page_referrer, r'\b(yahoo|linkedin|facebook|quant|instagram|reddit|ecosia|hotels\.cloudbed|upwork|bing)\b') IS NOT NULL THEN 'cpc' 
  ELSE manual_medium
END AS manual_medium
FROM session_agg