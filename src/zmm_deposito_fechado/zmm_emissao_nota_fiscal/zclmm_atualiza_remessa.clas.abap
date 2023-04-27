CLASS zclmm_atualiza_remessa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      executar
        IMPORTING
          it_administrar_emissao_nf TYPE zclmm_adm_emissao_nf_events=>ty_t_emissao_cds
        RETURNING
          VALUE(rt_retorno)         TYPE bapiret2_t,
      task_finish
        IMPORTING
          p_task TYPE clike.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      atualizar_remessa
        IMPORTING
          is_administrar_emissao_nf TYPE zi_mm_administrar_emissao_nf
        RETURNING
          VALUE(rt_retorno)         TYPE bapiret2_t,

      dados_cabecalho_remessa
        IMPORTING
          is_administrar_emissao_nf TYPE zi_mm_administrar_emissao_nf
        RETURNING
          VALUE(rs_retorno)         TYPE vbkok,

      definir_transport_motorista
        IMPORTING
          is_administrar_emissao_nf TYPE zi_mm_administrar_emissao_nf
        RETURNING
          VALUE(rt_retorno)         TYPE shp_partner_update_t,

      busca_bp_idnumber
        IMPORTING
          iv_businesspartner TYPE bu_partner
        RETURNING
          VALUE(rv_retorno)  TYPE  bu_id_number,

      busca_dados_transp_motorista
        IMPORTING
          iv_delivery       TYPE vbeln_vl
          iv_bp             TYPE sd_partner_parnr
          iv_tipo_bp        TYPE parvw_4
        RETURNING
          VALUE(rs_retorno) TYPE shp_partner_update.

    CONSTANTS:
      gc_funcao_transportador TYPE parvw_4 VALUE 'SP',
      gc_funcao_motorista     TYPE parvw_4 VALUE 'YM',
      gc_bp_type              TYPE bu_id_type VALUE 'HCM001',
      gc_emissao              TYPE string VALUE 'EMISSAO',
      gc_msg_type_erro        TYPE bapi_mtype VALUE 'E',
      gc_msg_number_010       TYPE symsgno VALUE '010',
      gc_msg_id_dep_fechado   TYPE symsgid VALUE 'ZMM_DEPOSITO_FECHADO'.

    DATA:
      gt_mensagens         TYPE bapiret2_t.
ENDCLASS.



CLASS ZCLMM_ATUALIZA_REMESSA IMPLEMENTATION.


  METHOD executar.
