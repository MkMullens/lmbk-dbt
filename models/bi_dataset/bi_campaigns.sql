{{ config(materialized='table')}}

Select 
  o.event_date 
  , CASE WHEN event_name = "session_start" THEN page_title ELSE NULL END AS landing_page
  , CASE WHEN event_name = "page_view" THEN 1 ELSE NULL END AS page_view
  , CASE WHEN visit_number = 1 THEN "New User" ELSE "Returning User" END AS user_type
  , CASE WHEN event_name =  "user_engagement" THEN o.session_id ELSE NULL END AS user_engagement
  , CASE 
      WHEN campaign_name like ('%organic%') then "organic"
      else campaign_name
    end as campaign_name

  , case 
      when campaign_name not like ("%organic%") 
        and event_name = "click" 
        and manual_source like ("%instagram%") 
        and manual_medium = "cpc"
      then user_id else null 
    end as instagram_cpc
  , case 
      when campaign_name not like ("%organic%") 
        and event_name = "click" 
        and manual_source like ("%tiktok%") 
        and manual_medium = "cpc"
      then user_id else null 
    end as tiktok_cpc
 
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
  , o.user_id as User_ID
  , purchase_revenue_in_usd as Transaction_Amount
FROM {{ref('fct_user_journey')}} as o 
--where campaign_name not like ('%test%')






