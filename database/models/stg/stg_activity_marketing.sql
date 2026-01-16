with src as (
  select *
  from {{ source('landing', 'user_activity_source_c_marketin') }}
),

parsed as (
  select
    *,
    case
      /* 1. DD/MM/YYYY HH:MM:SS +0100 */
      when trim(activity_timestamp) ~ '^\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2} [+-]\d{4}$'
        then (
          regexp_replace(
            trim(activity_timestamp),
            '^(\d{2})/(\d{2})/(\d{4}) (\d{2}:\d{2}:\d{2}) ([+-]\d{2})(\d{2})$',
            '\3-\2-\1 \4\5:\6'
          )
        )::timestamptz

      /* 2. Month DD, YYYY HH:MM AM/PM BST */
      when trim(activity_timestamp) ilike '% BST'
        then (
          replace(trim(activity_timestamp), ' BST', '')::timestamp
          at time zone 'Europe/London'
        )

      /* 3. Month DD, YYYY HH:MM AM/PM CEST */
      when trim(activity_timestamp) ilike '% CEST'
        then (
          replace(trim(activity_timestamp), ' CEST', '')::timestamp
          at time zone 'Europe/Paris'
        )

      else null::timestamptz
    end as event_timestamp
  from src
)

select
  nullif(trim(cast(user_id as text)), '') as user_id,
  'marketing' as source_name,
  nullif(trim(cast(activity_type as text)), '') as event_name,

  event_timestamp,
  cast((event_timestamp at time zone 'UTC') as date) as event_date,

  nullif(trim(cast(email as text)), '') as email,
  nullif(trim(cast(campaign_id as text)), '') as campaign_id,
  nullif(trim(cast(utm_source as text)), '') as utm_source,
  cast(value as double precision) as marketing_value,

  current_timestamp::timestamptz as ingested_at

from parsed
where nullif(trim(cast(user_id as text)), '') is not null
  and nullif(trim(cast(activity_type as text)), '') is not null
  and event_timestamp is not null
  and cast((event_timestamp at time zone 'UTC') as date) <= current_date
