
  
    
        create or replace table `lakehouse`.`dev_star_schema`.`fct_bookings`
      
      
    using delta
  
      
      
      
      
      
      
      
      as
      with stg_bookings as (
    select * from `lakehouse`.`dev_staging`.`stg_bookings`
)

select
    booking_id,
    user_id,
    property_id,
    check_in,
    check_out,
    guests_count,
    total_amount,
    status,
    created_at,
    updated_at
from stg_bookings
  