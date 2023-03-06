
  create or replace   view BJORN_TEST_UNIT.public_marketing.marketing_second_model
  
   as (
    -- Use the `ref` function to select from other models

select *
from BJORN_TEST_UNIT.public_marketing.aliased_model
where id = 1
  );

