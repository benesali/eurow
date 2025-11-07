{{ config(materialized='table', schema='stg',  alias='payments') }}

{{ load_raw_to_stage(this.identifier) }}
