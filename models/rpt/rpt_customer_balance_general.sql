{{ config(materialized='table', schema='rpt') }}

select
    i.CustomerId,
    c.CustomerName,
    c.CustomerCategory,
    count(case when i.invoice_status = 'OPEN' then 1 end) as open_invoices,
    count(case when i.invoice_status = 'PAID' then 1 end) as paid_invoices,
    count(case when i.invoice_status = 'PARTIAL' then 1 end) as partial_invoices,
    sum(i.invoice_amount) as total_invoiced,
    sum(i.total_paid) as total_paid,
    sum(i.total_remaining) as total_remaining
from {{ ref('rpt_invoice_status') }} i
left join {{ ref('cln_customers') }} c using (CustomerId)
group by 1,2,3
