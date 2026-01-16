with src as (
  select
    *,
    to_timestamp(cast(ts as bigint) / 1000.0) as event_timestamp
  from {{ source('landing', 'user_activity_source_b_mobile') }}
)

select
  nullif(trim(cast(uid as text)), '') as user_id,
  'mobile' as source_name,
  nullif(trim(cast(action as text)), '') as event_name,

  event_timestamp,
  cast((event_timestamp at time zone 'UTC') as date) as event_date,

  nullif(trim(cast(platform as text)), '') as platform,
  nullif(trim(cast(locale as text)), '') as locale,

  case
    when attrs is null then null::jsonb
    else jsonb_build_object('attrs_raw', cast(attrs as text))
  end as attributes_json,

  current_timestamp::timestamptz as ingested_at

from src
where nullif(trim(cast(uid as text)), '') is not null
  and nullif(trim(cast(action as text)), '') is not null
  and event_timestamp is not null
  and cast((event_timestamp at time zone 'UTC') as date) <= current_date
