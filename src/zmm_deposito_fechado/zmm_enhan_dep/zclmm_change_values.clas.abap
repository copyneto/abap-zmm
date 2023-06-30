CLASS zclmm_change_values DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      "! CFOP field change
      change_cfop
        CHANGING
          cv_cfop TYPE j_1bag-cfop,

      "! Triggers of bapi's
      trigger_bapis
        IMPORTING
          iv_INVNUMBER TYPE /xnfe/invnumber
          iv_year      TYPE /xnfe/byear
          is_header    TYPE /xnfe/innfehd
          it_item      TYPE /xnfe/erp_in_item_t
        EXPORTING
          et_return    TYPE bapirettab.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_value,
                 mm                      TYPE ze_param_modulo       VALUE 'MM',
                 remessa_fisica          TYPE ze_param_chave        VALUE 'REMESSA_FISICA',
                 remessa_simbolica_dupl  TYPE ze_param_chave        VALUE 'REM_SIMBA_DUPL',
                 retorno_fisico_saida    TYPE ze_param_chave        VALUE 'RETORNO_FISICO_SAIDA',
                 retorno_simbolico_saida TYPE ze_param_chave        VALUE 'RETORNO_SIMB_SAIDA',
                 cfop                    TYPE ze_param_chave        VALUE 'CFOP',
                 estadual                TYPE ze_param_chave_3      VALUE 'ESTADUAL',
                 interestadual           TYPE ze_param_chave_3      VALUE 'INTEREST',
                 enhan                   TYPE ze_param_chave        VALUE 'ENHACEMENT_GAP376',
                 parc                    TYPE ze_param_chave        VALUE 'FUNCAO_PARCEIRO',
                 dep                     TYPE ze_param_chave        VALUE 'DEPOSITO_FECHADO',
                 centro                  TYPE ze_param_chave        VALUE 'CENTRO',
                 mg                      TYPE char3                 VALUE 'MG',
                 zdf                     TYPE bsart                 VALUE 'ZDF',
                 f02                     TYPE ze_mm_df_process_step VALUE 'F02',
                 f05                     TYPE ze_mm_df_process_step VALUE 'F05',
                 f06                     TYPE ze_mm_df_process_step VALUE 'F06',
                 f12                     TYPE ze_mm_df_process_step VALUE 'F12',
                 f13                     TYPE ze_mm_df_process_step VALUE 'F13',
                 n5                      TYPE i                     VALUE 5,
                 n6                      TYPE i                     VALUE 6,
                 zdep                    TYPE char4                 VALUE 'ZDEP',
                 bwart_862               TYPE bwart                 VALUE '862',
               END OF gc_value.

    DATA: gv_vgbel       TYPE vgbel,
          gv_vgpos       TYPE vgpos,
          gs_his_dep_fec TYPE ztmm_his_dep_fec,
          gv_bwart       TYPE bwart.

    METHODS:

      "! Get data memory
      get_memory
        EXPORTING
          ev_vgbel TYPE vgbel
          ev_vgpos TYPE vgpos,

      "! CFOP field modify
      mod_cfop
        CHANGING
          cv_cfop TYPE j_1bag-cfop,

      "! Get data
      get_data
        RETURNING
          VALUE(rv_result) TYPE bsart,

      "! Get parameter table
      select_parameter
        IMPORTING
          iv_mod   TYPE ze_param_modulo
          iv_c1    TYPE ze_param_chave
          iv_c2    TYPE ze_param_chave   OPTIONAL
          iv_c3    TYPE ze_param_chave_3 OPTIONAL
        EXPORTING
          ev_param TYPE any ,

      "! Werks field validate
      validate_werks
        EXPORTING
          ev_ok TYPE char1,

      "! Hangs for the process to start
      lock_enhacement
        RETURNING
          VALUE(rt_result) TYPE char1,

      "!" Validate the PARID and PARVW fields
      parid_parvw
        IMPORTING
          iv_INVNUMBER     TYPE /xnfe/invnumber
        RETURNING
          VALUE(rt_result) TYPE char1.
