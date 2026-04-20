# Final Project: Vendor Purchase Analysis — Custom ALV Report (SAP MM)

**Developer Details:**
- **Name:** Siddharth Sonkar
- **Roll Number:** 23051628
- **Batch/Program:** B.Tech in CSE

## Project Overview
This project presents an end-to-end implementation of a Vendor Purchase Analysis report in SAP ABAP (MM Module). The report aggregates and displays vendor-wise purchase analytics using an Object-Oriented ALV (ABAP List Viewer) approach (`cl_salv_table`). It extracts data from Purchasing Documents (EKKO/EKPO) and the Vendor Master (LFA1).

## Scope & Functional Details
The report determines the total spend and transaction count for vendors across specified date ranges.

**Output Fields:**
- Vendor ID (`LIFNR`)
- Vendor Name (`NAME1`)
- Number of Purchase Orders (`PO_COUNT`)
- Total Purchase Amount (`TOTAL_AMT`)
- Last Purchase Date (`LAST_PDATE`)
- Currency (`WAERS`)

## Logical Project Structure (SAP ABAP)
This project follows professional SAP coding guidelines by segregating concerns into explicit INCLUDE files:
- `ZMM_VENDOR_ALV.abap`: Main Execution driver
- `ZMM_VENDOR_TOP.abap`: Type pools and Global field declarations
- `ZMM_VENDOR_SEL.abap`: Selection screen UI components
- `ZMM_VENDOR_F01.abap`: Data extraction, aggregation logic, and Object-Oriented ALV factory generation.

Please review the attached PDF documentation (`23051628_Project_Documentation.pdf`) for deeper insights.
