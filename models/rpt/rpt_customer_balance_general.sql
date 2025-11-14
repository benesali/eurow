{{ config(
    materialized='table',
    schema='rpt'
) }}
-- base
with invoice_status as (
    select
        InvoiceNumber,
        CustomerId,
        PostingDate,
        invoice_amount,
        total_paid,
        total_remaining,
        invoice_status
    from {{ ref('rpt_invoice_status') }}
),

cust as (
    select
        CustomerId,
        CustomerName,
        CustomerCategory
    from {{ ref('cln_customers') }}
),

customer_agg as (
    select
        i.CustomerId,
        c.CustomerName,
        c.CustomerCategory,
        sum(i.invoice_amount)     as total_invoices,
        sum(i.total_paid)         as total_paid,
        sum(i.total_remaining)    as total_remaining,
        count(case when i.invoice_status = 'OPEN'    then 1 end) as open_invoices,
        count(case when i.invoice_status = 'PAID'    then 1 end) as paid_invoices,
        count(case when i.invoice_status = 'PARTIAL' then 1 end) as partial_invoices

    from invoice_status i
    left join cust c on i.CustomerId = c.CustomerId
    group by
        i.CustomerId,
        c.CustomerName,
        c.CustomerCategory
),

-- flag na zaklade poctu zaplacenych/nezaplacenych faktur
customer_final as (
    select
        *,
        case
            when open_invoices = 0 and partial_invoices = 0 then 'FULLY_PAID'
            when open_invoices > 0                         then 'OPEN'
            when partial_invoices > 0                     then 'PARTIAL'
            else 'UNKNOWN'
        end as customer_payment_status,

        case
            when open_invoices = 0 and partial_invoices = 0 then 1
            else 0
        end as customer_fully_paid_flag

    from customer_agg
)

select *
from customer_final
order by CustomerId
