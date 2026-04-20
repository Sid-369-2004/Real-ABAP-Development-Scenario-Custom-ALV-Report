*&---------------------------------------------------------------------*
*& Include          ZMM_VENDOR_F01
*&---------------------------------------------------------------------*
*& Data Processing and ALV Display Logic
*&---------------------------------------------------------------------*

FORM get_data.
  " Fetching PO data and Vendor Name
  SELECT a~lifnr, b~name1, a~ebeln, a~bedat, c~netwr, a~waers
    INTO TABLE @gt_data
    FROM ekko AS a
    INNER JOIN lfa1 AS b ON a~lifnr = b~lifnr
    INNER JOIN ekpo AS c ON a~ebeln = c~ebeln
    WHERE a~bukrs = @p_bukrs
      AND a~bedat IN @s_date
      AND a~lifnr IN @s_vendor.

  IF sy-subrc <> 0.
    MESSAGE 'No Purchase Orders found for the given selection.' TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.

FORM process_data.
  CLEAR gt_final.

  " Aggregate data per Vendor
  LOOP AT gt_data INTO gs_data.
    " Prepare aggregation
    gs_final-lifnr = gs_data-lifnr.
    gs_final-name1 = gs_data-name1.
    gs_final-waers = gs_data-waers.
    gs_final-total_amt = gs_data-netwr.
    gs_final-po_count = 1.
    gs_final-last_pdate = gs_data-bedat.

    " Calculate totals and determine latest purchase date
    COLLECT gs_final INTO gt_final.
  ENDLOOP.

  " Make sure the date collected is exactly the MAX date for each vendor
  LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<fs_final>).
    LOOP AT gt_data INTO gs_data WHERE lifnr = <fs_final>-lifnr.
      IF gs_data-bedat > <fs_final>-last_pdate.
        <fs_final>-last_pdate = gs_data-bedat.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  " Sort by highest spend
  SORT gt_final BY total_amt DESCENDING.
ENDFORM.

FORM display_alv.
  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_final ).
    CATCH cx_salv_msg.
      MESSAGE 'Error creating ALV grid' TYPE 'E'.
  ENDTRY.

  " Enhance Columns and Header
  DATA(lo_columns) = go_alv->get_columns( ).
  lo_columns->set_optimize( abap_true ).

  TRY.
      DATA(lo_col) = lo_columns->get_column( 'PO_COUNT' ).
      lo_col->set_short_text( 'PO Count' ).
      lo_col->set_medium_text( 'Purchase Orders' ).
      lo_col->set_long_text( 'Number of Purchase Orders' ).

      lo_col = lo_columns->get_column( 'TOTAL_AMT' ).
      lo_col->set_short_text( 'Total Amt' ).
      lo_col->set_medium_text( 'Total Spend' ).
      lo_col->set_long_text( 'Total Purchase Amount' ).

      lo_col = lo_columns->get_column( 'LAST_PDATE' ).
      lo_col->set_short_text( 'Last Pur.' ).
      lo_col->set_medium_text( 'Last Purchase Dt' ).
      lo_col->set_long_text( 'Last Purchase Date' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  " Enable zebra layout and functions
  DATA(lo_display) = go_alv->get_display_settings( ).
  lo_display->set_striped_pattern( abap_true ).
  lo_display->set_list_header( 'Vendor Purchase Analysis' ).

  go_alv->get_functions( )->set_all( abap_true ).

  go_alv->display( ).
ENDFORM.
