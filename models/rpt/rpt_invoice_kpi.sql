{{ config(materialized='table', schema='rpt') }}

select
    date_trunc('month', PostingDate) as invoice_month,
    sum(invoice_amount) as total_invoiced,
    sum(total_paid) as total_paid,
    sum(total_remaining) as total_remaining
from {{ ref('rpt_invoice_status') }}
group by 1
order by 1
