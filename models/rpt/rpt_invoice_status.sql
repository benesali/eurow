{{ config(materialized='table', schema='rpt') }}

-- co bylo vyfakturováno a co chybí uhradit, neuvidime nezaplacene faktury
-- spocitej zustatky z plateb v payments dle Invoice Number
with
payments_per_invoice as (
    select
        p.InvoiceNumber,
        sum(p.Amount) as total_paid
    from {{ ref('cln_payments') }} p
    group by p.InvoiceNumber
)
-- zjisti zustaky na fakturach dle plateb a dopln status pro reporting
select
    i.InvoiceNumber,
    i.CustomerId,
    i.CompanyId,
    i.CountryId,
    i.DocumentType,
    i.PostingDate,
    i.Amount as invoice_amount,
    coalesce(p.total_paid, 0) as total_paid, --kdyz nejsou platby
    (i.Amount - coalesce(p.total_paid, 0)) as total_remaining,
    case
        when coalesce(p.total_paid, 0) = 0 then 'OPEN'
        when coalesce(p.total_paid, 0) < i.Amount then 'PARTIAL'
        when coalesce(p.total_paid, 0) >= i.Amount then 'PAID'
    end as invoice_status
from {{ ref('cln_invoices') }} i
left join payments_per_invoice p
  on i.InvoiceNumber = p.InvoiceNumber
