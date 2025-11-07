{{ config(materialized='ephemeral', alias='debug_test') }}

{% set alias = model.config.get('alias') if model.config.get('alias') else 'N/A' %}

{{ log("--------------------------------------------------------", info=True) }}
{{ log(" DBT MODEL CONTEXT DIAGNOSTIC", info=True) }}
{{ log("--------------------------------------------------------", info=True) }}
{{ log("Model name: " ~ this.name, info=True) }}
{{ log("Model identifier: " ~ this.identifier, info=True) }}
{{ log("Model alias (from config): " ~ alias, info=True) }}
{{ log("Model schema: " ~ this.schema, info=True) }}
{{ log("Model database: " ~ this.database, info=True) }}
{{ log("Full path (database.schema.identifier): " ~ this.database ~ '.' ~ this.schema ~ '.' ~ this.identifier, info=True) }}
{{ log("--------------------------------------------------------", info=True) }}

select
    '{{ this.name }}' as model_name,
    '{{ this.identifier }}' as model_identifier,
    '{{ alias }}' as model_alias,
    '{{ this.schema }}' as model_schema,
    '{{ this.database }}' as model_database
