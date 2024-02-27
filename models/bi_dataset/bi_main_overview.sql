{{ config(materialized='table')}}

Select o.event_date 
, CASE WHEN event_name = "session_start" THEN page_title ELSE NULL END AS landing_page
, CASE WHEN event_name = "page_view" THEN 1 ELSE NULL END AS page_view
, CASE WHEN visit_number = 1 THEN "New User" ELSE "Returning User" END AS user_type
, CASE WHEN event_name =  "user_engagement" THEN o.user_id ELSE NULL END AS user_engagement
, CASE WHEN event_name = 'purchase' THEN 1 ELSE NULL END AS purchase_transaction
, manual_medium 
, manual_source 
, mobile_brand_name
, mobile_model_name
, operating_system
, operating_system_version
, region
, country
, category as Device_Category
, page_location 
, page_title
, o.session_id as Session
-- , m.user_pseudo_id as User_ID
, o.user_id as User_ID
, purchase_revenue_in_usd as Transaction_Amount
FROM {{ref('fct_user_journey')}} as o 
-- LEFT JOIN `lmbk-ga4-bigquery.dbt_development.dim_ga4__user_session_mapping` as m ON m.session_id = o.session_id -- removed
--WHERE o.event_date = '2024-02-12'-- BETWEEN '2024-01-08' AND '2024-01-14'
WHERE 1=1
--AND campaign_name NOT LIKE '%test%'
-- Group by 1 ,2,3,4,5,6,7,8,9


