*&---------------------------------------------------------------------*
*& Include          ZMM_VENDOR_SEL
*&---------------------------------------------------------------------*
*& Selection Screen Definition
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS: p_bukrs TYPE ekko-bukrs OBLIGATORY DEFAULT '1000'. " Company Code
SELECT-OPTIONS: s_date FOR ekko-bedat OBLIGATORY.              " Date Range
SELECT-OPTIONS: s_vendor FOR ekko-lifnr.                       " Vendor (Optional)

SELECTION-SCREEN END OF BLOCK b1.
