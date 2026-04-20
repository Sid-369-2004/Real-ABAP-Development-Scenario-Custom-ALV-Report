*&---------------------------------------------------------------------*
*& Report Z_SALES_ORDER_ALV
*&---------------------------------------------------------------------*
*& Real ABAP Development Scenario — Custom ALV Report
*& Developer: Siddharth Sonkar
*& Roll Number: 23051628
*& Batch/Program: B.Tech in CSE
*&---------------------------------------------------------------------*
REPORT Z_SALES_ORDER_ALV.

*----------------------------------------------------------------------*
* Data Declarations
*----------------------------------------------------------------------*
TABLES: vbak, vbap, mara.

TYPES: BEGIN OF ty_sales,
         vbeln TYPE vbak-vbeln, " Sales Document
         erdat TYPE vbak-erdat, " Creation Date
         ernam TYPE vbak-ernam, " Created By
         netwr TYPE vbak-netwr, " Net Value
         waerk TYPE vbak-waerk, " Currency
         posnr TYPE vbap-posnr, " Item Number
         matnr TYPE vbap-matnr, " Material Number
         maktx TYPE makt-maktx, " Material Description
         kwmeng TYPE vbap-kwmeng, " Order Quantity
         vrkme TYPE vbap-vrkme, " Sales Unit
       END OF ty_sales.

DATA: it_sales TYPE TABLE OF ty_sales,
      wa_sales TYPE ty_sales.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv,
      w_layout    TYPE slis_layout_alv.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln. " Sales Order Number
SELECT-OPTIONS: s_erdat FOR vbak-erdat. " Creation Date
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
* Events
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM get_data.
  IF it_sales IS NOT INITIAL.
    PERFORM build_fieldcat.
    PERFORM build_layout.
    PERFORM display_alv.
  ELSE.
    MESSAGE 'No Data Found for Selection' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.

*----------------------------------------------------------------------*
* Subroutines
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.
  " Fetching Data with an Inner Join from VBAK, VBAP and MAKT
  SELECT a~vbeln a~erdat a~ernam a~netwr a~waerk
         b~posnr b~matnr b~kwmeng b~vrkme
         c~maktx
    INTO TABLE it_sales
    FROM vbak AS a
    INNER JOIN vbap AS b ON a~vbeln = b~vbeln
    LEFT OUTER JOIN makt AS c ON b~matnr = c~matnr AND c~spras = sy-langu
    WHERE a~vbeln IN s_vbeln
      AND a~erdat IN s_erdat.
ENDFORM. " GET_DATA

*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM build_fieldcat.
  DATA: l_pos TYPE i VALUE 1.

  DEFINE add_field.
    wa_fieldcat-col_pos   = l_pos.
    wa_fieldcat-fieldname = &1.
    wa_fieldcat-seltext_m = &2.
    wa_fieldcat-key       = &3.
    wa_fieldcat-do_sum    = &4.
    APPEND wa_fieldcat TO it_fieldcat.
    CLEAR wa_fieldcat.
    l_pos = l_pos + 1.
  END-OF-DEFINITION.

  add_field 'VBELN' 'Sales Order'  'X' ' '.
  add_field 'POSNR' 'Item'         'X' ' '.
  add_field 'ERDAT' 'Creation Dt'  ' ' ' '.
  add_field 'ERNAM' 'Created By'   ' ' ' '.
  add_field 'MATNR' 'Material'     ' ' ' '.
  add_field 'MAKTX' 'Description'  ' ' ' '.
  add_field 'KWMENG' 'Quantity'    ' ' ' '.
  add_field 'VRKME' 'Unit'         ' ' ' '.
  add_field 'NETWR' 'Net Value'    ' ' 'X'.
  add_field 'WAERK' 'Currency'     ' ' ' '.

ENDFORM. " BUILD_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
FORM build_layout.
  w_layout-colwidth_optimize = 'X'.
  w_layout-zebra             = 'X'.
ENDFORM. " BUILD_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = w_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_sales
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " DISPLAY_ALV
