with d as (
  select distinct event_date, user_sk
  from {{ ref('fct_user_activity') }}
)
select
  d1.event_date,
  (
    select count(distinct user_sk)
    from d d2
    where d2.event_date between d1.event_date - interval '6 day' and d1.event_date
  ) as wau
from (select distinct event_date from d) d1
order by 1
