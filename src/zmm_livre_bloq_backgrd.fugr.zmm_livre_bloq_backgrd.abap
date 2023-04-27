FUNCTION zmm_livre_bloq_backgrd.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_MSEG) TYPE  TY_T_MSEG
*"----------------------------------------------------------------------
* Diego Lima - Alteração - GAP 477 - Criação de constantes e variável local
*  CONSTANTS lc_bwart TYPE bwart VALUE '101'.

  DATA lt_mseg TYPE TABLE OF mseg WITH HEADER LINE.
* Diego Lima - Alteração - GAP 477

  CONSTANTS: lc_344    TYPE bwart VALUE '344',
             lc_md     TYPE j_1breftyp VALUE 'MD',
             lc_1903aa TYPE j_1bcfop VALUE '1903AA',
             lc_2903aa TYPE j_1bcfop VALUE '2903AA'.

*Transferir estoque livre para bloqueado
  DATA: lt_goodsmvt_item    TYPE TABLE OF bapi2017_gm_item_create,
        ls_goodsmvt_headret TYPE bapi2017_gm_head_ret,
        lt_return           TYPE TABLE OF bapiret2,
        lv_mblnr            TYPE mkpf-mblnr,
        lv_mjahr            TYPE mkpf-mjahr,
        lv_refkey           TYPE j_1bnflin-refkey,
        lv_code             TYPE bapi2017_gm_code VALUE '04'.

* Diego Lima - Alteração - GAP 477 - substituição de i_mseg por lt_mseg
  APPEND LINES OF it_mseg TO lt_mseg.

  SORT lt_mseg BY bwart ASCENDING xauto DESCENDING.
*  DELETE lt_mseg WHERE xauto IS INITIAL.

  READ TABLE lt_mseg INDEX 1.

  CONCATENATE lt_mseg-mblnr lt_mseg-mjahr INTO lv_refkey.

* Diego Lima - Alteração - GAP 477

  SELECT SINGLE * INTO @DATA(ls_lin)
  FROM j_1bnflin
*  WHERE reftyp = 'MD' AND
  WHERE reftyp = @lc_md AND
        refkey = @lv_refkey AND
*      ( cfop = '1903AA' OR
*        cfop = '2903AA' ). "CFOPs Perdas
       ( cfop = @lc_1903aa  OR
        cfop = @lc_2903aa ). "CFOPs Perdas

  IF ls_lin IS NOT INITIAL.

    DATA(ls_goodsmvt_header) = VALUE bapi2017_gm_head_01( doc_date   = sy-datum
                                                          pstng_date = sy-datum ).

    LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>). " WHERE xauto IS INITIAL AND bwart = lc_bwart. " * Diego Lima - Alteração - GAP 477 - Remoção cláusula WHERE do LOOP.

*      DATA(ls_goodsmvt_item) = VALUE bapi2017_gm_item_create( move_type = '344'
      DATA(ls_goodsmvt_item) = VALUE bapi2017_gm_item_create( move_type = lc_344
                                 material = <fs_mseg>-matnr
                                 entry_qnt = <fs_mseg>-menge
                                 entry_uom = <fs_mseg>-meins
                                 stge_loc = <fs_mseg>-lgort
                                 plant = <fs_mseg>-werks
                                 batch = <fs_mseg>-charg ).


      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.
      CLEAR: ls_goodsmvt_item.
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
  ENDIF.

ENDFUNCTION.
