***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Mantem status do deposito fechado                      *
*** AUTOR : Willian Hazor  – Meta                                     *
*** FUNCIONAL: Alcides Ponciano  – Meta                               *
*** DATA :  26.08.2022                                                *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
***      |       |                                                    *
***********************************************************************
REPORT zmmr_mantem_deposito_fechado.

TYPES: BEGIN OF ty_purchase_key,
         purchase_order      TYPE ebeln,
         purchase_order_item TYPE ebelp,
       END OF ty_purchase_key.

DATA: lt_purchase_key TYPE TABLE OF ty_purchase_key.

DATA: gv_proc TYPE char1.

SELECTION-SCREEN BEGIN OF BLOCK block WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_msg TYPE char1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK block.


START-OF-SELECTION.
  PERFORM f_vez_processamento CHANGING gv_proc.

  IF gv_proc IS NOT INITIAL.
    EXIT.
  ENDIF.

  DATA(go_classe) = NEW zclmm_adm_emissao_nf_events( ).

  go_classe->job_delivery( EXPORTING
                              iv_status       = zclmm_adm_emissao_nf_events=>gc_status-saida_nota
                              iv_current_date = abap_true       " INSERT - JWSILVA - 19.02.2023
                           IMPORTING
                              et_return = DATA(lt_return) ).

  go_classe->job_delivery( EXPORTING
                              iv_status = zclmm_adm_emissao_nf_events=>gc_status-ordem_frete_job
                              iv_current_date = abap_true       " INSERT - JWSILVA - 19.02.2023
                           IMPORTING
                              et_return = DATA(lt_return1) ).

  APPEND LINES OF lt_return1 TO lt_return.

  CLEAR lt_return1.

  go_classe->job_entrada_mercadoria( IMPORTING et_return = lt_return1 ).

  APPEND LINES OF lt_return1 TO lt_return.

  SELECT DISTINCT purchase_order, CAST( concat( '0' , purchase_order_item  ) AS NUMC ) AS item
    FROM ztmm_his_dep_fec
   WHERE purchase_order IS NOT INITIAL
     AND in_material_document IS NOT INITIAL
     AND in_delivery_document IS INITIAL
   GROUP BY purchase_order, purchase_order_item
   ORDER BY purchase_order, item
    INTO TABLE @DATA(lt_dados) .

  SORT lt_dados BY purchase_order item.

  IF lt_dados IS NOT INITIAL.
    SELECT vbeln, posnr, vgbel, vgpos FROM lips
       FOR ALL ENTRIES IN @lt_dados
     WHERE vgbel = @lt_dados-purchase_order
       AND vgpos = @lt_dados-item
       AND bwart = '861'
      INTO TABLE @DATA(lt_dados2).

    lt_purchase_key = VALUE #( FOR ls_dados2 IN lt_dados2 ( purchase_order = ls_dados2-vgbel purchase_order_item = ls_dados2-vgpos+1(5) ) ).

    SORT lt_purchase_key. DELETE ADJACENT DUPLICATES FROM lt_purchase_key.

    IF lt_purchase_key IS NOT INITIAL.
      SELECT *
        FROM ztmm_his_dep_fec
         FOR ALL ENTRIES IN @lt_purchase_key
       WHERE purchase_order = @lt_purchase_key-purchase_order
         AND purchase_order_item = @lt_purchase_key-purchase_order_item
        INTO TABLE @DATA(lt_ztmm_his_dep_fec).

      SORT lt_ztmm_his_dep_fec BY purchase_order
                                  purchase_order_item.

      LOOP AT lt_dados2 ASSIGNING FIELD-SYMBOL(<fs_dados2>).
        READ TABLE lt_ztmm_his_dep_fec ASSIGNING FIELD-SYMBOL(<fs_ztmm_his_dep_fec>)
                                                     WITH KEY purchase_order      = <fs_dados2>-vgbel
                                                              purchase_order_item = <fs_dados2>-vgpos+1(5)
                                                              BINARY SEARCH.

        IF <fs_ztmm_his_dep_fec> IS ASSIGNED.
          <fs_ztmm_his_dep_fec>-in_delivery_document = <fs_dados2>-vbeln.
          <fs_ztmm_his_dep_fec>-in_delivery_document_item = <fs_dados2>-posnr.
        ENDIF.
      ENDLOOP.

      UPDATE ztmm_his_dep_fec FROM TABLE lt_ztmm_his_dep_fec.
    ENDIF.
  ENDIF.

  SELECT _dep_fec~*
    FROM ztmm_his_dep_fec AS _dep_fec
   INNER JOIN j_1bnfdoc AS _doc
           ON _doc~docnum = _dep_fec~out_br_nota_fiscal
          AND ( _doc~docstat = '2' OR _doc~docstat = '3' )
   WHERE _dep_fec~status = @zclmm_adm_emissao_nf_events=>gc_status-em_transito
     AND _dep_fec~out_br_nota_fiscal IS NOT INITIAL
    INTO TABLE @DATA(lt_dep_fec_atualizar).
  IF sy-subrc = 0.
    MODIFY lt_dep_fec_atualizar FROM
      VALUE #( status = zclmm_adm_emissao_nf_events=>gc_status-nota_rejeita )
      TRANSPORTING status WHERE status = zclmm_adm_emissao_nf_events=>gc_status-em_transito. "#EC CI_STDSEQ
  ENDIF.

  SELECT _dep_fec~*
    FROM ztmm_his_dep_fec AS _dep_fec
   INNER JOIN ekpo AS _ekpo
           ON _ekpo~ebeln = _dep_fec~purchase_order
          AND ( _ekpo~loekz = 'L' )
   WHERE _dep_fec~status = @zclmm_adm_emissao_nf_events=>gc_status-em_transito
     AND _dep_fec~purchase_order IS NOT INITIAL
     APPENDING TABLE @lt_dep_fec_atualizar.
  IF sy-subrc = 0.
    MODIFY lt_dep_fec_atualizar FROM
      VALUE #( status = zclmm_adm_emissao_nf_events=>gc_status-incompleto )
      TRANSPORTING status WHERE status = zclmm_adm_emissao_nf_events=>gc_status-em_transito. "#EC CI_STDSEQ
  ENDIF.

  IF lt_dep_fec_atualizar IS NOT INITIAL.
    UPDATE ztmm_his_dep_fec FROM TABLE lt_dep_fec_atualizar.
  ENDIF.

  IF p_msg = abap_false.
    MESSAGE s037(zmm_deposito_fechado).
  ELSE.
    cl_rmsl_message=>display( lt_return ).
  ENDIF.

