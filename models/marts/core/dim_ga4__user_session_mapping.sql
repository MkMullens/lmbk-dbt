{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}

{{ config(
    materialized='incremental',
    unique_key='unique_key'
) }}

WITH main_cte AS
(
  SELECT DISTINCT 
    ev.value.int_value session_id
    ,user_pseudo_id
    ,CAST(PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%E6S', FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%E6S', TIMESTAMP_MICROS(event_timestamp))) AS TIMESTAMP) AS event_timestamp
  FROM
    {{ source('ga4', 'events') }} A
  LEFT JOIN
    UNNEST(event_params) ev
  WHERE
    ev.key = 'ga_session_id'
	{% if is_incremental() %}
       and cast( replace(_table_suffix, 'intraday_', '') as int64) >= {{var('start_date')}}
        and parse_date('%Y%m%d', left( replace(_table_suffix, 'intraday_', ''), 8)) in ({{ partitions_to_replace | join(',') }})
    {% endif %}
)
SELECT *
FROM main_cte