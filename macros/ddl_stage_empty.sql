{% macro ddl_stage_empty() %}
  {{ log("Starting DDL creation for staging schema...", info=True) }}

  {% set create_schema %}
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'stg')
  EXEC('CREATE SCHEMA stg');
  {% endset %}
  {% do run_query(create_schema) %}
  {{ log("Schema [stg] ensured.", info=True) }}

  {% set create_customers %}
  IF OBJECT_ID('stg.customers_raw', 'U') IS NULL
  BEGIN
      CREATE TABLE stg.customers_raw (
          CustomerId NVARCHAR(50),
          CustomerName NVARCHAR(200),
          CustomerCategory NVARCHAR(100)
      );
  END
  {% endset %}
  {% do run_query(create_customers) %}
  {{ log("Table [stg.customers_raw] created or already exists.", info=True) }}

  {% set create_invoices %}
  IF OBJECT_ID('stg.invoices_raw', 'U') IS NULL
  BEGIN
      CREATE TABLE stg.invoices_raw (
          CompanyId INT,
          CustomerId NVARCHAR(50),
          CountryId NVARCHAR(10),
          DocumentNumber NVARCHAR(50),
          DocumentType NVARCHAR(20),
          PostingDate DATE,
          Entry NVARCHAR(50),
          EntryType NVARCHAR(50),
          Amount DECIMAL(18,2)
      );
  END
  {% endset %}
  {% do run_query(create_invoices) %}
  {{ log("Table [stg.invoices_raw] created or already exists.", info=True) }}

  {% set create_payments %}
  IF OBJECT_ID('stg.payments_raw', 'U') IS NULL
  BEGIN
      CREATE TABLE stg.payments_raw (
          CompanyId INT,
          CustomerId NVARCHAR(50),
          CountryId NVARCHAR(10),
          DocumentNumber NVARCHAR(50),
          DocumentType NVARCHAR(20),
          PostingDate DATE,
          Entry NVARCHAR(50),
          EntryType NVARCHAR(50),
          Amount DECIMAL(18,2),
          InvoiceNumber NVARCHAR(50),
          InvoiceEntry NVARCHAR(50)
      );
  END
  {% endset %}
  {% do run_query(create_payments) %}
  {{ log("Table [stg.payments_raw] created or already exists.", info=True) }}

  {{ log("DDL execution completed successfully!", info=True) }}
{% endmacro %}
