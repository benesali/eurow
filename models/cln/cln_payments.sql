{{ config(
    materialized='incremental',
    schema='cln',
    alias='payments',
    unique_key='Entry',
    on_schema_change='sync'
) }}

-- incremental load from bronze do cln aka Silver
-- set PK for increment

{{ log("Starting transform: " ~ this.identifier, info=True) }}

with src as (
    select
        CompanyId,
        trim(CustomerId) as CustomerId,
        upper(trim(CountryId)) as CountryId,
        trim(DocumentNumber) as DocumentNumber,
        trim(DocumentType) as DocumentType,
        try_cast(PostingDate as date) as PostingDate,
        trim(Entry) as Entry,
        trim(EntryType) as EntryType,
        try_cast(Amount as decimal(18,2)) as Amount,
        trim(InvoiceNumber) as InvoiceNumber,
        trim(InvoiceEntry) as InvoiceEntry,
        LoadDate,
        SourceFile
    from {{ ref('payments') }}
    where CustomerId is not null
)

select *
from src

{% if is_incremental() %}
    where LoadDate > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Transformation of " ~ this.identifier ~ " finished OK.", info=True) }}
