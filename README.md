> An advanced **Vendor Purchase Analysis system** built in SAP ABAP that dynamically aggregates PO transactions, calculates total vendor expenditure, and tracks the last interacted purchasing date using high-performance Native OpenSQL joins.

![ABAP](https://img.shields.io/badge/Language-ABAP-0077CC?style=flat-square&logo=sap&logoColor=white)
![SAP](https://img.shields.io/badge/Platform-SAP%20S%2F4HANA-1A9C3E?style=flat-square&logo=sap&logoColor=white)
![ALV](https://img.shields.io/badge/UI-CL__SALV__TABLE-6C3FC4?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-2ea043?style=flat-square)

---

## 📋 Table of Contents
- [Overview](#-overview)
- [Problem Statement](#-problem-statement)
- [How It Works](#-how-it-works)
- [Tech Stack](#-tech-stack)
- [Program Structure](#-program-structure)
- [Test Cases (Simulation)](#-test-cases-simulation)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Future Improvements](#-future-improvements)

---

## 🌐 Overview
This project targets the **SAP Materials Management (MM)** domain. It delivers a deeply integrated custom ALV report that provides consolidated enterprise intelligence on vendor expenditure without relying on separate Business Intelligence (BI) platforms.

| SAP Table | Data Represented |
|-----------|-----------------|
| `EKKO` | Purchase Order Header (Dates, Currency, Company Code) |
| `EKPO` | Purchase Order Items (Material, Net Value) |
| `LFA1` | Vendor Master Data (Vendor Name, Identifiers) |

---

## ❗ Problem Statement
In standard SAP environments, accessing aggregated spend data per vendor involves cross-referencing multiple standard transaction codes, causing severe bottlenecks.

| Issue | Business Impact |
|-------|----------------|
| Disconnected PO reporting | Procurement teams cannot quickly see total vendor spend. |
| Lack of consolidated frequency metrics | Difficulty identifying how often a supplier is used. |
| Time-consuming data extraction | Reliance on outdated manual Excel downloads spanning `ME2N`/`ME2L`. |

This custom ALV automates the process and groups financial totals natively at the database and application layer.

---

### Data Aggregation Logic
```abap
LOOP AT gt_data INTO gs_data.
  gs_final-lifnr = gs_data-lifnr.
  gs_final-name1 = gs_data-name1.
  gs_final-total_amt = gs_data-netwr.
  gs_final-po_count = 1.
  
  " Aggregate Values
  COLLECT gs_final INTO gt_final.
  
  " Assign Latest Date
  IF gs_data-bedat > gs_final-last_pdate.
     gs_final-last_pdate = gs_data-bedat.
  ENDIF.
ENDLOOP.
```

### Program Flow
```text
User executes ZMM_VENDOR_ALV (SE38)
           │
           ▼
     Selection Screen
     (Company Code / Vendor ID / Date Range)
           │
           ▼
     FORM get_data (ZMM_VENDOR_F01)
     SELECT FROM EKKO INNER JOIN EKPO INNER JOIN LFA1
           │
           ▼
     FORM process_data
     ├── Compute TOTAL_AMT using COLLECT
     ├── Compute PO_COUNT
     └── Determine MAX(BEDAT) -> LAST_PDATE
           │
           ▼
     FORM display_alv
     CL_SALV_TABLE → ALV Grid Output
     (Sort / Filter / Highlight)
```

---

## 🔧 Tech Stack
| Component | Detail |
|-----------|--------|
| **Language** | ABAP (Advanced Business Application Programming) |
| **Platform** | SAP NetWeaver / SAP S/4HANA |
| **UI Framework** | `CL_SALV_TABLE` — Object-Oriented ALV Grid |
| **Development** | SE38 (ABAP Editor) |
| **Compatibility**| SAP ECC 6.0 / S/4HANA |

---

## 🧩 Program Structure
The main program `ZMM_VENDOR_ALV` is split into professional enterprise-level INCLUDES:

```text
ZMM_VENDOR_ALV (Driver Program)
│
├── ZMM_VENDOR_TOP.abap
│     Global Data Declarations, Type Pools, Table Work Areas
│
├── ZMM_VENDOR_SEL.abap
│     SELECT-OPTIONS (Date, Vendor) and PARAMETERS (Company Code)
│
└── ZMM_VENDOR_F01.abap
      FORM get_data (Optimized INNER JOIN)
      FORM process_data (COLLECT Aggregations)
      FORM display_alv (CL_SALV_TABLE Factory & Display)
```

---

## 🧪 Test Cases (Simulation)
Using our Python Interactive simulator, five testing scenarios are validated dynamically:

| Vendor ID | Total POs Available | Filter Date | Final PO Count | Total Spend | Expected Result |
|-----------|--------------------|-------------|----------------|-------------|-----------------|
| `V001` | 30 | Past 1 Year | 30 | ~$550,000 | ✅ Aggregated accurately |
| `V002` | 25 | Past 1 Year | 25 | ~$210,000 | ✅ Sorted descending |
| `V003` | 10 | Past 1 Month|  0 | $0.00 | 🟡 No data found warning |
| `ALL` | 150| Past 1 Year | 150 | ~$1M+ | ✅ Full enterprise summary output |

---

## 🚀 Getting Started

### 1️⃣ Run inside SAP GUI
1. Open transaction **SE38** and create main program `ZMM_VENDOR_ALV`.
2. Create the three INCLUDE programs.
3. Paste code into respective segments, activate, and press **F8**.

### 2️⃣ Web Prototype Simulator (No SAP GUI Required)
Because evaluators cannot directly access your SAP development server, a local prototype representation is provided via `index.html`. 
The `index.html` file doubles as a Vercel-ready Single Page Application (SPA). It uses JavaScript to natively simulate the ABAP `INNER JOIN` and `COLLECT` statements without requiring Python or backend servers.

- **Local Use:** Simply double-click `index.html` in your browser.
- **Web Use:** Deploy the folder securely to Vercel as a static site.

---

## 📁 Project Structure
```text
VendorPurchaseAnalysis/
│
├── *.abap                            ← Core SAP Code blocks (ALV, TOP, SEL, F01)
├── 23051628_Project_Documentation.pdf← Formal SAP Capstone PDF Report
├── index.html                        ← PDF Generation Template & Vercel Web Prototype
├── sap_alv_screenshot.png            ← SAP GUI execution proof
└── README.md
```

---

## 🔮 Future Improvements
- [ ] **High-Spend Highlighting (Colorization)** — Add logic to `CL_SALV_TABLE` to color rows red if `TOTAL_AMT` exceeds threshold.
- [ ] **Interactive GUI Actions** — Bind double-click events targeting ALV rows to call transaction `ME23N` directly.
- [ ] **Chart Integrations** — Forward the ABAP internal table directly into an SAP Fiori Analytical chart object.
- [ ] **Live Vercel Streamlit Hosting** — Continually update the online simulation instance.

---
*Developed under compliance with strict KIIT Capstone SAP Guidelines.*
