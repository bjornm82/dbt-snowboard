
  create view "postgres"."public_finance"."first_model__dbt_tmp" as (
    -- Use the `ref` function to select from other models



select *
from "postgres"."public_marketing"."first_model"
where id = 1
  );