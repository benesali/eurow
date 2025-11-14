{{ config(materialized='table', schema='rpt') }}

-- hlavni zaklada: faktury + statusy
with invoice as (
    select
        i.InvoiceNumber,
        i.CustomerId,
        i.CompanyId,
        i.CountryId,
        i.DocumentType,
        i.PostingDate,
        i.invoice_amount,
        i.total_paid,
        i.total_remaining,
        i.invoice_status,
        date_trunc('month', i.PostingDate) as invoice_month
    from {{ ref('rpt_invoice_status') }} i
),

cust as (
    select
        CustomerId,
        CustomerName,
        CustomerCategory
    from {{ ref('cln_customers') }}
)

select
    invoice.*,
    cust.CustomerName,
    cust.CustomerCategory
from invoice
left join cust using (CustomerId)
