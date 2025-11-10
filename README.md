
# Eurow Data Solution (Azure + dbt + ADF)

Demo projekt ukazuje kompletní datovou pipeline postavenou na **Azure Data Platform** s využitím **Azure Data Factory (ADF)**, **AzPostgresSQL**, **Azure Data Lake Storage (ADLS)** a **dbt Cloud** pro transformace.

## Technologie

- **Azure Data Factory (ADF)** – orchestrátor pipeline
- **AzPostgresSQL** – hlavní datové úložiště
- **Azure Data Lake Storage (ADLS)** – staging soubory (CSV/XLSX)
- **dbt Cloud** – transformace, snapshoty, testy, dokumentace
- **Power BI** – reporting nad Gold vrstvou


DBT
- **načítání zdrojová data (Bronze / Stage)**
- **transformování je do očištěného modelu (Silver / Clean)**
- **historizování silver vrstvy (Snapshots)**
- **příprava datového modelu pro reporting (Gold / Report)**

ADF tooling
- **bulk load raw => stage**
- **orchestrování stage vrstvy a puštění dbt**

---

## Architektura řešení

### 🔹 Vrstvy

| Vrstva | Schéma | Popis |
|---------|---------|--------|
| **Stage (Bronze)** | `stg` | Data načtená z ADLS do SQL bez úprav. |
| **Clean (Silver)** | `cln` | Očištěná data, typově sjednocená, připravená pro snapshot. |
| **Snapshots** | `snapshots_cln` | Historické záznamy (SCD2) pro audity a změnové sledování. |
| **Report (Gold)** | `rpt` | Agregace a pohledy pro Power BI reporty. |

Iiciálí příprava schémat a načtení dat do stage

![Příprava schémat a načtení dat do stage](schemas_ppl.png)

---

## ETL Flow

```mermaid
graph TD
    A["ADLS Raw Files"] -->|"Copy Data"| B["Azure SQL (stg.*)"]
    B -->|"dbt run"| C["cln.* (Clean Layer)"]
    C -->|"dbt snapshot"| D["snapshots_cln.*"]
    C -->|"dbt run"| E["rpt.* (Report Layer)"]
    E -->|"Refresh"| F["Power BI Dataset"]
```

## BASIC model (gold tables tbd)
```mermaid
erDiagram
    CUSTOMERS {
        string CustomerId PK
        string CustomerName
        string CustomerCategory
    }

    INVOICES {
        string InvoiceNumber PK
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
        string PaymentNumber PK
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
```
