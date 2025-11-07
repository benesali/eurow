{{ config(
    materialized='incremental',
    schema='cln',
    unique_key='CustomerId',
    on_schema_change='sync'

) }}
-- incremental load from bronze do cln aka Silver
-- set PK for increment

with base as (
    select
        ltrim(rtrim(CustomerId)) as CustomerId,
        ltrim(rtrim(CustomerName)) as CustomerName,
        upper(ltrim(rtrim(CustomerCategory))) as CustomerCategory,
        LoadDate,
        SourceFile
    from {{ source('stg', 'customers_raw') }}
    where CustomerId is not null
)

select
    CustomerId,
    CustomerName,
    CustomerCategory,
    LoadDate,
    SourceFile
from base

-- incremental load by tech column 
{% if is_incremental() %}
where LoadDate > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Transformation of " ~ this.identifier ~ " finished OK.", info=True) }}
