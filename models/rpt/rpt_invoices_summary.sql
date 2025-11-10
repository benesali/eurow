{{ config(materialized='table', schema='rpt') }}

with invoice as (
    select
        i.InvoiceNumber,
        i.CustomerId,
        i.PostingDate,
        i.Amount as InvoicedAmount,
        coalesce(sum(p.Amount), 0) as PaidAmount,
        i.Amount - coalesce(sum(p.Amount), 0) as RemainingAmount
    from {{ ref('cln_invoices') }} i
    left join {{ ref('cln_payments') }} p
        on i.InvoiceNumber = p.InvoiceNumber
    group by i.InvoiceNumber, i.CustomerId, i.PostingDate, i.Amount
)

select
    i.CustomerId,
    c.CustomerName,
    c.CustomerCategory,
    i.PostingDate,
    sum(i.InvoicedAmount) as TotalInvoiced,
    sum(i.PaidAmount) as TotalPaid,
    sum(i.RemainingAmount) as TotalRemaining
from invoice i
left join {{ ref('cln_customers') }} c
    on i.CustomerId = c.CustomerId
group by i.CustomerId, c.CustomerName, c.CustomerCategory, i.PostingDate
