
    
    

select
    id as unique_field,
    count(*) as n_records

from BJORN_TEST_UNIT.public_marketing.aliased_model
where id is not null
group by id
having count(*) > 1


