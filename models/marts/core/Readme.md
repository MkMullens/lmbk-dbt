# Dimension Table: dim_ga4__client_keys

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources 
- ETL Diagram
- Contact

## Overview

This document details the Comprehensive User Session Analytics table, which is structured to collect extensive data about user sessions from start to end. It includes information on geographical location, device specifics, user behavior, and campaign details. The table is crucial for in-depth analysis of user interactions on a digital platform.

## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
| 	client_key	| 	String	| 	Unique identifier for the client	| 
| 	first_event	| 	String	| 	Identifier of the first event in the session	| 
| 	last_event	| 	String	| 	Identifier of the last event in the session	| 
| 	stream_id	| 	String	| 	Stream ID associated with the session	| 
| 	first_geo_continent	| 	String	| 	Continent recorded at the first event	| 
| 	first_geo_country	| 	String	| 	Country recorded at the first event	| 
| 	first_geo_region	| 	String	| 	Region recorded at the first event	| 
| 	first_geo_city	| 	String	| 	City recorded at the first event	| 
| 	first_geo_sub_continent	| 	String	| 	Sub-continent recorded at the first event	| 
| 	first_geo_metro	| 	String	| 	Metro area recorded at the first event	| 
| 	first_device_category	| 	String	| 	Category of the device used in the first event	| 
| 	first_device_mobile_brand_name	| 	String	| 	Mobile brand name recorded at the first event	| 
| 	first_device_mobile_model_name	| 	String	| 	Mobile model name recorded at the first event	| 
| 	first_device_mobile_marketing_name	| 	String	| 	Marketing name of the mobile device recorded	| 
| 	first_device_mobile_os_hardware_model	| 	String	| 	Hardware model of the mobile OS recorded	| 
| 	first_device_operating_system	| 	String	| 	Operating system of the device used	| 
| 	first_device_operating_system_version	| 	String	| 	Version of the operating system used	| 
| 	first_device_vendor_id	| 	String	| 	Vendor ID of the first device	| 
| 	first_device_advertising_id	| 	String	| 	Advertising ID of the first device	| 
| 	first_device_language	| 	String	| 	Language setting of the first device	| 
| 	first_device_is_limited_ad_tracking	| 	String	| 	Indicates if ad tracking is limited on the first device	| 
| 	first_device_time_zone_offset_seconds	| 	Integer	| 	Time zone offset in seconds of the first device	| 
| 	first_device_browser	| 	String	| 	Browser used on the first device	| 
| 	first_device_browser_version	| 	String	| 	Browser version on the first device	| 
| 	first_device_web_info_browser	| 	String	| 	Web browser information of the first device	| 
| 	first_device_web_info_browser_version	| 	String	| 	Web browser version information of the first device	| 
| 	first_device_web_info_hostname	| 	String	| 	Hostname as per the first device's web info	| 
| 	first_user_campaign	| 	String	| 	First campaign attributed to the user	| 
| 	first_user_medium	| 	String	| 	Medium attributed to the first user interaction	| 
| 	first_user_source	| 	String	| 	Source attributed to the first user interaction	| 
| 	last_geo_continent	| 	String	| 	Last recorded continent of the user	| 
| 	last_geo_country	| 	String	| 	Last recorded country of the user	| 
| 	last_geo_region	| 	String	| 	Last recorded region of the user	| 
| 	last_geo_city	| 	String	| 	Last recorded city of the user	| 
| 	last_geo_sub_continent	| 	String	| 	Last recorded sub-continent of the user	| 
| 	last_geo_metro	| 	String	| 	Last recorded metro area of the user	| 
| 	last_device_category	| 	String	| 	Category of the user's last device	| 
| 	last_device_mobile_brand_name	| 	String	| 	Mobile brand name of the user's last device	| 
| 	last_device_mobile_model_name	| 	String	| 	Mobile model name of the user's last device	| 
| 	last_device_mobile_marketing_name	| 	String	| 	Marketing name of the user's last mobile device	| 
| 	last_device_mobile_os_hardware_model	| 	String	| 	Hardware model of the last mobile OS	| 
| 	last_device_operating_system	| 	String	| 	Operating system of the user's last device	| 
| 	last_device_operating_system_version	| 	String	| 	Operating system version of the user's last device	| 
| 	last_device_vendor_id	| 	String	| 	Vendor ID of the user's last device	| 
| 	last_device_advertising_id	| 	String	| 	Advertising ID of the user's last device	| 
| 	last_device_language	| 	String	| 	Language setting of the user's last device	| 
| 	last_device_is_limited_ad_tracking	| 	String	| 	Indicates if ad tracking is limited on the last device	| 
| 	last_device_time_zone_offset_seconds	| 	Integer	| 	Time zone offset in seconds of the last device	| 
| 	last_device_browser	| 	String	| 	Browser used on the user's last device	| 
| 	last_device_browser_version	| 	String	| 	Browser version on the user's last device	| 
| 	last_device_web_info_browser	| 	String	| 	Web browser information of the last device	| 
| 	last_device_web_info_browser_version	| 	String	| 	Web browser version information of the last device	| 
| 	last_device_web_info_hostname	| 	String	| 	Hostname as per the last device's web info	| 
| 	last_user_campaign	| 	String	| 	Last campaign attributed to the user	| 
| 	last_user_medium	| 	String	| 	Medium attributed to the last user interaction	| 
| 	last_user_source	| 	String	| 	Source attributed to the last user interaction	| 
| 	first_page_location	| 	String	| 	URL of the first page visited	| 
| 	first_page_hostname	| 	String	| 	Hostname of the first page visited	| 
| 	first_page_referrer	| 	String	| 	Referrer of the first page visited	| 
| 	last_page_location	| 	String	| 	URL of the last page visited	| 
| 	last_page_hostname	| 	String	| 	Hostname of the last page visited	| 
| 	last_page_referrer	| 	String	| 	Referrer of the last page visited	| 




