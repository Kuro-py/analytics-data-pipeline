with u as (
  select * from {{ ref('int_user_activity_unified') }}
),

sm as (
  select * from {{ ref('dim_source') }}
),

um as (
  select * from {{ ref('dim_user') }}
)

select
  md5(
    coalesce(u.user_id,'') || '|' ||
    coalesce(u.source_name,'') || '|' ||
    coalesce(u.event_name,'') || '|' ||
    coalesce(u.event_timestamp::text,'')
  ) as event_id,

  um.user_sk,
  sm.source_id,

  u.user_id,
  u.source_name,

  u.event_name,
  u.event_timestamp,
  u.event_date,

  u.email,
  u.campaign_id,
  u.utm_source,
  u.marketing_value,

  u.country,
  u.device,
  u.platform,
  u.locale,

  u.attributes_json,
  u.ingested_at

from u
left join sm on sm.source_name = u.source_name
left join um on um.user_id = u.user_id
