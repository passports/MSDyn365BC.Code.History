permissionset 6719 "Jobs - Edit"
{
    Access = Public;
    Assignable = false;
    Caption = 'Edit jobs';

    Permissions = tabledata "Comment Line" = RIMD,
                  tabledata Customer = R,
                  tabledata "Customer Bank Account" = R,
                  tabledata "Default Dimension" = RIMD,
                  tabledata "Dtld. Price Calculation Setup" = RIMD,
                  tabledata "Duplicate Price Line" = RIMD,
                  tabledata "G/L Entry" = r,
                  tabledata "Gen. Journal Line" = r,
                  tabledata "General Ledger Setup" = RM,
                  tabledata Job = RIMD,
#if not CLEAN21
                  tabledata "Job G/L Account Price" = RIMD,
                  tabledata "Job Item Price" = RIMD,
#endif
                  tabledata "Job Journal Line" = r,
                  tabledata "Job Ledger Entry" = Rm,
                  tabledata "Job Planning Line - Calendar" = RIMD,
                  tabledata "Job Planning Line" = RIMD,
                  tabledata "Job Planning Line Invoice" = RIMD,
                  tabledata "Job Posting Group" = R,
#if not CLEAN21
                  tabledata "Job Resource Price" = RIMD,
#endif
                  tabledata "Job Task" = RIMD,
                  tabledata "Job Usage Link" = RIMD,
                  tabledata "Job WIP Entry" = rimd,
                  tabledata "Job WIP G/L Entry" = rimd,
                  tabledata "Job WIP Total" = RIMD,
                  tabledata "Job WIP Warning" = RIMD,
#if not CLEAN20
                  tabledata "Native - Payment" = r,
#endif
                  tabledata "Price Asset" = RIMD,
                  tabledata "Price Calculation Buffer" = RIMD,
                  tabledata "Price Calculation Setup" = RIMD,
                  tabledata "Price Line Filters" = RIMD,
                  tabledata "Price List Header" = RIMD,
                  tabledata "Price List Line" = RIMD,
                  tabledata "Price Source" = RIMD,
                  tabledata "Price Worksheet Line" = RIMD,
                  tabledata "Purch. Cr. Memo Hdr." = r,
                  tabledata "Purch. Cr. Memo Line" = r,
                  tabledata "Purch. Inv. Header" = r,
                  tabledata "Purch. Inv. Line" = r,
                  tabledata "Purch. Rcpt. Header" = r,
                  tabledata "Purch. Rcpt. Line" = r,
                  tabledata "Purchase Header" = r,
                  tabledata "Purchase Header Archive" = r,
                  tabledata "Purchase Line" = R,
                  tabledata "Res. Journal Line" = r,
                  tabledata "Res. Ledger Entry" = rm,
                  tabledata Resource = R,
                  tabledata "Resource Group" = R,
#if not CLEAN21
                  tabledata "Resource Price" = RIMD,
#endif
                  tabledata "Return Receipt Header" = r,
                  tabledata "Return Receipt Line" = r,
                  tabledata "Return Shipment Header" = r,
                  tabledata "Return Shipment Line" = r,
                  tabledata "Sales Cr.Memo Header" = r,
                  tabledata "Sales Cr.Memo Line" = r,
                  tabledata "Sales Header" = r,
                  tabledata "Sales Header Archive" = r,
                  tabledata "Sales Invoice Header" = r,
                  tabledata "Sales Invoice Line" = r,
                  tabledata "Sales Line" = r,
                  tabledata "Sales Shipment Header" = r,
                  tabledata "Sales Shipment Line" = r,
                  tabledata "Service Header" = r,
                  tabledata "Service Invoice Line" = r,
                  tabledata "Service Ledger Entry" = r,
                  tabledata "Standard General Journal" = r,
                  tabledata "Standard General Journal Line" = r,
                  tabledata "Work Type" = R;
}