## Usage Examples

Provide examples of how this table can be used. For instance:

1. Analyzing the entire user journey, from the first to the last interaction within the session.
2. Evaluating user preferences in terms of devices and browsers used for accessing the platform.
3. Understanding geographical distribution and language preferences of users.
4. Assessing the effectiveness of marketing campaigns from initial to final user interaction.


## Data Sources and ETL Process

Data Source : lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# Dimension Table: dim_ga4__sessions

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources and ETL Process
- Contact

## Overview

This document provides details about the dimension table dim_ga4__sessions, which is instrumental in storing session-based analytics data. It focuses on user sessions, device information, geographical data, and more, offering a comprehensive view of user interactions and behaviors.

## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	session_key	|	String	|	Unique identifier for a session	|
|	session_start_date	|	Date	|	Date when the session started	|
|	session_start_timestamp	|	Integer	|	Timestamp marking the start of the session	|
|	landing_page_path	|	String	|	Path of the landing page	|
|	landing_page	|	String	|	URL of the landing page	|
|	landing_page_hostname	|	String	|	Hostname of the landing page	|
|	landing_page_referrer	|	String	|	Referrer URL of the landing page	|
|	geo_continent	|	String	|	Continent of the user	|
|	geo_country	|	String	|	Country of the user	|
|	geo_region	|	String	|	Region of the user	|
|	geo_city	|	String	|	City of the user	|
|	geo_sub_continent	|	String	|	Sub-continent of the user	|
|	geo_metro	|	String	|	Metro area of the user	|
|	stream_id	|	String	|	Stream ID associated with the session	|
|	platform	|	String	|	Platform used for the session	|
|	device_category	|	String	|	Category of the device used	|
|	device_mobile_brand_name	|	String	|	Mobile brand name	|
|	device_mobile_model_name	|	String	|	Mobile model name	|
|	device_mobile_marketing_name	|	String	|	Marketing name of the mobile device	|
|	device_mobile_os_hardware_model	|	String	|	Hardware model of the mobile OS	|
|	device_operating_system	|	String	|	Operating system of the device	|
|	device_operating_system_version	|	String	|	Version of the device operating system	|
|	device_vendor_id	|	String	|	Vendor ID of the device	|
|	device_advertising_id	|	String	|	Advertising ID of the device	|
|	device_language	|	String	|	Language set on the device	|
|	device_is_limited_ad_tracking	|	String	|	Indicates if ad tracking is limited on the device	|
|	device_time_zone_offset_seconds	|	Integer	|	Time zone offset in seconds	|
|	device_browser	|	String	|	Browser used on the device	|
|	device_web_info_browser	|	String	|	Web browser information	|
|	device_web_info_browser_version	|	String	|	Browser version information	|
|	device_web_info_hostname	|	String	|	Hostname as per the device's web info	|
|	session_number	|	Integer	|	Number of the session	|
|	is_first_session	|	Boolean	|	Indicates if this is the first session	|
|	user_campaign	|	String	|	Campaign attributed to the user	|
|	user_medium	|	String	|	Medium attributed to the user	|
|	user_source	|	String	|	Source attributed to the user	|
|	session_source	|	String	|	Source of the session	|
|	session_medium	|	String	|	Medium of the session	|
|	session_campaign	|	String	|	Campaign related to the session	|
|	session_content	|	String	|	Content related to the session	|
|	session_term	|	String	|	Terms associated with the session	|
|	session_default_channel_grouping	|	String	|	Default channel grouping of the session	|
|	session_source_category	|	String	|	Source category of the session	|




