
  
    
        create or replace table `lakehouse`.`dev_star_schema`.`dim_users`
      
      
    using delta
  
      
      
      
      
      
      
      
      as
      with stg_users as (
    select * from `lakehouse`.`dev_staging`.`stg_users`
)

select
    user_id,
    email,
    name,
    country,
    user_type,
    created_at,
    is_business,
    company_name
from stg_users
  