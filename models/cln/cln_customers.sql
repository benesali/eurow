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
        LoadDate,
        SourceFile
    from {{ source('cln_sources', 'customers_stg') }}
    where CustomerId is not null
)

-- deduplikace
, dedup as (
    select *
    from (
        select *,
               row_number() over (partition by CustomerId order by LoadDate desc) as rn
        from base
    ) t
    where rn = 1
)

select
    CustomerId,
    CustomerName,
    CustomerCategory,
    LoadDate,
    SourceFile
from dedup

{% if is_incremental() %}
where LoadDate > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Transformation of " ~ this.identifier ~ " finished OK.", info=True) }}
