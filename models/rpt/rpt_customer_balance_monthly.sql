{{ config(materialized='table', schema='rpt') }}
-- agreguj zakaznika na mesicni bazi
-- pocty jakych faktur, zbytky
select
    i.CustomerId,
    c.CustomerName,
    c.CustomerCategory,
    date_trunc('month', i.PostingDate) as invoice_month,
    sum(i.invoice_amount) as total_invoices,
    sum(i.total_paid) as total_paid,
    sum(i.total_remaining) as total_remaining,
    count(case when i.invoice_status = 'OPEN' then 1 end) as open_invoices,
    count(case when i.invoice_status = 'PAID' then 1 end) as paid_invoices,
    count(case when i.invoice_status = 'PARTIAL' then 1 end) as partial_invoices
from {{ ref('rpt_invoice_status') }} i
left join {{ ref('cln_customers') }} c using (CustomerId)
group by
   1,2,3,4
