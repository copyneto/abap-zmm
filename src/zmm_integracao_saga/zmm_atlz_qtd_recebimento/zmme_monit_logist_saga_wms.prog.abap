***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Valida Cenário SAGA WMS                                *
*** AUTOR    : Alysson Anjos – META                                   *
*** FUNCIONAL: Fábio Delgado – META                                   *
*** DATA     : 25/02/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMME_MONIT_LOGIST_SAGA_WMS
*&---------------------------------------------------------------------*

 DATA: lt_hdsta     TYPE /xnfe/inhdsta_t,
       lr_bsart     TYPE RANGE OF bsart,
       lr_cnpj_dest TYPE RANGE OF /xnfe/cnpj_dest.

 CONSTANTS: BEGIN OF lc_values,
              stocktrf  TYPE /xnfe/proctyp        VALUE 'STOCKTRF',
              normprch  TYPE /xnfe/proctyp        VALUE 'NORMPRCH',
              authgrpt  TYPE /xnfe/proctyp        VALUE 'AUTHGRPT',
              accnotif  TYPE  /xnfe/proctyp       VALUE 'ACCNOTIF',
              stocvald  TYPE  /xnfe/proctyp       VALUE 'STOCVALD',
              grconfgu  TYPE /xnfe/baseproctyp    VALUE 'GRCONFQU',
              report    TYPE syst_cprog           VALUE 'ZMMR_SAGA_RECEBIMENTOS',
              grpostng  TYPE syst_cprog           VALUE 'GRPOSTNG',
              grstopst  TYPE syst_cprog           VALUE 'GRSTOPST',
              a         TYPE char1                VALUE 'A',
              entrega   TYPE /scmtms/base_btd_tco VALUE '58',
              mm        TYPE ze_param_modulo      VALUE 'MM',
              dep_fech  TYPE ze_param_chave       VALUE 'DEPOSITO_FECHADO',
              saga      TYPE ze_param_chave       VALUE 'SAGA',
              bsart     TYPE ze_param_chave_3     VALUE 'BSART',
              cnpj_dest TYPE ze_param_chave       VALUE 'CNPJ_CENTRO',
            END OF lc_values.

 DATA(lv_ebeln_vld) = VALUE #( et_nfeit[ 1 ]-ponumber OPTIONAL ).

 IF ( ( es_nfehd-proctyp    EQ lc_values-stocktrf    OR " Transferência
        es_nfehd-proctyp    EQ lc_values-normprch ) AND " Pedido Normal / Coligado
        es_nfehd-last_step  EQ lc_values-authgrpt )  OR " Status autorização
        sy-cprog            EQ lc_values-report.        " Programa Liberação de mercadoria

   DATA(ls_assign) = VALUE #( et_assign[ 1 ] OPTIONAL ).

   IF ls_assign-pomatnr  IS INITIAL
   OR ls_assign-ponumber IS INITIAL
   OR ls_assign-poitem   IS INITIAL.

     DATA(lv_ebeln_atb) = VALUE #( et_nfeit[ 1 ]-ponumber OPTIONAL ).
     DATA(lv_ebelp_atb) = VALUE #( et_nfeit[ 1 ]-poitem OPTIONAL ).
     DATA(lv_matnr_atb) = VALUE #( et_nfeit[ 1 ]-cprod OPTIONAL ).

     SELECT SINGLE ebeln,
                   ebelp,
                   matnr
       FROM ekpo
      WHERE ebeln = @lv_ebeln_atb
        AND ebelp = @lv_ebelp_atb
        AND matnr = @lv_matnr_atb
       INTO @DATA(ls_ekpo).

     IF sy-subrc IS NOT INITIAL.
       lv_ebelp_atb = lv_ebelp_atb * 10.

       SELECT SINGLE ebeln,
                     ebelp,
                     matnr
         FROM ekpo
        WHERE ebeln = @lv_ebeln_atb
          AND ebelp = @lv_ebelp_atb
          AND matnr = @lv_matnr_atb
         INTO @ls_ekpo.
     ENDIF.

     IF sy-subrc IS INITIAL.
       ls_assign-pomatnr  = ls_ekpo-matnr.
       ls_assign-ponumber = ls_ekpo-ebeln.
       ls_assign-poitem   = ls_ekpo-ebelp.
     ENDIF.
   ENDIF.

   IF ls_assign IS NOT INITIAL.

     DATA(ls_key_saga) = VALUE zsmm_key_env_saga( matnr    = ls_assign-pomatnr
                                                  ponumber = ls_assign-ponumber
                                                  poitem   = ls_assign-poitem ).

