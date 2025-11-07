{{ snapshot_table(
    'invoices_snapshot',
    'cln_invoices',
    'DocumentNumber',
    ['DocumentType', 'PostingDate', 'Amount']
) }}
