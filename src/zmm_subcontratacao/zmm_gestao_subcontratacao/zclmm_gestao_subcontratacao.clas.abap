class ZCLMM_GESTAO_SUBCONTRATACAO definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_parameter,
        ativa TYPE flag,                          " Ativa/desativa lógica
        bwart TYPE RANGE OF mseg-bwart,           " Tipo de movimento
      END OF ty_parameter .

  class-data GS_PARAMETER type TY_PARAMETER .
  class-data GO_SUBCONTRATACAO type ref to ZCLMM_GESTAO_SUBCONTRATACAO .
  constants GC_NFTYPE_YC type J_1BNFDOC-NFTYPE value 'YC' ##NO_TEXT. " Nota fiscal saída de mercadorias - NFe

    "! Recupera instância (Classe Singleton)
    "! @parameter ro_subcontratacao | Subcontratação
  class-methods GET_INSTANCE
    returning
      value(RO_SUBCONTRATACAO) type ref to ZCLMM_GESTAO_SUBCONTRATACAO .
  methods DETERMINE_BATCH
    importing
      !IS_MSEG type MSEG
      !IS_VM07M type VM07M
      !IS_DM07M type DM07M
      !IS_MKPF type MKPF
      !IV_TRANSFER type DM07M-KZUML
    exporting
      !ET_RETURN type BAPIRET2_T
    changing
      !CV_CHARG type MCHA-CHARG .
  methods DETERMINE_MOVEMENT_TYPE
    importing
      !IT_NFE_IN_ITEM type J_1BNFE_COMPONENT_RETURN_TAB
      !IV_BWART type BWART
    changing
      !CT_IMSEG type TY_T_IMSEG
      !CT_BAPIRET2 type BAPIRETTAB .
  methods DETERMINE_TCODE
    importing
      !IT_IMSEG type TY_T_IMSEG
    changing
      !CV_TCODE type TCODE .
  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING
        !es_parameter TYPE ty_parameter
        !et_return    TYPE bapiret2_t.

    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter ev_value | Valor cadastrado
    "! @parameter et_value | Valor cadastrado (Range)
    METHODS get_parameter
      IMPORTING is_param TYPE ztca_param_val
      EXPORTING ev_value TYPE any
                et_value TYPE any.

    "! Formata as mensagens de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      IMPORTING iv_change_error_type   TYPE flag OPTIONAL
                iv_change_warning_type TYPE flag OPTIONAL
      CHANGING  ct_return              TYPE bapiret2_t.

ENDCLASS.



CLASS ZCLMM_GESTAO_SUBCONTRATACAO IMPLEMENTATION.


  METHOD get_instance.

* ---------------------------------------------------------------------------
* Verifica e cria apenas uma vez a instância desta classe
* ---------------------------------------------------------------------------
    IF go_subcontratacao IS NOT BOUND.
      CREATE OBJECT go_subcontratacao.
    ENDIF.

    ro_subcontratacao = go_subcontratacao.

  ENDMETHOD.


  METHOD determine_batch.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Valida parâmetros
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Verifica se parâmetro está ativo
    IF ls_parameter-ativa NE abap_true.
      RETURN.
    ENDIF.

    " Valida tipo de movimento
    IF NOT ( is_mseg-bwart IN ls_parameter-bwart[] AND ls_parameter-bwart IS NOT INITIAL ).
      RETURN.
    ENDIF.

    DATA(lv_nfenum) = CONV j_1bnfnum9( is_mkpf-bktxt ).

* ---------------------------------------------------------------------------
* Recupera dados da Nota Fiscal de referência
* ---------------------------------------------------------------------------
    SELECT doc~docnum,
           lin~itmnum,
           lin~matnr,
           lin~charg
        FROM j_1bnfdoc AS doc
        INNER JOIN j_1bnflin AS lin
           ON doc~docnum = lin~docnum
        WHERE doc~nfenum = @lv_nfenum
          AND doc~nftype = @gc_nftype_yc
        INTO TABLE @DATA(lt_doc).

    IF sy-subrc NE 0.
      " Nº Documento para NF-e ref. &1 não encontrada.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_SUBCONTRTC' number = '052' message_v1 = lv_nfenum ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

    " Recupera última Nota Fiscal
    TRY.
        SORT lt_doc BY docnum DESCENDING.
        DATA(lv_docnum) = lt_doc[ 1 ]-docnum.
      CATCH cx_root.
        RETURN.
    ENDTRY.