*   IF NEW zclmm_conf_dados_recebmnt( )->validar_pedido( lv_ebeln_vld ) EQ abap_true.
     IF NEW zclmm_conf_dados_recebmnt( )->validar_env_saga( ls_key_saga ) EQ abap_true.

       IF sy-cprog NE lc_values-report.

         DATA(ls_result) = VALUE #( et_hdsta[ procstep = lc_values-grconfgu
                                              deactiv  = abap_true ] OPTIONAL ).
         IF ls_result IS NOT INITIAL.
           EXIT.
         ENDIF.

       ELSE.

         ls_result = VALUE #( et_hdsta[ procstep = COND #( WHEN es_nfehd-proctyp = lc_values-stocktrf THEN lc_values-grstopst
                                                           WHEN es_nfehd-proctyp = lc_values-normprch THEN lc_values-grpostng )
                                        autoproc = lc_values-a ] OPTIONAL ).
         IF ls_result IS NOT INITIAL.
           EXIT.
         ENDIF.
       ENDIF.

       NEW zclmm_conf_dados_recebmnt( )->processar_stock( EXPORTING iv_guid  = lv_guid_header
                                                                    iv_cnpj  = es_nfehd-cnpj_emit
                                                                    iv_nnf   = es_nfehd-nnf
                                                                    iv_step  = es_nfehd-proctyp
                                                          CHANGING  ct_hdsta = et_hdsta[] ).
     ENDIF.
   ENDIF.
 ENDIF.

 TRY.
     DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

     lo_param->m_get_range( EXPORTING iv_modulo = lc_values-mm
                                      iv_chave1 = lc_values-cnpj_dest
                            IMPORTING et_range  = lr_cnpj_dest ).
   CATCH zcxca_tabela_parametros.
 ENDTRY.

 " Enviar SAGA
 IF ( es_nfehd-proctyp     EQ lc_values-stocktrf    AND  " Transferência
      es_nfehd-last_step   EQ lc_values-stocvald    AND
      es_nfehd-cnpj_dest   IN lr_cnpj_dest ) OR
    ( es_nfehd-proctyp     EQ lc_values-normprch    AND  " Pedido Normal / Coligado
      es_nfehd-last_step   EQ lc_values-accnotif ).

   CLEAR ls_assign.
   ls_assign = VALUE #( et_assign[ 1 ] OPTIONAL ).

   IF ls_assign-pomatnr  IS INITIAL
   OR ls_assign-ponumber IS INITIAL
   OR ls_assign-poitem   IS INITIAL.

     CLEAR: lv_ebeln_atb,
            lv_ebelp_atb.

     lv_ebeln_atb = VALUE #( et_nfeit[ 1 ]-ponumber OPTIONAL ).
     lv_ebelp_atb = VALUE #( et_nfeit[ 1 ]-poitem OPTIONAL ).
     lv_matnr_atb = VALUE #( et_nfeit[ 1 ]-cprod OPTIONAL ).

     SELECT SINGLE ebeln,
                   ebelp,
                   matnr
       FROM ekpo
      WHERE ebeln = @lv_ebeln_atb
        AND ebelp = @lv_ebelp_atb
        AND matnr = @lv_matnr_atb
       INTO @ls_ekpo.

     IF sy-subrc IS NOT INITIAL.
       lv_ebelp_atb = lv_ebelp_atb * 10.

       SELECT SINGLE ebeln,
                     ebelp,
                     matnr
         FROM ekpo
        WHERE ebeln = @lv_ebeln_atb
          AND ebelp = @lv_ebelp_atb
          AND matnr = @lv_matnr_atb
         INTO @ls_ekpo.
     ENDIF.

     IF sy-subrc IS INITIAL.
       ls_assign-pomatnr  = ls_ekpo-matnr.
       ls_assign-ponumber = ls_ekpo-ebeln.
       ls_assign-poitem   = ls_ekpo-ebelp.
     ENDIF.
   ENDIF.

   IF ls_assign IS NOT INITIAL.

     ls_key_saga = VALUE zsmm_key_env_saga( matnr    = ls_assign-pomatnr
                                            ponumber = ls_assign-ponumber
                                            poitem   = ls_assign-poitem ).

