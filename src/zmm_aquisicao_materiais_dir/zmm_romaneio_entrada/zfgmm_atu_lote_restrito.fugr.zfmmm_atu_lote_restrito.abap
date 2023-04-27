FUNCTION zfmmm_atu_lote_restrito.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      IT_MSEG STRUCTURE  MSEG
*"----------------------------------------------------------------------
*Baixar Insumo para Ordem de Produção
  DATA: lt_goodsmvt_item    TYPE TABLE OF bapi2017_gm_item_create,
        ls_goodsmvt_headret TYPE bapi2017_gm_head_ret,
        lt_return           TYPE TABLE OF bapiret2,
        lv_aufnr            TYPE ekkn-aufnr,
        lv_mblnr            TYPE mkpf-mblnr,
        lv_mjahr            TYPE mkpf-mjahr,
        lv_code(2)          VALUE '03'.

  DATA(lt_mseg) = it_mseg[].

  DELETE lt_mseg WHERE smbln IS NOT INITIAL
                    OR mblnr IS INITIAL.

  SELECT ebeln,
         bsart
    FROM ekko
     INTO TABLE @DATA(lt_ekko)
  FOR ALL ENTRIES IN @it_mseg
  WHERE ebeln = @it_mseg-ebeln
    AND bsart = 'ZPGV'.
  IF sy-subrc EQ 0.
    SORT lt_ekko BY ebeln.
  ENDIF.
  LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).
    READ TABLE lt_ekko
      WITH KEY ebeln = <fs_mseg>-ebeln
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'VB_CHANGE_BATCH_STATUS'
        EXPORTING
          matnr       = <fs_mseg>-matnr
          charg       = <fs_mseg>-charg
          werks       = <fs_mseg>-werks
          zustd       = 'X'
          bypass_post = 'X'.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

ENDFUNCTION.
