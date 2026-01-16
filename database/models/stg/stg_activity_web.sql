with src as (
  select * from {{ source('landing', 'user_activity_source_a_web') }}
),

typed as (
  select
    nullif(trim(cast(user_id as text)), '') as user_id,
    'website' as source_name,
    nullif(trim(cast(event as text)), '') as event_name,

    cast(event_time as timestamptz) as event_timestamp,
    cast((cast(event_time as timestamptz) at time zone 'UTC') as date) as event_date,

    nullif(trim(cast(country as text)), '') as country,
    nullif(trim(cast(device as text)), '') as device,

    case
      when properties is null then null::jsonb
      else cast(properties as jsonb)
    end as attributes_json,

    current_timestamp::timestamptz as ingested_at
  from src
)

select *
from typed
where user_id is not null
  and event_name is not null
  and event_timestamp is not null
  and cast((event_timestamp at time zone 'UTC') as date) <= current_date