*   IF NEW zclmm_conf_dados_recebmnt( )->validar_pedido( lv_ebeln_vld ) EQ abap_true.
     IF NEW zclmm_conf_dados_recebmnt( )->validar_env_saga( ls_key_saga ) EQ abap_true.

       SELECT SINGLE nfenum
         FROM ztmm_wms_receb
        WHERE nfenum    EQ @es_nfehd-nnf
          AND idnfenum  EQ @es_nfehd-guid_header
         INTO @DATA(ls_resul).

       IF sy-subrc NE 0.

         IF es_nfehd-proctyp EQ lc_values-stocktrf.

           DATA(lv_ebeln) = VALUE #( et_assign[ 1 ]-ponumber OPTIONAL ).
           DATA(lv_ebelp) = VALUE #( et_assign[ 1 ]-poitem   OPTIONAL ).

           IF lv_ebeln IS INITIAL
           OR lv_ebelp IS INITIAL.
             lv_ebeln = VALUE #( et_nfeit[ 1 ]-ponumber OPTIONAL ).
             lv_ebelp = VALUE #( et_nfeit[ 1 ]-poitem   OPTIONAL ).
           ENDIF.

           DATA(lv_item) = CONV /xnfe/poitem( 10 * lv_ebelp ).

           SELECT SINGLE MAX( ebeln ) AS ebeln,
                         MAX( vbeln ) AS vbeln,
                         MAX( xblnr ) AS xblnr
             FROM ekes
             INTO @DATA(ls_ekes)
            WHERE ebeln EQ @lv_ebeln
              AND ebelp IN ( @lv_ebelp, @lv_item ).

           IF sy-subrc IS NOT INITIAL
           OR ( sy-subrc IS INITIAL AND ls_ekes-xblnr IS INITIAL ).
             SELECT ebeln,
                    vbeln_st,
                    xblnr
               FROM ekbe
              WHERE ebeln EQ @lv_ebeln
                AND ebelp IN ( @lv_ebelp, @lv_item )
                AND xblnr IS NOT INITIAL
               INTO @DATA(ls_ekbe)
                 UP TO 1 ROWS.
             ENDSELECT.

             IF sy-subrc IS INITIAL.
               ls_ekes-ebeln = ls_ekbe-ebeln.
               ls_ekes-vbeln = ls_ekbe-vbeln_st.
               ls_ekes-xblnr = ls_ekbe-xblnr.
             ENDIF.
           ENDIF.

         ELSEIF es_nfehd-proctyp EQ lc_values-normprch.

           DATA(lv_xblnr) = es_nfehd-nnf && '%'.

           SELECT SINGLE MAX( ebeln ) AS ebeln,
                         MAX( vbeln ) AS vbeln,
                         MAX( xblnr ) AS xblnr
             FROM ekes
             INTO @ls_ekes
            WHERE xblnr LIKE @lv_xblnr.

           IF sy-subrc EQ 0.
             lv_ebeln = ls_ekes-ebeln.
           ENDIF.

         ENDIF.

         IF ls_ekes IS NOT INITIAL.

           SELECT SINGLE spe_lifex_type
             FROM likp
             INTO @DATA(lv_spe_lifex_type)
            WHERE vbeln EQ @ls_ekes-vbeln.

           IF sy-subrc EQ 0.

             CALL FUNCTION 'ZFMMM_SAGA_ENVIO_PRE_REGISTRO'
               STARTING NEW TASK 'ENVIO_REMESSA'
               EXPORTING
                 iv_remessa = ls_ekes-vbeln
                 iv_xblnr   = ls_ekes-xblnr
                 iv_innfehd = es_nfehd
                 iv_ebeln   = lv_ebeln
                 iv_entrega = lc_values-entrega.

             WAIT UP TO 2 SECONDS.

           ENDIF.

         ENDIF.

       ENDIF.
     ENDIF.
   ENDIF.
 ENDIF.
