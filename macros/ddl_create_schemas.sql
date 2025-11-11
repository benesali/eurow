{% macro ddl_create_schemas() %}
  {% for schema_name in ['dbt_abenes_stg', 'snapshots_cln'] %}
    {% set sql %}
      CREATE SCHEMA IF NOT EXISTS {{ schema_name }}
    {% endset %}
    {{ run_query(sql) }}
    {{ log("Schema checked/created: " ~ schema_name, info=True) }}
  {% endfor %}
{% endmacro %}
