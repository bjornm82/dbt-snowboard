-- Use the `ref` function to select from other models

select *
from postgresql.public_marketing.aliased_model
where id = 1