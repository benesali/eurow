{% macro ddl_create_tables_cln() %}
  {{ log("Starting DDL creation for clean schema...", info=True) }}

  {% set create_customers %}
  IF OBJECT_ID('cln.customers', 'U') IS NULL
  BEGIN
      CREATE TABLE cln.customers (
          CustomerId NVARCHAR(50) PRIMARY KEY,
          CustomerName NVARCHAR(200),
          CustomerCategory NVARCHAR(100),
          LoadDate DATETIME DEFAULT GETDATE(),
          SourceFile NVARCHAR(200)
      );
  END
  {% endset %}
  {% do run_query(create_customers) %}
  {{ log("Table [cln.customers] created or already exists.", info=True) }}

  -- INVOICES
  {% set create_invoices %}
  IF OBJECT_ID('cln.invoices', 'U') IS NULL
  BEGIN
      CREATE TABLE cln.invoices (
          CompanyId INT,
          CustomerId NVARCHAR(50),
          CountryId NVARCHAR(10),
          InvoiceNumber NVARCHAR(50),
          DocumentType NVARCHAR(20),
          PostingDate DATE,
          Entry NVARCHAR(50),
          EntryType NVARCHAR(50),
          Amount DECIMAL(18,2),
          LoadDate DATETIME DEFAULT GETDATE(),
          SourceFile NVARCHAR(200)
      );
  END
  {% endset %}
  {% do run_query(create_invoices) %}
  {{ log("Table [cln.invoices] created or already exists.", info=True) }}

  -- PAYMENTS
  {% set create_payments %}
  IF OBJECT_ID('cln.payments', 'U') IS NULL
  BEGIN
      CREATE TABLE cln.payments (
          CompanyId INT,
          CustomerId NVARCHAR(50),
          CountryId NVARCHAR(10),
          PaymentNumber NVARCHAR(50),
          DocumentType NVARCHAR(20),
          PostingDate DATE,
          Entry NVARCHAR(50),
          EntryType NVARCHAR(50),
          Amount DECIMAL(18,2),
          InvoiceNumber NVARCHAR(50),
          InvoiceEntry NVARCHAR(50),
          LoadDate DATETIME DEFAULT GETDATE(),
          SourceFile NVARCHAR(200)
      );
  END
  {% endset %}
  {% do run_query(create_payments) %}
  {{ log("Table [cln.payments] created or already exists.", info=True) }}

  {{ log("DDL execution completed OK!", info=True) }}
{% endmacro %}
