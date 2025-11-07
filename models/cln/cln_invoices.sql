{{
 config(materialized='incremental',
 schema='cln',
 unique_key='DocumentNumber',
 on_schema_change='sync'
)
 }}

-- incremental load from bronze do cln aka Silver
-- set PK for increment

select
  ltrim(rtrim(DocumentNumber)) as InvoiceNumber,
  CustomerId,
  try_convert(date, PostingDate, 104) as PostingDate,
  try_convert(decimal(18,2), Amount) as Amount,
  LoadDate,
  SourceFile
    from {{ source('cln_sources', 'invoices_stg') }}

-- incremental load by tech column
{% if is_incremental() %}
  where LoadDate > (select max(LoadDate) from {{ this }})
{% endif %}

{{ log("Model " ~ this.name ~ " finished.", info=True) }}

