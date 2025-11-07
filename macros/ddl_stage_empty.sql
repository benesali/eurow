{% macro ddl_stage_empty() %}

  {% set ddl_script %}
CREATE SCHEMA IF NOT EXISTS stg;

-- CUSTOMERS
IF OBJECT_ID('stg.customers_raw') IS NULL
CREATE TABLE stg.customers_raw (
    CustomerId NVARCHAR(50),
    CustomerName NVARCHAR(200),
    CustomerCategory NVARCHAR(100)
);

-- INVOICES
IF OBJECT_ID('stg.invoices_raw') IS NULL
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

-- PAYMENTS
IF OBJECT_ID('stg.payments_raw') IS NULL
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
  {% endset %}

  {% do run_query(ddl_script) %}


{{ log("Tables created successfully!", info=True) }}
{% endmacro %}