* ---------------------------------------------------------------------------
* Atualiza lote
* ---------------------------------------------------------------------------
    SORT lt_doc BY docnum matnr.

    READ TABLE lt_doc REFERENCE INTO DATA(ls_doc) WITH KEY docnum = lv_docnum
                                                           matnr  = is_mseg-matnr
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      cv_charg = ls_doc->charg.

      " Lote atualizado com sucesso.
      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZMM_SUBCONTRTC' number = '053' ) ).
      me->format_return( CHANGING ct_return = et_return ).

*      IF is_mseg-bwart EQ '542'. "Trecho ref. a baixa do processo de perda de indus.
*
*        CALL FUNCTION 'ZFMMM_GMVT_SUBC' IN UPDATE TASK
*          EXPORTING
*            i_mseg   = is_mseg
*            iv_charg = ls_doc->charg.
*
*      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD determine_movement_type.

* ---------------------------------------------------------------------------
* Valida parâmetros
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Verifica se parâmetro está ativo
    IF ls_parameter-ativa NE abap_true.
      RETURN.
    ENDIF.

    " Valida tipo de movimento
    IF NOT ( iv_bwart IN ls_parameter-bwart[] AND ls_parameter-bwart IS NOT INITIAL ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Como solução paliativa, estamos substituindo os tipos de movimentos vindo do GRC para 'Z18'
* ---------------------------------------------------------------------------
    LOOP AT ct_imseg REFERENCE INTO DATA(ls_imseg).
      ls_imseg->bwart = 'Z18'.
      ls_imseg->sobkz = 'O'.
*      ls_imseg->lifnr = '1000000152'.
    ENDLOOP.

  ENDMETHOD.


  METHOD determine_tcode.

* ---------------------------------------------------------------------------
* Valida parâmetros
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Verifica se parâmetro está ativo
    IF ls_parameter-ativa NE abap_true.
      RETURN.
    ENDIF.

    TRY.
        DATA(ls_imseg) = it_imseg[ 1 ].
      CATCH cx_root.
    ENDTRY.

    " Valida tipo de movimento
    IF NOT ( ls_imseg-bwart IN ls_parameter-bwart[] AND ls_parameter-bwart IS NOT INITIAL ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Como solução paliativa, estamos substituindo a transação default 'MB1B' para 'MB1A'
* ---------------------------------------------------------------------------
    cv_tcode = 'MB1A'.

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera parâmetro de ativa/desativa
* ---------------------------------------------------------------------------
    IF me->gs_parameter-ativa IS INITIAL.

      DATA(ls_parameter) = VALUE ztca_param_val( modulo = gc_param_ativa-modulo
                                                 chave1 = gc_param_ativa-chave1
                                                 chave2 = gc_param_ativa-chave2
                                                 chave3 = gc_param_ativa-chave3 ).

      me->get_parameter( EXPORTING is_param  = ls_parameter
                         IMPORTING ev_value  = me->gs_parameter-ativa ).

    ENDIF.

    IF me->gs_parameter-ativa IS INITIAL.
      " Parâmetro desativado até o fim do processamento
      me->gs_parameter-ativa = 'N'.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Tipo de movimento
* ---------------------------------------------------------------------------
    IF me->gs_parameter-bwart IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_bwart-modulo
                                           chave1 = gc_param_bwart-chave1
                                           chave2 = gc_param_bwart-chave2
                                           chave3 = gc_param_bwart-chave3 ).

      me->get_parameter( EXPORTING is_param  = ls_parameter
                         IMPORTING et_value  = me->gs_parameter-bwart[] ).

    ENDIF.

    IF me->gs_parameter-bwart IS INITIAL.
      " Param. 'Tipo de movimento' não cadastrado: [&1/&2/&3/&4]
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_SUBCONTRTC' number = '051'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
      me->format_return( CHANGING ct_return = et_return ).
    ENDIF.

* ---------------------------------------------------------------------------
* Transfere parâmetros
* ---------------------------------------------------------------------------
    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD get_parameter.

    FREE: et_value.

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

        " Recupera tipo de movimento
        IF ev_value IS SUPPLIED.
          lo_param->m_get_single( EXPORTING iv_modulo = is_param-modulo
                                            iv_chave1 = is_param-chave1
                                            iv_chave2 = is_param-chave2
                                            iv_chave3 = is_param-chave3
                                  IMPORTING ev_param  = ev_value ).
        ENDIF.

        " Recupera lista de valores
        IF et_value IS SUPPLIED.
          lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                           iv_chave1 = is_param-chave1
                                           iv_chave2 = is_param-chave2
                                           iv_chave3 = is_param-chave3
                                 IMPORTING et_range  = et_value ).
        ENDIF.

      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.


  METHOD format_return.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_Return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
