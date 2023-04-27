CLASS zclmm_wf_po DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_me_process_po_cust .

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_fields_line,
             campo TYPE ztca_param_val-low,
           END OF ty_fields_line.
    TYPES ty_fields TYPE TABLE OF ty_fields_line WITH EMPTY KEY.

    TYPES: BEGIN OF ty_workflows_line,
             wi_id TYPE sww_wi2obj-wi_id,
           END OF ty_workflows_line.
    TYPES ty_workflows TYPE TABLE OF ty_workflows_line WITH EMPTY KEY.

    METHODS restart_wf IMPORTING iv_ebeln     TYPE ebeln
                                 io_header    TYPE REF TO if_purchase_order_mm
                                 it_workflows TYPE ty_workflows.

    METHODS header_changed IMPORTING iv_ebeln         TYPE ebeln
                                     io_header        TYPE REF TO if_purchase_order_mm
                           RETURNING VALUE(rv_result) TYPE xfeld.

    METHODS get_header_db IMPORTING iv_ebeln         TYPE ebeln
                                    it_fields        TYPE ty_fields
                          RETURNING VALUE(rs_result) TYPE mepoheader.

    METHODS item_changed IMPORTING iv_ebeln         TYPE ebeln
                                   io_header        TYPE REF TO if_purchase_order_mm
                         RETURNING VALUE(rv_result) TYPE xfeld.

    METHODS get_items_db IMPORTING iv_ebeln         TYPE ebeln
                                   it_fields        TYPE ty_fields
                         RETURNING VALUE(rt_result) TYPE tab_mepoitem.

    METHODS check_item IMPORTING is_item          TYPE mepoitem
                                 is_item_db       TYPE mepoitem
                                 it_fields        TYPE ty_fields
                       RETURNING VALUE(rv_result) TYPE xfeld.

ENDCLASS.



CLASS zclmm_wf_po IMPLEMENTATION.


  METHOD if_ex_me_process_po_cust~check .
    RETURN.
  ENDMETHOD.

  METHOD if_ex_me_process_po_cust~close .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_header .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_header_refkeys .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_item .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_item_refkeys .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~initialize .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~open .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~post .

    DATA(lr_wi_stat) = VALUE swfartwista( sign = 'I' option = 'EQ'
      ( low = 'WAITING'  ) " Em espera
      ( low = 'READY'    ) " Pronto
      ( low = 'SELECTED' ) " Aceito
      ( low = 'STARTED'  ) " Em processamento
      ( low = 'CHECKED'  ) " Em preparação
    ).

    SELECT FROM sww_wi2obj
      INNER JOIN swwwihead
         ON swwwihead~wi_id EQ sww_wi2obj~wi_id
      FIELDS sww_wi2obj~wi_id
      WHERE sww_wi2obj~wi_rh_task EQ 'WS00800238'
        AND sww_wi2obj~catid      EQ 'CL'
        AND sww_wi2obj~instid     EQ @im_ebeln
        AND sww_wi2obj~typeid     EQ 'CL_MM_PUR_WF_OBJECT_PO'
        AND swwwihead~wi_stat     IN @lr_wi_stat
      INTO TABLE @DATA(lt_workflows).
    IF sy-subrc NE 0.
