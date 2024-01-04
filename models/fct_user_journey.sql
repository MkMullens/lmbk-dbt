{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}

{{ config(
    materialized='incremental',
    unique_key='unique_key'
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
)
, unnested_events AS (
  SELECT
    session_id,
    event_date AS date,
    event_timestamp AS event_timestamp_microseconds,
    user_pseudo_id,
    event_name,
    collected_traffic_source.manual_campaign_name campaign_name,
    collected_traffic_source.manual_source manual_source,
    collected_traffic_source.manual_medium manual_medium,
    collected_traffic_source.gclid gclid,
    collected_traffic_source.dclid dclid,
    collected_traffic_source.srsltid srsltid,
    CASE WHEN LOWER(collected_traffic_source.manual_source) LIKE '%facebook%' OR LOWER(collected_traffic_source.manual_source) LIKE '%instagram%' THEN
  REGEXP_EXTRACT(
    CASE WHEN c.key = 'page_location' THEN c.value.string_value END, 
    r'[?&]fbclid=([^&]*)'
  ) END fbclid,
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
    

  FROM 
    base_table,
    UNNEST (event_params) c
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
SELECT DISTINCT
  CAST(FORMAT_DATE('%Y-%m-%d', PARSE_DATE('%Y%m%d', date)) AS DATE) AS event_date
  ,CAST(PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%E6S', FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%E6S', TIMESTAMP_MICROS(event_timestamp_microseconds))) AS TIMESTAMP) AS event_timestamp
  ,* EXCEPT(date, event_timestamp_microseconds)
  ,FARM_FINGERPRINT(CONCAT(COALESCE(CAST(event_timestamp_microseconds AS STRING),''),COALESCE(CAST(session_id AS STRING),''),COALESCE(event_name,''),COALESCE(user_pseudo_id,''),COALESCE(CAST(date AS STRING),''),COALESCE(fbclid,''),COALESCE(gclid,'')))   unique_key
FROM 
  screen_summary_agg
WHERE session_id IS NOT NULL