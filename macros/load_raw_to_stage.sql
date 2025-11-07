-- universal macro for loading raw data to stage
{% macro load_raw_to_stage(model_name) %}
    {% set table = model_name ~ '_raw' %}
    select * from {{ source('stg', table) }}
    {{ log("Stage loaded: " ~ table, info=True) }}
{% endmacro %}