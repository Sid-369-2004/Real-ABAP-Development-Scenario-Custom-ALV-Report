*&---------------------------------------------------------------------*
*& Report ZMM_VENDOR_ALV
*&---------------------------------------------------------------------*
*& Topic: Vendor Purchase Analysis — Custom ALV Report (SAP MM)
*& Developer: Siddharth Sonkar
*& Roll Number: 23051628
*& Program: B.Tech in CSE
*&---------------------------------------------------------------------*
REPORT zmm_vendor_alv.

INCLUDE zmm_vendor_top. " Type Definitions and Global Data
INCLUDE zmm_vendor_sel. " Selection Screen
INCLUDE zmm_vendor_f01. " Data Fetch and Process Forms

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM process_data.

END-OF-SELECTION.
  PERFORM display_alv.
