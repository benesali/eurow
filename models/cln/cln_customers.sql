{{ config(
    materialized='table',
    schema='cln',
    unique_key='CustomerId'
) }}

select
    trim(CustomerId) as CustomerId,
    trim(CustomerName) as CustomerName,
    upper(trim(CustomerCategory)) as CustomerCategory
from {{ source('stg', 'customers') }}
where CustomerId is not null
