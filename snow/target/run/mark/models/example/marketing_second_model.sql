
  create or replace view
    postgresql.public_marketing.marketing_second_model
  security definer
  as
    -- Use the `ref` function to select from other models

select *
from postgresql.public_marketing.aliased_model
where id = 1
  ;