*&---------------------------------------------------------------------*
*& Form F_VEZ_PROCESSAMENTO
*&---------------------------------------------------------------------*
FORM f_vez_processamento CHANGING cv_proc TYPE char1.

  DATA: ls_return TYPE bapiret2.

  DATA: lv_jobname  TYPE tbtcp-jobname,
        lv_jobcount TYPE tbtcp-jobcount,
        lv_strtdate TYPE tbtco-strtdate,
        lv_strttime TYPE tbtco-strttime.

  DATA(go_job) = NEW zclmm_valida_job_exec( ).
  DATA(lv_exec) = go_job->valida_exec( EXPORTING iv_program_exec = sy-cprog
                                       IMPORTING ev_jobname      = lv_jobname
                                                 ev_jobcount     = lv_jobcount
                                                 ev_strtdate     = lv_strtdate
                                                 ev_strttime     = lv_strttime
                                                 es_return       = ls_return ).

  IF lv_exec EQ abap_false.
    IF ls_return IS NOT INITIAL.
      MESSAGE ID ls_return-id TYPE 'S' NUMBER ls_return-number WITH ls_return-message_v1
                                                                    ls_return-message_v2
                                                                    ls_return-message_v3
                                                                    ls_return-message_v4
                                                                    DISPLAY LIKE 'E'.
    ELSE.
      " Existe outra execução ativa: programa &1 job &2 data &3 hora &4.
      MESSAGE s044(zmm_deposito_fechado) WITH lv_jobname
                                              lv_jobcount
                                              lv_strtdate
                                              lv_strttime
                                              DISPLAY LIKE 'E'.
    ENDIF.

    cv_proc = abap_true.
  ENDIF.

*  DATA: lv_vez_proc TYPE string.
*
*  CONSTANTS: lc_job TYPE indx_srtfd VALUE 'JOB_VEZ'.
*
*  CLEAR cv_proc.
*
*  SELECT COUNT(*)
*    FROM tbtco
*   WHERE status  = 'R'
*     AND jobname = 'ZMMR_MANTEM_DEPOSITO_FECHADO'
*    INTO @DATA(gv_num).
*
*  IF sy-subrc IS INITIAL.
*    IF gv_num > 1.
*      MESSAGE s044(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*      cv_proc = abap_true.
*      EXIT.
*    ENDIF.
*  ENDIF.
*
*  IMPORT lv_vez_proc TO lv_vez_proc FROM DATABASE indx(zm) ID lc_job.
*  IF sy-subrc IS INITIAL.
*    IF lv_vez_proc EQ 'ZMMR_MANTEM_DEPOSITO_FECHADO'.
*
*      SELECT COUNT(*)
*        FROM tbtco
*       WHERE status  = 'R'
*         AND jobname = 'ZMM_SAIDA_MERC_COM_TRANSP'
*        INTO @DATA(lv_dep_fech).
*
*      IF lv_dep_fech > 1.
*        MESSAGE s047(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*        cv_proc = abap_true.
*        EXIT.
*      ELSE.
*        lv_vez_proc = 'ZMM_SAIDA_MERC_COM_TRANSP'.
*        EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID lc_job.
*      ENDIF.
*
*    ELSE.
*
*      " Valida se o outro JOB está escalonado
*      SELECT COUNT(*)
*        FROM tbtco
*       WHERE jobname = 'ZMM_SAIDA_MERC_COM_TRANSP'
*         AND status  = 'S'.
*      IF sy-subrc IS INITIAL.
*        MESSAGE s047(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*        cv_proc = abap_true.
*        EXIT.
*      ENDIF.
*
*    ENDIF.
*  ELSE.
*    lv_vez_proc = 'ZMM_SAIDA_MERC_COM_TRANSP'.
*    EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID lc_job.
*  ENDIF.

ENDFORM.
