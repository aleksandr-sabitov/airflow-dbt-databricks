
with stg_bookings as (
    select * from {{ ref('stg_bookings') }}
)

select
    booking_id,
    user_id,
    property_id,
    check_in,
    check_out,
    total_amount,
    status,
    created_at,
    updated_at
from stg_bookings
