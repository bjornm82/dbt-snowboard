
    
    

select
    ID as unique_field,
    count(*) as n_records

from "postgres"."public_marketing"."second_model"
where ID is not null
group by ID
having count(*) > 1


