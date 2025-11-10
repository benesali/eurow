{% macro ddl_create_tables_cln() %}
  {{ log("Starting DDL creation for clean schema...", info=True) }}

  -- CUSTOMERS TABLE
  {% set create_customers %}
    CREATE TABLE IF NOT EXISTS cln.customers (
        CustomerId VARCHAR(50) PRIMARY KEY,
        CustomerName VARCHAR(200),
        CustomerCategory VARCHAR(100),
        LoadDate TIMESTAMP
    );
  {% endset %}
  {% do run_query(create_customers) %}
  {{ log("Table [cln.customers] created or already exists.", info=True) }}

  -- INVOICES TABLE
  {% set create_invoices %}
    CREATE TABLE IF NOT EXISTS cln.invoices (
        CompanyId INT,
        CustomerId VARCHAR(50),
        CountryId VARCHAR(10),
        InvoiceNumber VARCHAR(50),
        DocumentType VARCHAR(20),
        PostingDate DATE,
        Entry VARCHAR(50),
        EntryType VARCHAR(50),
        Amount DECIMAL(18,2),
        LoadDate TIMESTAMP
    );
  {% endset %}
  {% do run_query(create_invoices) %}
  {{ log("Table [cln.invoices] created or already exists.", info=True) }}

  -- PAYMENTS TABLE
  {% set create_payments %}
    CREATE TABLE IF NOT EXISTS cln.payments (
        CompanyId INT,
        CustomerId VARCHAR(50),
        CountryId VARCHAR(10),
        PaymentNumber VARCHAR(50),
        DocumentType VARCHAR(20),
        PostingDate DATE,
        Entry VARCHAR(50),
        EntryType VARCHAR(50),
        Amount DECIMAL(18,2),
        InvoiceNumber VARCHAR(50),
        InvoiceEntry VARCHAR(50),
        LoadDate TIMESTAMP
    );
  {% endset %}
  {% do run_query(create_payments) %}
  {{ log("Table [cln.payments] created or already exists.", info=True) }}

  {{ log("DDL execution completed OK!", info=True) }}
{% endmacro %}
