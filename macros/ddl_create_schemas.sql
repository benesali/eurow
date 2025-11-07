{% macro ddl_create_schemas() %}
  {% for schema_name in ['stg', 'cln', 'rpt', 'snapshots_cln'] %}
    {% set sql %}
      IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '{{ schema_name }}')
      EXEC('CREATE SCHEMA {{ schema_name }}')
    {% endset %}
    {{ run_query(sql) }}
    {{ log("Schema checked/created: " ~ schema_name, info=True) }}
  {% endfor %}
{% endmacro %}
