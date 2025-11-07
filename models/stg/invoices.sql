{{ config(materialized='table', schema='stg', alias='invoices') }}

{{ load_raw_to_stage(this.identifier) }}
