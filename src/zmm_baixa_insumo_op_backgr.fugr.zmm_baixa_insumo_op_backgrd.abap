FUNCTION zmm_baixa_insumo_op_backgrd.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_MSEG) TYPE  TY_T_MSEG
*"----------------------------------------------------------------------
*Baixar Insumo para Ordem de Produção
  DATA: lt_goodsmvt_item    TYPE TABLE OF bapi2017_gm_item_create,
        ls_goodsmvt_headret TYPE bapi2017_gm_head_ret,
        lt_return           TYPE TABLE OF bapiret2,
        lv_aufnr            TYPE ekkn-aufnr,
        lv_mblnr            TYPE mkpf-mblnr,
        lv_mjahr            TYPE mkpf-mjahr,
        lv_code             TYPE bapi2017_gm_code VALUE '03'.

  CONSTANTS: lc_halb TYPE mtart VALUE 'HALB',
             lc_verp TYPE mtart VALUE 'VERP',
             lc_roh  TYPE mtart VALUE 'ROH',
             lc_101  TYPE bwart VALUE '101',
             lc_261  TYPE bwart VALUE '261'.

  IF it_mseg[] IS NOT INITIAL.

    SELECT * INTO TABLE @DATA(lt_ekpo)
    FROM ekpo
    FOR ALL ENTRIES IN @it_mseg
    WHERE ebeln = @it_mseg-ebeln AND
          ebelp = @it_mseg-ebelp AND
          konnr <> @space.

    IF sy-subrc NE 0.
      CLEAR lt_ekpo.
    ENDIF.
  ENDIF.

  IF it_mseg[] IS NOT INITIAL.

    SELECT * INTO TABLE @DATA(lt_mara)
    FROM mara
    FOR ALL ENTRIES IN @it_mseg
    WHERE matnr = @it_mseg-matnr AND
*      ( mtart = 'HALB' OR
*        mtart = 'VERP' OR
*        mtart = 'ROH' ).
         ( mtart = @lc_halb OR
          mtart = @lc_verp OR
          mtart = @lc_roh ).
    IF sy-subrc NE 0.
      CLEAR lt_ekpo.
    ENDIF.
  ENDIF.

  DATA(ls_goodsmvt_header) = VALUE bapi2017_gm_head_01( doc_date   = sy-datum
                                                        pstng_date = sy-datum ).

  LOOP AT it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) WHERE bwart EQ lc_101.

    READ TABLE lt_ekpo INTO DATA(ls_ekpo) WITH KEY ebeln = <fs_mseg>-ebeln
                                                   ebelp = <fs_mseg>-ebelp.
    IF sy-subrc EQ 0.
      CLEAR lv_aufnr.
      lv_aufnr = ls_ekpo-konnr. "Ordem de Produção

      READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_ekpo-matnr.
      IF sy-subrc EQ 0.

        DATA(ls_goodsmvt_item) = VALUE bapi2017_gm_item_create( move_type = lc_261
                                       material = <fs_mseg>-matnr
                                       entry_qnt = <fs_mseg>-menge
                                       entry_uom = <fs_mseg>-meins
                                       stge_loc = <fs_mseg>-lgort
                                       plant = <fs_mseg>-werks
                                       batch = <fs_mseg>-charg
                                       orderid = lv_aufnr ).
        "gl_account = ???? ).

        APPEND ls_goodsmvt_item TO lt_goodsmvt_item.
        CLEAR: ls_goodsmvt_item, ls_mara, ls_ekpo.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF lt_goodsmvt_item[] IS NOT INITIAL.
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = ls_goodsmvt_header
        goodsmvt_code    = lv_code
      IMPORTING
        goodsmvt_headret = ls_goodsmvt_headret
        materialdocument = lv_mblnr
        matdocumentyear  = lv_mjahr
      TABLES
        goodsmvt_item    = lt_goodsmvt_item
        return           = lt_return.

    IF lv_mblnr IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    ENDIF.
  ENDIF.

ENDFUNCTION.
