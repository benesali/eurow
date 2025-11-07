erDiagram
    CUSTOMERS {
        string CustomerId PK
        string CustomerName
        string CustomerCategory
    }

    INVOICES {
        string DocumentNumber PK
        string CustomerId FK
        int CompanyId
        string CountryId
        string DocumentType
        date PostingDate
        string Entry
        string EntryType
        decimal Amount
    }

    PAYMENTS {
        string DocumentNumber PK
        string CustomerId FK
        int CompanyId
        string CountryId
        string DocumentType
        date PostingDate
        string Entry
        string EntryType
        decimal Amount
        string InvoiceNumber FK
        string InvoiceEntry
    }

    CUSTOMERS ||--o{ INVOICES : "has invoices"
    CUSTOMERS ||--o{ PAYMENTS : "makes payments"
    INVOICES ||--o{ PAYMENTS : "are paid by"
