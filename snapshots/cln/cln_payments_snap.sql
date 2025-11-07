{% snapshot payments_snapshot %}
{{
    config(
        target_schema='snapshots_cln',
        unique_key='CustomerId',
        strategy='check',
        check_cols=['CustomerId', 'Amount', 'InvoiceNumber', 'PostingDate'],
        invalidate_hard_deletes=True
    )
}}

{{ snapshot_select('cln_payments') }}

{{ log("Snapshot  " ~ this ~ " created.", info=True) }}

{% endsnapshot %}
