with dau as (
  select
    event_date,
    count(distinct user_sk) as dau
  from {{ ref('fct_user_activity') }}
  group by 1
),

deltas as (
  select
    event_date,
    dau,
    lag(dau) over (order by event_date) as prev_dau,
    (dau - lag(dau) over (order by event_date))::float
      / nullif(lag(dau) over (order by event_date), 0) as pct_change
  from dau
)

select
  event_date,
  dau,
  prev_dau,
  pct_change,
  case
    when prev_dau is null then false
    when abs(pct_change) >= 0.5 then true
    else false
  end as is_anomaly,
  case
    when prev_dau is null then null
    when pct_change >= 0.5 then 'spike'
    when pct_change <= -0.5 then 'drop'
    else null
  end as anomaly_type
from deltas
order by event_date
