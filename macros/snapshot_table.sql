{% macro snapshot_table(snapshot_name, model_name, unique_key, check_cols) %}
{% snapshot {{ snapshot_name }} %}
{{
    config(
        target_schema='snapshots_cln',
        unique_key=unique_key,
        strategy='check',
        check_cols=check_cols,
        invalidate_hard_deletes=True
    )
}}

select * from {{ ref(model_name) }}

{{ log("Snapshot '" ~ snapshot_name ~ "' created for model '" ~ model_name ~ "'.", info=True) }}

{% endsnapshot %}
{% endmacro %}
