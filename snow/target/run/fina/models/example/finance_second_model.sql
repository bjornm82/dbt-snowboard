
  create view "postgres"."public_finance"."finance_second_model__dbt_tmp" as (
    select *
from "postgres"."public_finance"."finance_first_model"
  );