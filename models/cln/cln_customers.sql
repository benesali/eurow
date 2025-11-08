{{ config(
    materialized='incremental',
    schema='cln',
    unique_key='CustomerId',
    on_schema_change='sync'
) }}

with base as (
    select
        ltrim(rtrim(CustomerId)) as CustomerId,
        ltrim(rtrim(CustomerName)) as CustomerName,
        upper(ltrim(rtrim(CustomerCategory))) as CustomerCategory,
        getdate() as LoadDate
    from {{ source('stg', 'customers') }}
    where CustomerId is not null
)

-- deduplikace, na zdroji neni cas, vezmeme vyssi partner ship
, ranked as (
    select *,
        case
            when CustomerCategory = 'GOLD' then 3
            when CustomerCategory = 'SILVER' then 2
            when CustomerCategory = 'BRONZE' then 1
            else 0
        end as CategoryRank
    from base
)
, dedup as (
    select *
    from (
        select *,
               row_number() over (
                   partition by CustomerId
                   order by CategoryRank desc
               ) as rn
        from ranked
    ) t
    where rn = 1
)

select
    CustomerId,
    CustomerName,
    CustomerCategory,
from dedup

{% if is_incremental() %}
where LoadDate > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Transformation of " ~ this.identifier ~ " finished OK.", info=True) }}
