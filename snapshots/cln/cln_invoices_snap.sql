{% snapshot invoices_snapshot %}
{{
    config(
        target_schema='snapshots_cln',
        unique_key='DocumentNumber',
        strategy='check',
        check_cols=['DocumentType', 'PostingDate', 'Amount'],
        invalidate_hard_deletes=True 
    )
}}

{{ snapshot_select('cln_invoices') }}

{{ log("Snapshot  " ~ this ~ " created.", info=True) }}
{% endsnapshot %}