with web as (
  select * from {{ ref('stg_activity_web') }}
),
mobile as (
  select * from {{ ref('stg_activity_mobile') }}
),
marketing as (
  select * from {{ ref('stg_activity_marketing') }}
)

select
  user_id,
  source_name,
  event_name,
  event_timestamp,
  event_date,

  null::text as email,
  null::text as campaign_id,
  null::text as utm_source,
  null::double precision as marketing_value,

  country,
  device,
  null::text as platform,
  null::text as locale,

  attributes_json,
  ingested_at
from web

union all

select
  user_id,
  source_name,
  event_name,
  event_timestamp,
  event_date,

  null::text as email,
  null::text as campaign_id,
  null::text as utm_source,
  null::double precision as marketing_value,

  null::text as country,
  null::text as device,
  platform,
  locale,

  attributes_json,
  ingested_at
from mobile

union all

select
  user_id,
  source_name,
  event_name,
  event_timestamp,
  event_date,

  email,
  campaign_id,
  utm_source,
  marketing_value,

  null::text as country,
  null::text as device,
  null::text as platform,
  null::text as locale,

  null::jsonb as attributes_json,
  ingested_at
from marketing
