
  create view "postgres"."public_marketing"."marketing_second_model__dbt_tmp" as (
    -- Use the `ref` function to select from other models

select *
from "postgres"."public_marketing"."aliased_model"
where id = 1
  );