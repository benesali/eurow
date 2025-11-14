{% macro ddl_create_tables_stg() %}
  {{ log("Starting DDL creation for staging schema...", info=True) }}

  -- CUSTOMERS TABLE
  {% set create_customers %}
    CREATE TABLE IF NOT EXISTS dbt_abenes_stg.customers (
        CustomerId VARCHAR(50),
        CustomerName VARCHAR(200),
        CustomerCategory VARCHAR(100)
    );
  {% endset %}
  {% do run_query(create_customers) %}
  {{ log("Table [dbt_abenes_stg.customers] created or already exists.", info=True) }}

  -- INVOICES TABLE
  {% set create_invoices %}
    CREATE TABLE IF NOT EXISTS dbt_abenes_stg.invoices (
        CompanyId INT,
        CustomerId VARCHAR(50),
        CountryId VARCHAR(10),
        DocumentNumber VARCHAR(50),
        DocumentType VARCHAR(20),
        PostingDate DATE,
        Entry VARCHAR(50),
        EntryType VARCHAR(50),
        Amount DECIMAL(18,2)
    );
  {% endset %}
  {% do run_query(create_invoices) %}
  {{ log("Table [dbt_abenes_stg.invoices] created or already exists.", info=True) }}

  -- PAYMENTS TABLE
  {% set create_payments %}
    CREATE TABLE IF NOT EXISTS dbt_abenes_stg.payments (
        CompanyId INT,
        CustomerId VARCHAR(50),
        CountryId VARCHAR(10),
        DocumentNumber VARCHAR(50),
        DocumentType VARCHAR(20),
        PostingDate DATE,
        Entry VARCHAR(50),
        EntryType VARCHAR(50),
        Amount DECIMAL(18,2),
        InvoiceNumber VARCHAR(50),
        InvoiceEntry VARCHAR(50)
    );
  {% endset %}
  {% do run_query(create_payments) %}
  {{ log("Table [dbt_abenes_stg.payments] created or already exists.", info=True) }}

  {{ log("DDL execution completed OK!", info=True) }}
{% endmacro %}