ENDCLASS.



CLASS ZCLMM_CHANGE_VALUES IMPLEMENTATION.


  METHOD change_cfop.

    DATA(lv_continue) = me->lock_enhacement(  ).

    IF lv_continue EQ abap_true.

      me->get_memory( IMPORTING ev_vgbel = gv_vgbel
                                ev_vgpos = gv_vgpos ).

      IF  gv_vgbel IS NOT INITIAL
      AND gv_vgpos IS NOT INITIAL.

        me->mod_cfop( CHANGING cv_cfop = cv_cfop ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_memory.

*    IMPORT e_lips-vgbel TO ev_vgbel
*           e_lips-vgpos TO ev_vgpos FROM MEMORY ID gc_value-zdep.

    FIELD-SYMBOLS
                   <fs_lips> TYPE lips.

    ASSIGN ('(SAPLV50S)LIPS') TO <fs_lips>.

    IF <fs_lips> IS ASSIGNED.
      ev_vgbel = <fs_lips>-vgbel.
      ev_vgpos = <fs_lips>-vgpos.
      gv_bwart = <fs_lips>-bwart.
    ENDIF.

  ENDMETHOD.


  METHOD mod_cfop.

    DATA(lv_bsart) = me->get_data(  ).

    IF lv_bsart EQ gc_value-zdf.

      cv_cfop = cv_cfop(1).

      CASE cv_cfop.
        WHEN gc_value-n5.

          IF gs_his_dep_fec-carrier IS INITIAL.
            me->validate_werks( IMPORTING ev_ok = DATA(lv_bsart_ok) ).
          ENDIF.

          me->select_parameter(
          EXPORTING
              iv_mod = gc_value-mm
              iv_c1  = COND #( WHEN gs_his_dep_fec-process_step = gc_value-f02 THEN  COND #( WHEN lv_bsart_ok EQ abap_true AND gv_bwart NE gc_value-bwart_862 THEN gc_value-remessa_simbolica_dupl  ELSE gc_value-remessa_fisica   )
                               WHEN gs_his_dep_fec-process_step = gc_value-f06 THEN  COND #( WHEN lv_bsart_ok EQ abap_true AND gv_bwart EQ gc_value-bwart_862 THEN gc_value-remessa_simbolica_dupl  ELSE gc_value-remessa_fisica   )
                               WHEN gs_his_dep_fec-process_step = gc_value-f05 THEN  COND #( WHEN gs_his_dep_fec-carrier IS INITIAL THEN gc_value-retorno_simbolico_saida ELSE gc_value-retorno_fisico_saida  )
                               WHEN gs_his_dep_fec-process_step = gc_value-f12 THEN  COND #( WHEN lv_bsart_ok EQ abap_true  THEN gc_value-retorno_simbolico_saida ELSE gc_value-retorno_fisico_saida  )
                               WHEN gs_his_dep_fec-process_step = gc_value-f13 THEN  COND #( WHEN lv_bsart_ok EQ abap_false THEN gc_value-retorno_fisico_saida    ELSE gc_value-retorno_simbolico_saida ) )
              iv_c2  = gc_value-cfop
              iv_c3  = gc_value-estadual
          IMPORTING
              ev_param = cv_cfop
           ).


        WHEN gc_value-n6.

          IF gs_his_dep_fec-carrier IS INITIAL.
            me->validate_werks( IMPORTING ev_ok = lv_bsart_ok ).
          ENDIF.

          me->select_parameter(
          EXPORTING
              iv_mod = gc_value-mm
              iv_c1  = COND #( WHEN gs_his_dep_fec-process_step = gc_value-f02  THEN  COND #( WHEN lv_bsart_ok EQ abap_true AND gv_bwart NE gc_value-bwart_862 THEN gc_value-remessa_simbolica_dupl  ELSE gc_value-remessa_fisica )
                               WHEN gs_his_dep_fec-process_step = 'F06'  THEN  COND #( WHEN lv_bsart_ok EQ abap_true AND gv_bwart EQ gc_value-bwart_862 THEN gc_value-remessa_simbolica_dupl  ELSE gc_value-remessa_fisica )
                               WHEN gs_his_dep_fec-process_step = gc_value-f05  THEN  COND #( WHEN gs_his_dep_fec-carrier IS INITIAL THEN gc_value-retorno_simbolico_saida ELSE gc_value-retorno_fisico_saida )
                               WHEN gs_his_dep_fec-process_step = gc_value-f12  THEN  COND #( WHEN lv_bsart_ok EQ abap_true  THEN gc_value-retorno_simbolico_saida ELSE gc_value-retorno_fisico_saida )
                               WHEN gs_his_dep_fec-process_step = gc_value-f13  THEN  COND #( WHEN lv_bsart_ok EQ abap_false THEN gc_value-retorno_fisico_saida    ELSE gc_value-retorno_simbolico_saida ) )
              iv_c2  = gc_value-cfop
              iv_c3  = gc_value-interestadual
          IMPORTING
              ev_param = cv_cfop
           ).

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD get_data.

    SELECT SINGLE bsart FROM ekko
    WHERE ebeln EQ @gv_vgbel
       INTO @rv_result.

    SELECT SINGLE * FROM ztmm_his_dep_fec
    WHERE purchase_order EQ @gv_vgbel
       INTO @gs_his_dep_fec.


  ENDMETHOD.


  METHOD select_parameter.

    TRY.

        NEW zclca_tabela_parametros( )->m_get_single(
        EXPORTING
            iv_modulo = iv_mod
            iv_chave1 = iv_c1
            iv_chave2 = iv_c2
            iv_chave3 = iv_c3
        IMPORTING
            ev_param = ev_param
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD validate_werks.

    CLEAR: ev_ok.

    SELECT SINGLE * FROM t001w
    WHERE werks = @gs_his_dep_fec-plant
      AND regio = @gc_value-mg
         INTO @DATA(ls_ret).

    IF sy-subrc EQ 0.
      ev_ok = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD trigger_bapis.

    DATA(lv_continue) = me->lock_enhacement(  ).

    IF lv_continue EQ abap_true.

      DATA(lv_validate) = me->parid_parvw( iv_invnumber ).

      IF lv_validate EQ abap_true.


        DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

        lo_events->continue_document_creation( EXPORTING iv_invnumber = iv_invnumber
                                                         iv_year      = iv_year
                                                         is_header    = is_header
                                                         it_item      = it_item
                                               IMPORTING et_return    = DATA(lt_return1) ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD lock_enhacement.

    me->select_parameter(
              EXPORTING
                  iv_mod = gc_value-mm
                  iv_c1  = gc_value-enhan
              IMPORTING
                  ev_param = rt_result
               ).

  ENDMETHOD.


  METHOD parid_parvw.

    DATA: lv_param TYPE ztca_param_val,
          lt_val   TYPE STANDARD TABLE OF ztca_param_val.

    SELECT SINGLE * FROM ztmm_his_dep_fec
    WHERE main_purchase_order EQ @iv_invnumber
       INTO @gs_his_dep_fec.

    IF sy-subrc EQ 0.

      TRY.

          NEW zclca_tabela_parametros( )->m_get_range(
          EXPORTING
              iv_modulo = gc_value-mm
              iv_chave1 = gc_value-parc
              iv_chave2 = gc_value-dep
          IMPORTING
              et_range = lt_val
          ).

          IF line_exists( lt_val[ low = gs_his_dep_fec-origin_plant_type ] ).

            IF line_exists( lt_val[ chave3 = gc_value-centro
                                    low    = gs_his_dep_fec-origin_plant ] ).
              rt_result = abap_true.
            ENDIF.

          ENDIF.

        CATCH zcxca_tabela_parametros.

      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
