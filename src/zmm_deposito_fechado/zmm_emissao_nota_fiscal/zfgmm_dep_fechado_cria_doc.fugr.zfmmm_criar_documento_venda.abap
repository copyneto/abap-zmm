FUNCTION zfmmm_criar_documento_venda.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_HIS_DEP_FEC) TYPE  ZCTGMM_HIS_DEP_FEC
*"     VALUE(IT_IMSEG) TYPE  TY_T_IMSEG
*"----------------------------------------------------------------------

  DATA:

    ls_imkpf     TYPE  imkpf,
    lt_imseg     TYPE  ty_t_imseg,
    lt_emseg     TYPE TABLE OF emseg,
    ls_emkpf     TYPE emkpf,
    lv_lvs_tafkz TYPE char20,
    ls_mkpf      TYPE mkpf.

  DATA:
    ls_goodsmvt_header  TYPE  bapi2017_gm_head_01,
    ls_goodsmvt_code    TYPE  bapi2017_gm_code,
    lt_goodsmvt_item    TYPE TABLE OF bapi2017_gm_item_create,
    lv_goodsmvt_headret TYPE bapi2017_gm_head_ret,
    lv_materialdocument TYPE  bapi2017_gm_head_ret-mat_doc,
    lv_matdocumentyear  TYPE  bapi2017_gm_head_ret-doc_year,
    lt_return           TYPE TABLE OF bapiret2.

*  IF sy-uname = 'APONCIANO'.
*    DO.
*      DATA(lv_dbg) = abap_true.
*    ENDDO.
*
*  ENDIF.

* Obs: é necessário modficar a lógica para testar se a função parceiro ZU está setada no documento.

  WAIT UP TO 10 SECONDS.
  CHECK it_his_dep_fec IS NOT INITIAL.
  DATA(lt_his_dep_fec)  = it_his_dep_fec.

  MODIFY ztmm_his_dep_fec FROM  TABLE lt_his_dep_fec.
  lt_imseg = it_imseg.

  ls_goodsmvt_header-pstng_date = sy-datum.
  ls_goodsmvt_header-doc_date = sy-datum.

  ls_goodsmvt_code-gm_code = '04'.

  LOOP AT it_imseg REFERENCE INTO DATA(ls_imseg).

    APPEND VALUE #( material  = ls_imseg->matnr
                    plant     = ls_imseg->werks
                    stge_loc  = ls_imseg->lgort
                    batch     = ls_imseg->charg
                    move_type = '343'
                    val_type  = ls_imseg->bwtar
                    entry_qnt = ls_imseg->menge
                    entry_uom = ls_imseg->erfme
                    entry_uom_iso = ls_imseg->erfme
                    no_more_gr = abap_true
                    move_mat  = ls_imseg->matnr
                    move_plant  = ls_imseg->werks
                    move_stloc = ls_imseg->lgort
                    move_batch = ls_imseg->charg
                    move_val_type = ls_imseg->bwtar ) TO lt_goodsmvt_item.
  ENDLOOP.

  CLEAR lt_return.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_goodsmvt_header
      goodsmvt_code    = ls_goodsmvt_code
    IMPORTING
      goodsmvt_headret = lv_goodsmvt_headret
      materialdocument = lv_materialdocument
      matdocumentyear  = lv_matdocumentyear
    TABLES
      goodsmvt_item    = lt_goodsmvt_item
      return           = lt_return.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

  DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).
  lr_adm_emissao_nf_events->bapi_create_documents(
    EXPORTING
      it_historico_key = lt_his_dep_fec
*     iv_update_history = abap_true
    IMPORTING
      et_return        = DATA(lt_return_po)
  ).

  lr_adm_emissao_nf_events->job_delivery(
    EXPORTING
      iv_status = '10'
    IMPORTING
      et_return = DATA(lt_return_delivery)
  ).

  APPEND LINES OF lt_return_po TO lt_return_delivery.

ENDFUNCTION.