## Usage Examples

1. Analyzing user sessions to understand user engagement patterns.
2. Tracking landing page effectiveness based on user geographical location and device usage.
3. Segmenting users based on the devices and platforms they use to access the service.
4. Understanding user acquisition channels through session source, medium, and campaign data.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# Dimension Table: dim_ga4__sessions_daily

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

This document outlines the structure and use of the dim_ga4__sessions_daily table, designed for tracking and analyzing session-based web analytics data. It includes detailed session information, user device and geographical data, and marketing campaign details, providing a comprehensive dataset for user behavior analysis.

## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	stream_id	|	String	|	Stream ID associated with the session	|
|	session_key	|	String	|	Unique identifier for a session	|
|	session_partition_key	|	String	|	Key for partitioning session data	|
|	session_partition_date	|	Date	|	Date for partitioning session data	|
|	session_partition_start_timestamp	|	Integer	|	Timestamp for the start of the session partition	|
|	landing_page_path	|	String	|	Path of the landing page	|
|	landing_page_location	|	String	|	Location of the landing page	|
|	landing_page_hostname	|	String	|	Hostname of the landing page	|
|	referrer	|	String	|	Referring URL	|
|	geo_continent	|	String	|	Continent of the user	|
|	geo_country	|	String	|	Country of the user	|
|	geo_region	|	String	|	Region of the user	|
|	geo_city	|	String	|	City of the user	|
|	geo_sub_continent	|	String	|	Sub-continent of the user	|
|	geo_metro	|	String	|	Metro area of the user	|
|	platform	|	String	|	Platform used for the session	|
|	device_category	|	String	|	Category of the device used	|
|	device_mobile_brand_name	|	String	|	Mobile brand name	|
|	device_mobile_model_name	|	String	|	Mobile model name	|
|	device_mobile_marketing_name	|	String	|	Marketing name of the mobile device	|
|	device_mobile_os_hardware_model	|	String	|	Hardware model of the mobile OS	|
|	device_operating_system	|	String	|	Operating system of the device	|
|	device_operating_system_version	|	String	|	Version of the device operating system	|
|	device_vendor_id	|	String	|	Vendor ID of the device	|
|	device_advertising_id	|	String	|	Advertising ID of the device	|
|	device_language	|	String	|	Language set on the device	|
|	device_is_limited_ad_tracking	|	String	|	Indicates if ad tracking is limited on the device	|
|	device_time_zone_offset_seconds	|	Integer	|	Time zone offset in seconds	|
|	device_browser	|	String	|	Browser used on the device	|
|	device_web_info_browser	|	String	|	Web browser information	|
|	device_web_info_browser_version	|	String	|	Browser version information	|
|	device_web_info_hostname	|	String	|	Hostname as per the device's web info	|
|	user_campaign	|	String	|	Campaign attributed to the user	|
|	user_medium	|	String	|	Medium attributed to the user	|
|	user_source	|	String	|	Source attributed to the user	|
|	session_source	|	String	|	Source of the session	|
|	session_medium	|	String	|	Medium of the session	|
|	session_campaign	|	String	|	Campaign related to the session	|
|	session_content	|	String	|	Content related to the session	|
|	session_term	|	String	|	Terms associated with the session	|
|	session_default_channel_grouping	|	String	|	Default channel grouping of the session	|
|	session_source_category	|	String	|	Source category of the session	|
|	last_non_direct_source	|	String	|	Last non-direct source of the session	|
|	last_non_direct_medium	|	String	|	Last non-direct medium of the session	|
|	last_non_direct_campaign	|	String	|	Last non-direct campaign of the session	|
|	last_non_direct_content	|	String	|	Last non-direct content of the session	|
|	last_non_direct_term	|	String	|	Last non-direct term of the session	|
|	last_non_direct_default_channel_grouping	|	String	|	Last non-direct default channel grouping of session	|
|	last_non_direct_source_category	|	String	|	Last non-direct source category of the session	|





