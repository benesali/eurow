{{ config(
    materialized='table',
    unique_key='InvoiceNumber'
) }}

select
    trim(DocumentNumber) as InvoiceNumber,
    trim(CustomerId) as CustomerId,
    CompanyId as CompanyId,
    trim(CountryId) as CountryId,
    trim(DocumentType) as DocumentType,
    CAST(PostingDate AS DATE) as PostingDate,
    CAST(Amount AS DECIMAL(18,2)) as Amount
from {{ source('stg', 'invoices') }}
where DocumentNumber is not null
