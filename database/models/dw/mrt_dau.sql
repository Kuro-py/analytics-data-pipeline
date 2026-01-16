select
  event_date,
  count(distinct user_sk) as dau
from {{ ref('fct_user_activity') }}
group by 1
order by 1
