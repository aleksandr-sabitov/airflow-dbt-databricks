
  
    
        create or replace table `lakehouse`.`dev_datamarts`.`dm_monthly_bookings`
      
      
    using delta
  
      
      
      
      
      
      comment 'Aggregated monthly bookings with property details and user metrics'
      
      as
      with bookings as (
    select * from `lakehouse`.`dev_star_schema`.`fct_bookings`
),

properties as (
    select * from `lakehouse`.`dev_star_schema`.`dim_properties`
),

users as (
    select * from `lakehouse`.`dev_star_schema`.`dim_users`
),

joined as (
    select
        date_trunc('month', bookings.check_in) as booking_month,
        properties.title as property_title,
        properties.property_type,
        bookings.total_amount,
        bookings.user_id
    from bookings
    left join properties on bookings.property_id = properties.property_id
),

aggregated as (
    select
        booking_month,
        property_title,
        property_type,
        count(distinct user_id) as unique_users,
        count(*) as total_bookings,
        sum(total_amount) as total_revenue,
        avg(total_amount) as avg_booking_amount,
        min(total_amount) as min_booking_amount,
        max(total_amount) as max_booking_amount
    from joined
    group by 1, 2, 3
)

select * from aggregated
  