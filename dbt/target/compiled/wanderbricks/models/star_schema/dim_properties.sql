with stg_properties as (
    select * from `lakehouse`.`dev_staging`.`stg_properties`
)

select
    property_id,
    host_id,
    destination_id,
    title,
    description,
    base_price,
    property_type,
    max_guests,
    bedrooms,
    bathrooms,
    property_latitude,
    property_longitude,
    created_at
from stg_properties