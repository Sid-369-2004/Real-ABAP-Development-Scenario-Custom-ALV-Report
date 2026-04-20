*&---------------------------------------------------------------------*
*& Include          ZMM_VENDOR_TOP
*&---------------------------------------------------------------------*
*& Top Include for Vendor Purchase Analysis
*&---------------------------------------------------------------------*

TABLES: ekko, ekpo, lfa1.

TYPES: BEGIN OF ty_vendor_data,
         lifnr TYPE ekko-lifnr, " Vendor ID
         name1 TYPE lfa1-name1, " Vendor Name
         ebeln TYPE ekko-ebeln, " Purchase Order
         bedat TYPE ekko-bedat, " PO Date
         netwr TYPE ekpo-netwr, " Net Value
         waers TYPE ekko-waers, " Currency
       END OF ty_vendor_data.

TYPES: BEGIN OF ty_final_data,
         lifnr      TYPE ekko-lifnr,
         name1      TYPE lfa1-name1,
         po_count   TYPE i,            " Number of Purchase Orders
         total_amt  TYPE ekpo-netwr,   " Total Purchase Amount
         last_pdate TYPE ekko-bedat,   " Last Purchase Date
         waers      TYPE ekko-waers,
       END OF ty_final_data.

DATA: gt_data  TYPE TABLE OF ty_vendor_data,
      gs_data  TYPE ty_vendor_data,
      gt_final TYPE TABLE OF ty_final_data,
      gs_final TYPE ty_final_data.

DATA: go_alv TYPE REF TO cl_salv_table.
