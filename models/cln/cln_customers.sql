{{ config(
    materialized='incremental',
    schema='cln',
    unique_key='CustomerId'
) }}

-- Inkrementální load z bronze do cln aka Silver pro PostgreSQL

with base as (
    select
        trim(CustomerId) as CustomerId,
        trim(CustomerName) as CustomerName,
        upper(trim(CustomerCategory)) as CustomerCategory,
        CURRENT_TIMESTAMP as LoadDate
    from {{ source('stg', 'customers') }}
    where CustomerId is not null
),

-- dedup podle priority kategorie (GOLD > SILVER > BRONZE)
ranked as (
    select *,
        case
            when CustomerCategory = 'GOLD' then 3
            when CustomerCategory = 'BRONZE' then 1
            else 0
        end as CategoryRank
    from base
),


dedup as (
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
    CustomerCategory
from dedup

-- Inkrementální načítání: pouze nové nebo aktualizované záznamy
{% if is_incremental() %}
where LoadDate > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Transformation of " ~ this.identifier ~ " finished OK.", info=True) }}
