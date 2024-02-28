WITH master_sessions AS(
  SELECT * EXCEPT(R) FROM(
  SELECT session_id, user_pseudo_id
  ,ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY event_timestamp DESC) R
  FROM {{ref("fct_user_journey")}}
  )
  WHERE R = 1
),
sessions_info AS(
  SELECT DISTINCT
    A.* EXCEPT (user_pseudo_id)
    ,ROW_NUMBER() OVER(PARTITION BY B.user_pseudo_id ORDER BY event_timestamp DESC) current_to_first_ranking
    ,ROW_NUMBER() OVER(PARTITION BY B.user_pseudo_id ORDER BY event_timestamp ASC) first_to_current_ranking
    ,B.user_pseudo_id
  FROM {{ref("fct_user_journey")}} A
  INNER JOIN master_sessions B
  ON A.session_id = B.session_id
),
first_session_info AS(
  SELECT
    user_pseudo_id
    ,session_id
    ,campaign_name first_session_campaign
    ,manual_source first_session_source
    ,manual_medium first_session_medium
    ,country first_session_country
  FROM sessions_info
  WHERE first_to_current_ranking = 1
),
current_session_info AS(
  SELECT
    user_pseudo_id
    ,session_id
    ,event_name
    ,campaign_name current_session_campaign
    ,manual_source current_session_source
    ,manual_medium current_session_medium
    ,country current_session_country
    ,ROW_NUMBER() OVER(PARTITION BY user_pseudo_id ORDER BY event_timestamp DESC) R
  FROM sessions_info
  WHERE current_to_first_ranking = 1
),
purchase_info AS
(
  SELECT
    user_pseudo_id
    ,session_id
    ,COUNT(*) total_purchases
    ,SUM(purchase_revenue_in_usd) purchase_revenue_in_usd
  FROM
    sessions_info
  WHERE event_name = 'purchase'
  GROUP BY 1,2
),
this_session_matrices AS (
  SELECT
    user_pseudo_id
    ,session_id
    ,COUNT(*) this_session_events
    ,TIMESTAMP_DIFF(MAX(event_timestamp),MIN(event_timestamp),SECOND) this_session_time_sec
    ,COUNT(DISTINCT page_location) this_session_distinct_pages_visited
    ,COUNTIF(event_name = 'rooms_page_book_now') this_session_clicked_booking_page
  FROM
    sessions_info
  GROUP BY 1,2
),
all_sessions_matrices AS (
  SELECT
    user_pseudo_id,
    session_id,
    SUM(this_session_events) OVER (PARTITION BY user_pseudo_id ORDER BY session_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - this_session_events AS all_sessions_events,
    SUM(this_session_time_sec) OVER (PARTITION BY user_pseudo_id ORDER BY session_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - this_session_time_sec AS all_sessions_time_sec,
    SUM(this_session_distinct_pages_visited) OVER (PARTITION BY user_pseudo_id ORDER BY session_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - this_session_distinct_pages_visited AS all_sessions_distinct_pages_visited,
    SUM(this_session_clicked_booking_page) OVER (PARTITION BY user_pseudo_id ORDER BY session_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) - this_session_clicked_booking_page AS all_sessions_clicked_booking_page
  FROM
    this_session_matrices
),
prev_ranked_data AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp) as row_num,
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, manual_source ORDER BY event_timestamp) as row_num_src,
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, manual_medium ORDER BY event_timestamp) as row_num_med,
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, campaign_name ORDER BY event_timestamp) as row_num_cam
  FROM 
    sessions_info
  -- WHERE event_name = 'session_start'
),
prev_aggregated_data AS (
  SELECT 
    a.session_id,a.user_pseudo_id,
    ARRAY(
      SELECT DISTINCT session_id
      FROM prev_ranked_data b
      WHERE b.user_pseudo_id = a.user_pseudo_id AND b.row_num <= a.row_num
    ) as distinct_values,
    ARRAY(
      SELECT DISTINCT session_id
      FROM prev_ranked_data b
      WHERE b.user_pseudo_id = a.user_pseudo_id AND a.session_id = b.session_id AND a.manual_source = b.manual_source AND b.row_num <= a.row_num_src
    ) as distinct_values_manual_source
    ,
    ARRAY(
      SELECT DISTINCT session_id
      FROM prev_ranked_data b
      WHERE b.user_pseudo_id = a.user_pseudo_id AND  a.session_id = b.session_id AND a.manual_medium = b.manual_medium AND b.row_num <= a.row_num_med
    ) as distinct_values_manual_medium,
    ARRAY(
      SELECT DISTINCT session_id
      FROM prev_ranked_data b
      WHERE b.user_pseudo_id = a.user_pseudo_id AND   a.session_id = b.session_id AND a.campaign_name = b.campaign_name AND b.row_num <= a.row_num_cam
    ) as distinct_values_campaign_name
  FROM prev_ranked_data a
),
prev_sessions_matrices AS(
  SELECT DISTINCT
    session_id,
    user_pseudo_id,
    ARRAY_LENGTH(distinct_values)-1 as prev_number_of_sessions_total,
    ARRAY_LENGTH(distinct_values_manual_source)-1 as prev_number_of_sessions_manual_source,
    ARRAY_LENGTH(distinct_values_manual_medium)-1 as prev_number_of_sessions_manual_medium,
    ARRAY_LENGTH(distinct_values_campaign_name)-1 as prev_number_of_sessions_campaign_name
  FROM 
    prev_aggregated_data
    WHERE 
    ARRAY_LENGTH(distinct_values_manual_source) > 0 AND ARRAY_LENGTH(distinct_values_manual_medium) > 0 AND ARRAY_LENGTH(distinct_values_campaign_name) > 0
),
this_sessions_de_dup AS (
  SELECT
    user_pseudo_id
    ,session_id
    ,MAX(manual_source) manual_source
    ,MAX(manual_medium) manual_medium
    ,MAX(campaign_name) campaign_name
  FROM
    sessions_info
  GROUP BY 1,2
)
SELECT DISTINCT
  A.user_pseudo_id
  ,A.session_id this_session_id
  ,A.manual_source this_session_source
  ,A.manual_medium this_session_medium
  ,A.campaign_name this_session_campaign
  ,B.session_id first_session_id
  ,B.first_session_source
  ,B.first_session_medium
  ,B.first_session_campaign
  ,C.prev_number_of_sessions_total
  ,C.prev_number_of_sessions_manual_source
  ,C.prev_number_of_sessions_manual_medium
  ,C.prev_number_of_sessions_campaign_name
  ,D.this_session_events
  ,D.this_session_time_sec
  ,D.this_session_distinct_pages_visited
  ,D.this_session_clicked_booking_page
  ,E.all_sessions_events
  ,E.all_sessions_time_sec
  ,E.all_sessions_distinct_pages_visited
  ,E.all_sessions_clicked_booking_page
  ,CASE WHEN F.user_pseudo_id IS NULL THEN FALSE ELSE TRUE END is_purchased
  ,F.total_purchases
  ,F.purchase_revenue_in_usd
FROM
  this_sessions_de_dup A
LEFT JOIN first_session_info B ON A.user_pseudo_id = B.user_pseudo_id
LEFT JOIN prev_sessions_matrices C ON A.session_id = C.session_id AND A.user_pseudo_id = C.user_pseudo_id
LEFT JOIN this_session_matrices D ON A.session_id = D.session_id AND A.user_pseudo_id = D.user_pseudo_id
LEFT JOIN all_sessions_matrices E ON A.user_pseudo_id = E.user_pseudo_id AND A.session_id = E.session_id
LEFT JOIN purchase_info F ON A.session_id = F.session_id AND A.user_pseudo_id = F.user_pseudo_id