*      RETURN.
    ENDIF.

    IF header_changed( iv_ebeln  = im_ebeln
                       io_header = im_header ).

      restart_wf( iv_ebeln     = im_ebeln
                  io_header    = im_header
                  it_workflows = lt_workflows ).
      RETURN.
    ENDIF.

    IF item_changed( iv_ebeln  = im_ebeln
                     io_header = im_header ).

      restart_wf( iv_ebeln     = im_ebeln
                  io_header    = im_header
                  it_workflows = lt_workflows ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_account .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_header .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_item .
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_schedule .
    RETURN.
  ENDMETHOD.


  METHOD restart_wf.

    CONSTANTS: lc_sap_wapi_adm_workflow_canc TYPE rs38l_fnam VALUE 'SAP_WAPI_ADM_WORKFLOW_CANCEL'.

    LOOP AT it_workflows ASSIGNING FIELD-SYMBOL(<fs_workflows>).
      CALL FUNCTION lc_sap_wapi_adm_workflow_canc
        EXPORTING
          workitem_id = <fs_workflows>-wi_id
          do_commit   = space.
    ENDLOOP.

    DATA(ls_purchaseorder) = cl_mm_pur_gfn_me_map=>map_gfn_me_purchaseorder( is_me_purchaseorder = io_header->get_data( ) ).

    NEW cl_mm_pur_wf_object_po(
      iv_object_id = CONV #( iv_ebeln )
      is_purchaseorder = ls_purchaseorder )->start_workflow( ).

  ENDMETHOD.


  METHOD header_changed.

    SELECT FROM ztca_param_val
      FIELDS low AS campo
      WHERE modulo EQ 'MM'
        AND chave1 EQ 'RESTART_WF'
        AND chave2 EQ 'PO'
        AND chave3 EQ 'EKKO'
      INTO TABLE @DATA(lt_fields).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    APPEND 'EBELN' TO lt_fields.

*    SORT lt_fields BY campo.
*    DELETE ADJACENT DUPLICATES FROM lt_fields COMPARING campo.

    DATA(ls_header) = io_header->get_data( ).

    DATA(ls_header_db) = get_header_db( iv_ebeln  = iv_ebeln
                                        it_fields = lt_fields ).
    IF ls_header_db IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<fs_fields>).

      ASSIGN COMPONENT <fs_fields>-campo OF STRUCTURE ls_header TO FIELD-SYMBOL(<fs_value>).
      CHECK <fs_value> IS ASSIGNED.

      ASSIGN COMPONENT <fs_fields>-campo OF STRUCTURE ls_header_db TO FIELD-SYMBOL(<fs_value_db>).
      CHECK <fs_value_db> IS ASSIGNED.

      IF <fs_value> NE <fs_value_db>.
        rv_result = abap_true.
        RETURN.
      ENDIF.

      UNASSIGN: <fs_value>,
                <fs_value_db>.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_header_db.

    DATA: lv_colunas TYPE string.

    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<fs_fields>).
      IF lv_colunas IS INITIAL.
        lv_colunas = <fs_fields>-campo.
      ELSE.
        CONCATENATE lv_colunas <fs_fields>-campo INTO lv_colunas SEPARATED BY ','.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE (lv_colunas) FROM ekko
      INTO CORRESPONDING FIELDS OF @rs_result
      WHERE ebeln EQ @iv_ebeln.

  ENDMETHOD.


  METHOD item_changed.

    SELECT FROM ztca_param_val
      FIELDS low AS campo
      WHERE modulo EQ 'MM'
        AND chave1 EQ 'RESTART_WF'
        AND chave2 EQ 'PO'
        AND chave3 EQ 'EKPO'
      INTO TABLE @DATA(lt_fields).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    APPEND 'EBELN' TO lt_fields.
    APPEND 'EBELP' TO lt_fields.
    APPEND 'LOEKZ' TO lt_fields.

*    SORT lt_fields BY campo.
*    DELETE ADJACENT DUPLICATES FROM lt_fields COMPARING campo.

    DATA(lt_items) = io_header->get_items( ).

    DATA(lt_items_db) = get_items_db( iv_ebeln  = iv_ebeln
                                      it_fields = lt_fields ).
    IF lt_items_db IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      DATA(ls_item) = <fs_items>-item->get_data( ).

      READ TABLE lt_items_db INTO DATA(ls_item_db)
        WITH KEY ebeln = ls_item-ebeln
                 ebelp = ls_item-ebelp BINARY SEARCH.
      IF sy-subrc NE 0.
        rv_result = abap_true.
        RETURN.
      ENDIF.

      IF ls_item-loekz NE ls_item_db-loekz.
        rv_result = abap_true.
        RETURN.
      ENDIF.

      rv_result = check_item( is_item    = ls_item
                              is_item_db = ls_item_db
                              it_fields  = lt_fields ).
      IF rv_result EQ abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_items_db.

    DATA: lv_colunas TYPE string.

    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<fs_fields>).
      IF lv_colunas IS INITIAL.
        lv_colunas = <fs_fields>-campo.
      ELSE.
        CONCATENATE lv_colunas <fs_fields>-campo INTO lv_colunas SEPARATED BY ','.
      ENDIF.
    ENDLOOP.

    SELECT (lv_colunas) FROM ekpo
      INTO CORRESPONDING FIELDS OF TABLE @rt_result
      WHERE ebeln EQ @iv_ebeln
        AND loekz EQ @space
      ORDER BY PRIMARY KEY.

  ENDMETHOD.


  METHOD check_item.

    LOOP AT it_fields ASSIGNING FIELD-SYMBOL(<fs_fields>).

      ASSIGN COMPONENT <fs_fields>-campo OF STRUCTURE is_item TO FIELD-SYMBOL(<fs_value>).
      CHECK <fs_value> IS ASSIGNED.

      ASSIGN COMPONENT <fs_fields>-campo OF STRUCTURE is_item_db TO FIELD-SYMBOL(<fs_value_db>).
      CHECK <fs_value_db> IS ASSIGNED.

      IF <fs_value> NE <fs_value_db>.
        rv_result = abap_true.
        RETURN.
      ENDIF.

      UNASSIGN: <fs_value>,
                <fs_value_db>.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
