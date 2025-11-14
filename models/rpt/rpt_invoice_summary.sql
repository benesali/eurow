{{ config(materialized='table', schema='rpt') }}

-- agregovani poctu faktur, soucty castek za mesic a poctu zakazniku pro status
select
    date_trunc('month', i.PostingDate) as invoice_month,
    i.invoice_status,
    count(distinct i.CustomerId) as unique_customers,
    count(distinct i.InvoiceNumber) as invoice_count,
    sum(i.invoice_amount) as total_invoiced,
    sum(i.total_paid) as total_paid,
    sum(i.total_remaining) as total_remaining
from {{ ref('rpt_invoice_status') }} i
group by
1, 2
order by
1, 2
