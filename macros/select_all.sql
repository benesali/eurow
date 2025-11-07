{% macro select_all(model_name) %}
select * from {{ ref(model_name) }}
{% endmacro %}