## Usage Examples

1. Analyzing user journey and behavior by tracking session paths and referrer sources.
2. Segmenting users based on geographical and device data for targeted marketing.
3. Measuring the effectiveness of marketing campaigns through various session-related metrics.
4. Understanding user engagement and preferences through device and platform usage.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# FACT Table: fct_ga4__client_keys

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

This document provides a comprehensive overview of the fct_ga4__client_keys, which is designed to aggregate and store user interaction data. This fact table is a central component of the data warehouse, serving as a repository for quantitative and detailed user interaction metrics.



## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	client_key	|	String	|	Unique identifier for each client	|
|	stream_id	|	String	|	Stream ID associated with the data	|
|	first_seen_timestamp	|	Integer	|	Timestamp of the first recorded event	|
|	first_seen_start_date	|	Date	|	Start date of the first recorded event	|
|	count_pageviews	|	Integer	|	Total number of pageviews in the session	|
|	count_engaged_sessions	|	Integer	|	Number of engaged sessions	|
|	sum_event_value_in_usd	|	Float	|	Total value of events in USD	|
|	sum_engaged_time_msec	|	Integer	|	Total engaged time in milliseconds	|
|	count_sessions	|	Integer	|	Total number of sessions	|






## Usage Examples

1. Analyzing user engagement and interaction patterns over different timeframes.
2. Calculating key performance indicators like average session duration, pageviews per session, and user retention.
3. Segmenting users based on engagement levels and interaction types for targeted marketing strategies.
4. Generating reports on the effectiveness of online campaigns in terms of user engagement and conversion.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# FACT Table: fct_ga4__pages

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

This document details the structure and usage of the Web Analytics Data table. This fact table is crucial for storing and analyzing web page interactions, user engagement, and session metrics. It captures detailed information about page views, unique client interactions, and engagement times.



## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	event_date_dt	|	Date	|	Date of the event	|
|	stream_id	|	String	|	Stream ID associated with the data	|
|	page_location	|	String	|	URL of the page	|
|	page_path	|	String	|	Path of the page	|
|	page_title	|	String	|	Title of the web page	|
|	page_views	|	Integer	|	Number of views the page received	|
|	distinct_client_keys	|	Integer	|	Number of distinct clients who viewed the page	|
|	new_client_keys	|	Integer	|	Number of new clients who viewed the page	|
|	entrances	|	Integer	|	Number of times the page was an entry point	|
|	total_engagement_time_msec	|	Float	|	Total time spent by users on the page (in msec)	|
|	avg_engagement_time_denominator	|	Integer	|	Denominator for calculating average engagement time	|
|	scroll_events	|	Integer	|	Number of scroll events on the page	|




