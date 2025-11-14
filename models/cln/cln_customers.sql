{{ config(
    materialized='table',
    schema='cln'
) }}

with base as (
    select
        trim(CustomerId) as CustomerId,
        trim(CustomerName) as CustomerName,
        upper(trim(CustomerCategory)) as CustomerCategory,

        case
            when CustomerCategory = 'GOLD' then 1
            when CustomerCategory = 'SILVER' then 2
            when CustomerCategory = 'BRONZE' then 3
            else 4
        end as cat_rank
    from {{ source('stg', 'customers') }}
    where CustomerId is not null
),

ranked as (
    select
        *,
        row_number() over (
            partition by CustomerId
            order by cat_rank asc
        ) as rn
    from base
)

select
    CustomerId,
    CustomerName,
    CustomerCategory
from ranked
where rn = 1
