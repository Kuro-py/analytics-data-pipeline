with src as (
  select distinct user_id
  from {{ ref('int_user_activity_unified') }}
)

select
  row_number() over (order by user_id) as user_sk,
  user_id
from src