## Usage Examples

1. Analyzing page popularity and user engagement through page views and engagement times.
2. Tracking the effectiveness of specific pages as entry points to the website.
3. Understanding user behavior through scroll event metrics.
4. Identifying trends in user interaction over time and optimizing web content accordingly.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# FACT Table: fct_ga4__sessions

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

The User Session Analytics table is designed to capture and analyze user interaction within sessions. This fact table collects data on each user's session, tracking page views, event values, engagement metrics, and session details. It's instrumental for understanding user behavior on a website or application.



## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	client_key	|	String	|	Unique identifier for each client	|
|	session_key	|	String	|	Unique identifier for each session	|
|	stream_id	|	String	|	Stream ID associated with the session data	|
|	user_id	|	String	|	Unique identifier for each user	|
|	session_start_timestamp	|	Integer	|	Timestamp marking the start of the session	|
|	session_start_date	|	Date	|	Date when the session started	|
|	count_pageviews	|	Integer	|	Total number of pageviews in the session	|
|	sum_event_value_in_usd	|	Float	|	Total value of events in USD during the session	|
|	is_session_engaged	|	Integer	|	Indicator of whether the session was engaged (1 or 0)	|
|	sum_engaged_time_msec	|	Integer	|	Total engaged time in milliseconds	|
|	session_number	|	Integer	|	Sequence number of the session for a client	|





## Usage Examples

1. Tracking and analyzing user engagement across different sessions.
2. Calculating the average session duration and identifying trends in user behavior.
3. Evaluating the effectiveness of web pages or features in terms of engagement and event values.
4. Understanding user pathways through session start times, pageviews, and engagement data.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# FACT Table: fct_ga4__sessions_daily

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

The Session Partition Analytics table is structured to track and analyze detailed aspects of user sessions, including page views, user engagement, and session values. This fact table is key for understanding user interaction over different session partitions, offering insights into session dynamics and user behavior.



## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	session_key	|	String	|	Unique identifier for each session	|
|	session_partition_key	|	String	|	Key for partitioning session data	|
|	client_key	|	String	|	Unique identifier for each client	|
|	stream_id	|	String	|	Stream ID associated with the session data	|
|	user_id	|	String	|	Unique identifier for each user	|
|	session_partition_date	|	Date	|	Date for partitioning session data	|
|	session_partition_min_timestamp	|	Integer	|	Minimum timestamp in the session partition	|
|	session_partition_count_page_views	|	Integer	|	Total number of pageviews in the session partition	|
|	session_partition_sum_event_value_in_usd	|	Float	|	Sum of event values in USD in the session partition	|
|	session_partition_max_session_engaged	|	Integer	|	Maximum engagement indicator in the session partition	|
|	session_partition_sum_engagement_time_msec	|	Integer	|	Total engagement time in milliseconds in the session partition	|
|	session_number	|	Integer	|	Sequence number of the session for a client	|






## Usage Examples

1. Analyzing user engagement trends and patterns within specific session partitions.
2. Evaluating the performance of web pages based on partitioned page view counts and engagement times.
3. Understanding the value generated from user interactions in different session partitions.
4. Assessing user behavior through session start times, engagement indicators, and session longevity.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# FACT Table: fct_ga4__user_ids

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

This document outlines the structure and purpose of the User and Client Session Analytics table. This fact table is designed to record and analyze both user and client sessions, encompassing metrics such as page views, engagement sessions, event values, and session times. It plays a crucial role in understanding user behavior, client interaction, and overall engagement on the platform.



## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	user_id_or_client_key	|	String	|	Unified identifier for users or clients	|
|	stream_id	|	String	|	Stream ID associated with the session data	|
|	is_user_id	|	Integer	|	Indicator if the ID is a user ID (1) or client key (0)	|
|	first_seen_timestamp	|	Integer	|	Timestamp of the first recorded event	|
|	first_seen_start_date	|	Date	|	Start date of the first recorded event	|
|	count_pageviews	|	Integer	|	Total number of pageviews in the session	|
|	count_engaged_sessions	|	Integer	|	Number of engaged sessions	|
|	sum_event_value_in_usd	|	Float	|	Total value of events in USD during the session	|
|	sum_engaged_time_msec	|	Integer	|	Total engaged time in milliseconds	|
|	count_sessions	|	Integer	|	Total number of sessions	|



## Usage Examples

1. Differentiating between user and client interactions within the same platform.
2. Analyzing first interaction times and dates to understand user and client engagement patterns.
3. Evaluating the effectiveness of content and features based on engagement metrics like pageviews and session counts.
4. Determining the monetary value of engagement through event values in USD.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*

# FACT Table: fct_user_journey

## Table of Contents

- Overview
- Schema
- Usage Examples
- Data Sources
- ETL Diagram
- Contact

## Overview

This document describes the structure and functionality of the Web Analytics and User Interactions table. This fact table captures a comprehensive range of data related to user activities on a website, including session details, campaign information, device usage, and geographic location. It is essential for analyzing user behavior, campaign effectiveness, and overall engagement with web content.



## Schema


|   Field Name                        |      Data Type         | Description     								|
|-------------------------------------|------------------------|------------------------------------------------|
|	event_date	|	Date	|	Date of the user event	|
|	event_timestamp	|	Timestamp	|	Timestamp when the event occurred	|
|	session_id	|	Integer	|	Unique identifier for the session	|
|	user_pseudo_id	|	String	|	Pseudonymized user identifier	|
|	event_name	|	String	|	Name of the event	|
|	campaign_name	|	String	|	Name of the campaign	|
|	manual_source	|	String	|	Source of the traffic manually set	|
|	manual_medium	|	String	|	Medium of the traffic manually set	|
|	gclid	|	String	|	Google Click Identifier	|
|	dclid	|	String	|	Google Display Ads Click Identifier	|
|	srsltid	|	String	|	Search result slot ID	|
|	fbclid	|	String	|	Facebook Click Identifier	|
|	country	|	String	|	User's country	|
|	continent	|	String	|	User's continent	|
|	region	|	String	|	User's region	|
|	sub_continent	|	String	|	User's sub-continent	|
|	category	|	String	|	Category of the event	|
|	mobile_brand_name	|	String	|	Brand name of the user's mobile device	|
|	mobile_model_name	|	String	|	Model name of the user's mobile device	|
|	operating_system	|	String	|	Operating system of the user's device	|
|	operating_system_version	|	String	|	Version of the operating system	|
|	language	|	String	|	Language preference of the user	|
|	browser	|	String	|	Browser used by the user	|
|	hostname	|	String	|	Hostname of the website	|
|	purchase_revenue_in_usd	|	Float	|	Revenue from the purchase in USD	|
|	visit_id	|	Integer	|	Unique identifier for the visit	|
|	visit_number	|	Integer	|	Sequence number of the visit	|
|	page_title	|	String	|	Title of the page visited	|
|	page_location	|	String	|	URL of the page visited	|
|	page_title_adjusted	|	String	|	Adjusted title of the page visited	|
|	page_rank	|	Integer	|	Rank of the page	|
|	previous_page	|	String	|	Title of the previous page visited	|
|	next_page	|	String	|	Title of the next page visited	|
|	last_page_rank	|	Integer	|	Rank of the last page in the session	|
|	screens_on_a_visit	|	String	|	Screens viewed during a visit	|
|	unique_key	|	Integer	|	Unique key for the record	|




## Usage Examples

1. Analyzing user interaction patterns with website content through event tracking.
2. Measuring the effectiveness of online marketing campaigns.
3. Understanding user demographics and device preferences.
4. Tracking user journey through the website, including entry and exit points.

## Data Sources  
Data Source: lmbk-ga4-bigquery.analytics_310142291.events_intraday_*
