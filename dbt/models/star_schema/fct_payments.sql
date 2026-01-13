
with stg_payments as (
    select * from {{ ref('stg_payments') }}
)

select
    payment_id,
    booking_id,
    amount,
    payment_method,
    status,
    payment_date
from stg_payments
