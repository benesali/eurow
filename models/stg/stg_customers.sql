{{ config(materialized='table', schema='stg', alias='customers') }}

{{ load_raw_to_stage(this.identifier) }}