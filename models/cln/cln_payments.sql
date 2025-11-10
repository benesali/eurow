{{ config(
    materialized='incremental',
    schema='cln',
    unique_key='PaymentNumber'
) }}

{{ log("Starting transform: " ~ this.identifier, info=True) }}

-- Inkrementální načítání z bronze do cln aka Silver pro PostgreSQL

select
    CompanyId,
    trim(CustomerId) as CustomerId,
    upper(trim(CountryId)) as CountryId,
    trim(DocumentNumber) as PaymentNumber,
    trim(DocumentType) as DocumentType,
    CAST(PostingDate AS DATE) as PostingDate,
    trim(Entry) as Entry,
    trim(EntryType) as EntryType,
    CAST(Amount AS DECIMAL(18,2)) as Amount,
    trim(InvoiceNumber) as InvoiceNumber,
    trim(InvoiceEntry) as InvoiceEntry,
    CURRENT_TIMESTAMP as LoadDate
from {{ source('stg', 'payments') }}
where DocumentNumber is not null

{% if is_incremental() %}
    and CURRENT_TIMESTAMP > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Transformation of " ~ this.identifier ~ " finished OK.", info=True) }}
