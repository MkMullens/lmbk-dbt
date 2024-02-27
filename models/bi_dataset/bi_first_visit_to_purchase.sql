{{ config(materialized='table')}}





With purchase_users AS (
SELECT distinct user_id, event_name 
FROM   {{ref('fct_user_journey')}} 
Where event_name = 'purchase'
-- AND user_id =  'g3LehWYGVG+Yp3L2i7I+9H+vsF7MvIgPPZX0rWuV0Rg=.1707442546'
 ),
 session_counts AS (
Select user_id , Count(distinct session_id) as sessions
FROM   {{ref('fct_user_journey')}} 
Where user_id IN (select distinct user_id from purchase_users)
Group by 1

 )


SELECT *
,CASE WHEN days_diff = 0 THEN '0'
        WHEN days_diff >= 1 AND days_diff <= 7 THEN '1-7'
        WHEN days_diff >=8 AND days_diff <=14 THEN '8-14'
        WHEN days_diff >=15 AND days_diff <=28 THEN '15-28'
        WHEN days_diff >=29 AND days_diff <= 60 THEN '29-60'
        WHEN days_diff >=61 AND days_diff <= 120 THEN '61-120'
        WHEN days_diff > 120 THEN '120+'
        END as days_to_purchase_category
,CASE WHEN days_diff = 0 THEN 1
        WHEN days_diff >= 1 AND days_diff <= 7 THEN 2
        WHEN days_diff >=8 AND days_diff <=14 THEN  3
        WHEN days_diff >=15 AND days_diff <=28 THEN 4
        WHEN days_diff >=29 AND days_diff <= 60 THEN  5
        WHEN days_diff >=61 AND days_diff <= 120 THEN 6
        WHEN days_diff > 120 THEN 7
        END as days_to_purchase_category_rank







,CASE WHEN sessions = 1 THEN '1'
      WHEN sessions >=2 AND sessions <=5 THEN '2-5'
      WHEN sessions >=6 AND sessions <=10 THEN '6-10'
      WHEN sessions >=11 AND sessions <=15 THEN '11-15'
      WHEN sessions >= 16 AND sessions <=20 THEN '16-20'
      WHEN sessions >=21 THEN '21+'
      END as sessions_to_purchase_category
,CASE WHEN sessions = 1 THEN 1
      WHEN sessions >=2 AND sessions <=5 THEN 2
      WHEN sessions >=6 AND sessions <=10 THEN  3
      WHEN sessions >=11 AND sessions <=15 THEN 4
      WHEN sessions >= 16 AND sessions <=20 THEN 5
      WHEN sessions >=21 THEN 6
      END as sessions_to_purchase_category_rank
FROM
(Select * 
,  DATE_DIFF(purchase_date,first_visit_date,DAY) as days_diff
FROM(
Select user_id , MIN(purchase_date) as purchase_date , MIN(first_visit_date) as first_visit_date , MAX(manual_source) as manual_source, MAX(sub.campaign_name) as campaign_name , MAX(manual_medium) as manual_medium , MAX(sub.campaign_name_p) as campaign_name_p , MAX(manual_medium_p) as manual_medium_p, MAX(manual_source_p) as manual_source_p, SUM(sub.sessions) as sessions, ROUND(SUM(sub.Transaction_Amount),2) as Transaction_Amount
FROM (Select uj.user_id
-- ,event_date
, CASE WHEN event_name = 'first_visit' THEN campaign_name ELSE NULL END AS campaign_name
, CASE WHEN event_name = 'first_visit' THEN manual_medium ELSE NULL END as manual_medium
, CASE WHEN event_name = "first_visit" then manual_source END as manual_source
, CASE WHEN event_name = 'purchase' THEN campaign_name ELSE NULL END AS campaign_name_p
, CASE WHEN event_name = 'purchase' THEN manual_medium ELSE NULL END as manual_medium_p
, CASE WHEN event_name = "purchase" then manual_source END as manual_source_p
, CASE WHEN event_name = 'purchase' THEN event_date ELSE NULL END AS purchase_date
, CASE WHEN event_name = 'first_visit' THEN event_date ELSE NULL END AS first_visit_date
, sc.sessions
, purchase_revenue_in_usd as Transaction_Amount

-- ,  DATE_DIFF(purchase_date,first_visit_date,DAY) as days_diff
FROM   {{ref('fct_user_journey')}}  as uj
LEFT JOIN session_counts as sc ON sc.user_id = uj.user_id
WHERE 1=1
AND uj.user_id IN (select user_id FROM purchase_users)
AND event_name IN ('purchase' , 'first_visit')) as sub
Group by 1))

