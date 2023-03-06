
    
    

select
    ID as unique_field,
    count(*) as n_records

from BJORN_TEST_UNIT.public_marketing.marketing_second_model
where ID is not null
group by ID
having count(*) > 1


