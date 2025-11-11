{{ config(
    materialized='table',
    schema='cln',
    unique_key='PaymentNumber'
) }}

select
    trim(DocumentNumber) as PaymentNumber,
    trim(CustomerId) as CustomerId,
    trim(InvoiceNumber) as InvoiceNumber,
    trim(InvoiceEntry) as InvoiceEntry,
    CAST(PostingDate AS DATE) as PostingDate,
    CAST(Amount AS DECIMAL(18,2)) as Amount,
    CURRENT_TIMESTAMP as LoadDate
from {{ source('stg', 'payments') }}
where DocumentNumber is not null
