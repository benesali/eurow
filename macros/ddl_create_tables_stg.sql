{% macro ddl_create_tables_stg() %}
  {{ log("Starting DDL creation for staging schema...", info=True) }}

  {% set create_customers %}
  IF OBJECT_ID('stg.customers', 'U') IS NULL
  BEGIN
      CREATE TABLE stg.customers (
          CustomerId NVARCHAR(50),
          CustomerName NVARCHAR(200),
          CustomerCategory NVARCHAR(100),
      );
  END
  {% endset %}
  {% do run_query(create_customers) %}
  {{ log("Table [stg.customers] created or already exists.", info=True) }}

  {% set create_invoices %}
  IF OBJECT_ID('stg.invoices', 'U') IS NULL
  BEGIN
      CREATE TABLE stg.invoices (
          CompanyId INT,
          CustomerId NVARCHAR(50),
          CountryId NVARCHAR(10),
          DocumentNumber NVARCHAR(50),
          DocumentType NVARCHAR(20),
          PostingDate DATE,
          Entry NVARCHAR(50),
          EntryType NVARCHAR(50),
          Amount DECIMAL(18,2),
      );
  END
  {% endset %}
  {% do run_query(create_invoices) %}
  {{ log("Table [stg.invoices] created or already exists.", info=True) }}

  {% set create_payments %}
  IF OBJECT_ID('stg.payments', 'U') IS NULL
  BEGIN
      CREATE TABLE stg.payments (
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
          InvoiceEntry NVARCHAR(50),
      );
  END
  {% endset %}
  {% do run_query(create_payments) %}
  {{ log("Table [stg.payments] created or already exists.", info=True) }}

  {{ log("DDL execution completed OK!", info=True) }}
{% endmacro %}
