{{ config(
    materialized='incremental',
    schema='cln',
    unique_key='InvoiceNumber'
) }}

-- Inkrementální načítání z bronze do cln aka Silver pro PostgreSQL

select
    trim(DocumentNumber) as InvoiceNumber,
    trim(CustomerId) as CustomerId,
    CAST(PostingDate AS DATE) as PostingDate,
    CAST(Amount AS DECIMAL(18,2)) as Amount,
    CURRENT_TIMESTAMP as LoadDate
from {{ source('stg', 'invoices') }}
where DocumentNumber is not null

{% if is_incremental() %}
  and CURRENT_TIMESTAMP > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Model " ~ this.name ~ " finished successfully.", info=True) }}
