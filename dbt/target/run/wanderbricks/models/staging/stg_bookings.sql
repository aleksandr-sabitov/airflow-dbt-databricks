
  
  
  create or replace view `lakehouse`.`dev_staging`.`stg_bookings`
  
  as (
    with source as (
    select * from `samples`.`wanderbricks`.`bookings`
),

renamed as (
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
    from source
)

select * from renamed
  )
