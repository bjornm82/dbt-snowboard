{{ config(materialized='table') }}

select
    1 as customer_id,
    'My Best Customer' as customer_name