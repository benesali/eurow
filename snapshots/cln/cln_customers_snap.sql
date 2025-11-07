{% snapshot customers_snapshot %}
{{
    config(
        target_schema='snapshots_cln',
        unique_key='CustomerId',
        strategy='check',
        check_cols= ['CustomerName', 'CustomerCategory'],
        invalidate_hard_deletes=True  -- demo setup
    )
}}

{{ snapshot_select('cln_customers') }}

{{ log("Snapshot  " ~ this ~ " created.", info=True) }}
{% endsnapshot %}