*    DATA(lt_adm) = it_administrar_emissao_nf.
*    APPEND VALUE #(
*       outbounddelivery = '0080009759'
*       shippingtype = 'FN'
*       freightmode = 'CIF'
*       equipment = 'AAA-0004'
*       shippingconditions = '08'
*       driver = '1000001798'
*       carrier = '1000000415'
*    ) TO lt_adm.

    LOOP AT it_administrar_emissao_nf ASSIGNING FIELD-SYMBOL(<fs_administrar_emissao_nf>).
      APPEND LINES OF atualizar_remessa( <fs_administrar_emissao_nf> ) TO rt_retorno.
    ENDLOOP.
  ENDMETHOD.


  METHOD atualizar_remessa.

    CALL FUNCTION 'ZFMMM_MODIFICAR_REMESSA' ##ENH_OK
      STARTING NEW TASK 'MM_MODIFICAR_REMESSA_BACKGROUND' CALLING task_finish ON END OF TASK
      EXPORTING
        iv_delivery       = is_administrar_emissao_nf-outbounddelivery
        is_vbkok_wa       = dados_cabecalho_remessa( is_administrar_emissao_nf )
        it_partner_update = definir_transport_motorista( is_administrar_emissao_nf ).

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_mensagens IS NOT INITIAL. "#EC CI_CONV_OK
    rt_retorno = gt_mensagens.
  ENDMETHOD.


  METHOD dados_cabecalho_remessa.
    rs_retorno = VALUE #(
      vbeln_vl = is_administrar_emissao_nf-outbounddelivery
      vbeln    = is_administrar_emissao_nf-outbounddelivery
      kzntg    = abap_true
      wabuc    = abap_true
      vsart    = is_administrar_emissao_nf-shippingtype
      kzvsart  = abap_true
      inco1    =  COND #( WHEN is_administrar_emissao_nf-freightmode IS INITIAL
                          THEN 'SFR'
                          ELSE is_administrar_emissao_nf-freightmode )
      kzinco1  = abap_true
      inco2    =  COND #( WHEN is_administrar_emissao_nf-freightmode IS INITIAL
                          THEN 'SFR'
                          ELSE is_administrar_emissao_nf-freightmode )
      kzinco2  = abap_true
      traid    =  is_administrar_emissao_nf-equipment
      traty    = 'SP11'
      xwmpp    = abap_true
      vsbed    = is_administrar_emissao_nf-shippingconditions
      kzvsbed  = abap_true
    ).
  ENDMETHOD.


  METHOD definir_transport_motorista.

    rt_retorno = COND #(
      LET ls_dados_transportador = busca_dados_transp_motorista(
         iv_delivery = is_administrar_emissao_nf-outbounddelivery
         iv_bp       = is_administrar_emissao_nf-carrier
         iv_tipo_bp  = gc_funcao_transportador
      ) IN
      WHEN ls_dados_transportador-parnr IS NOT INITIAL AND ls_dados_transportador-parnr <> '0000000000'
      THEN VALUE #( BASE rt_retorno ( ls_dados_transportador ) )
      ELSE rt_retorno
    ).
    rt_retorno = COND #(
      LET ls_dados_motorista = busca_dados_transp_motorista(
         iv_delivery = is_administrar_emissao_nf-outbounddelivery
         iv_bp       = is_administrar_emissao_nf-driver
         iv_tipo_bp  = gc_funcao_motorista
      ) IN
      WHEN ls_dados_motorista-parnr IS NOT INITIAL AND ls_dados_motorista-parnr <> '0000000000'
      THEN VALUE #( BASE rt_retorno ( ls_dados_motorista ) )
      ELSE rt_retorno
    ).

  ENDMETHOD.


  METHOD busca_dados_transp_motorista.

    SELECT lifnr, kunnr, pernr UP TO 1 ROWS
    FROM vbpa
    INTO @DATA(ls_bp)
    WHERE vbeln = @iv_delivery
      AND parvw = @iv_tipo_bp.
    ENDSELECT.
    DATA(lv_subrc) = sy-subrc.

    DATA(lv_updkz_par) = COND shp_updkz_par(
      WHEN lv_subrc <> 0 AND iv_bp IS NOT INITIAL
      THEN 'I'
      WHEN lv_subrc = 0  AND iv_bp IS NOT INITIAL
      THEN 'U'
      WHEN lv_subrc = 0  AND iv_bp IS INITIAL
      THEN 'D'
    ).
    rs_retorno = VALUE #(
      vbeln_vl  = iv_delivery
      parvw     = iv_tipo_bp
      updkz_par = lv_updkz_par
      parnr     = COND sd_partner_parnr(
        WHEN ( lv_updkz_par = 'I' OR lv_updkz_par = 'U' ) AND
             iv_tipo_bp = gc_funcao_motorista
        THEN busca_bp_idnumber( iv_bp )

        WHEN ( lv_updkz_par = 'I' OR lv_updkz_par = 'U' ) AND
             iv_tipo_bp = gc_funcao_transportador
        THEN iv_bp

        WHEN lv_updkz_par = 'D' AND iv_tipo_bp = gc_funcao_motorista
        THEN ls_bp-pernr

        WHEN lv_updkz_par = 'D' AND iv_tipo_bp = gc_funcao_transportador
        THEN ls_bp-lifnr
      )
    ).
  ENDMETHOD.


  METHOD busca_bp_idnumber.
    SELECT idnumber UP TO 1 ROWS FROM but0id
      INTO @rv_retorno
      WHERE partner = @iv_businesspartner
        AND type = @gc_bp_type.
    ENDSELECT.
  ENDMETHOD.


  METHOD task_finish.
    CLEAR gt_mensagens.
    RECEIVE RESULTS FROM FUNCTION 'ZFMMM_MODIFICAR_REMESSA'
      IMPORTING
        et_mensagens  = gt_mensagens.
  ENDMETHOD.
ENDCLASS.
