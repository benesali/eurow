{% macro ddl_create_tables_rpt() %}
  {{ log("Starting DDL creation for rpt schema...", info=True) }}

  -- CUSTOMER BALANCES TABLE
  {% set create_customer_balances %}
    CREATE TABLE IF NOT EXISTS rpt.customer_balances (
        CustomerId VARCHAR(50),
        CustomerName VARCHAR(200),
        CustomerCategory VARCHAR(100),
        invoice_month DATE,
        total_invoiced DECIMAL(18,2),
        total_paid DECIMAL(18,2),
        total_remaining DECIMAL(18,2),
        open_invoices INT,
        paid_invoices INT,
        partial_invoices INT
    );
  {% endset %}
  {% do run_query(create_customer_balances) %}
  {{ log("Table [rpt.customer_balances] created or already exists.", info=True) }}



-- Invoice Report Table (Enriched Data)
  {% set create_invoice_report %}

    CREATE TABLE IF NOT EXISTS rpt.invoice_report (
        InvoiceNumber VARCHAR(50) PRIMARY KEY,
        CustomerId VARCHAR(50),
        CompanyId INT,
        CountryId VARCHAR(10),
        DocumentType VARCHAR(20),
        PostingDate DATE,
        invoice_amount DECIMAL(18,2),
        total_paid DECIMAL(18,2) DEFAULT 0,
        total_remaining DECIMAL(18,2) DEFAULT 0,
        invoice_status VARCHAR(20)
    );

  {% endset %}
  {% do run_query(create_invoice_report) %}
  {{ log("Table [rpt.invoice_report] created or already exists.", info=True) }}


  {{ log("DDL execution completed OK!", info=True) }}
{% endmacro %}
