*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

INTERFACE lif_invt.

  METHODS doAction
    IMPORTING it_data   TYPE zclmm_invt_nfe=>tt_nfe_emissao
    EXPORTING et_return TYPE bapiret2_tab.

ENDINTERFACE.

"! Local Class for Nota Fiscal Actions
CLASS lcl_nota DEFINITION
INHERITING FROM zclmm_invt_nfe.

  PUBLIC SECTION.

    INTERFACES lif_invt.

ENDCLASS.

"! Local Class for Inventory Actions
CLASS lcl_invt DEFINITION
INHERITING FROM zclmm_invt_nfe.

  PUBLIC SECTION.

    INTERFACES lif_invt.

  PRIVATE SECTION.

    DATA: gt_items TYPE TABLE OF bapi_physinv_post_items.


ENDCLASS.

"! Local Class for Billing Actions
CLASS lcl_cntb DEFINITION
INHERITING FROM zclmm_invt_nfe.

  PUBLIC SECTION.

    INTERFACES lif_invt.

ENDCLASS.

""""""""""""""""""""""""" IMPLEMENTATIONS """"""""""""""""""""""""""""""""""""""""""""

CLASS lcl_nota IMPLEMENTATION.

  METHOD lif_invt~doaction.

    DATA lt_return TYPE bapiret2_tab.

    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'ZFMM_J1BN1'
        EXPORTING
          iv_mblnr          = <fs_data>-Mblnr
          iv_mjahr          = <fs_data>-gjahr "TODO Verificar
          iv_iblnr          = <fs_data>-iblnr
          iv_main           = CORRESPONDING zsmm_alivium( <fs_data> )
        IMPORTING
          ev_docnum_entrada = <fs_data>-DocnumEntrada
          ev_docnum_saida   = <fs_data>-DocnumSaida
          et_return         = me->gt_return.

      APPEND LINES OF lt_return TO me->gt_return.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_invt IMPLEMENTATION.

  METHOD lif_invt~doaction.

    DATA lt_return TYPE bapiret2_tab.

    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'BAPI_MATPHYSINV_POSTDIFF'
        EXPORTING
          physinventory = <fs_data>-iblnr
          fiscalyear    = <fs_data>-gjahr
          pstng_date    = <fs_data>-budat
        TABLES
          items         = me->gt_items
          return        = lt_return.

      IF NOT line_exists( lt_return[ type = if_abap_behv_message=>severity-error ] ).

        TRY.

            <fs_data>-Mblnr = lt_return[ id = 'M7' number = '716' ]-message_v2.

          CATCH cx_root.
        ENDTRY.

        APPEND CORRESPONDING #( <fs_data> ) TO gt_alivium.

      ELSE.

        lt_return = VALUE #( BASE lt_return ( id = 'M7' number = '450' type = if_abap_behv_message=>severity-error ) ) .

      ENDIF.

      APPEND LINES OF lt_return to me->gt_return.

    ENDLOOP.

    APPEND LINES OF me->save(  ) TO me->gt_return.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_cntb IMPLEMENTATION.

  METHOD lif_invt~doaction.

    DATA lt_return TYPE bapiret2_tab.

    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_alivium>).

      CALL FUNCTION 'ZFMM_NFWRITE_CONTABIL'
        IMPORTING
          et_return  = lt_return
        CHANGING
          cs_alivium = <fs_alivium>.

      APPEND LINES OF lt_return TO me->gt_return.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
