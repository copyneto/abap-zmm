CLASS zclmm_libpg_grvde_op DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zifmm_lib_pgto_graoverde .

    "!
    "! @parameter iv_oper | Tipo de operação financeira
    "! @parameter ro_ref | Referência de objeto
    CLASS-METHODS factory
      IMPORTING iv_oper       TYPE char1
      RETURNING VALUE(ro_ref) TYPE REF TO zifmm_lib_pgto_graoverde.

    "! Returns messages
    "! @parameter rt_messages | Table of messages
    METHODS get_messages RETURNING VALUE(rt_messages) TYPE bapiret2_tab.

protected section.

  constants GC_WAERS type WAERS value 'BRL' ##NO_TEXT.
  data GT_RETURN type BAPIRET2_TAB .
  data GV_WAIT type ABAP_BOOL .
  data GV_TYPE type BAPIACHE09-OBJ_TYPE .
  data GV_KEY type BAPIACHE09-OBJ_KEY .
  data GV_SYS type BAPIACHE09-OBJ_SYS .
  data:
    gt_properties  TYPE TABLE OF zi_mm_lib_pgto_fat .
  data GT_DESCONTOS type ZIFMM_LIB_PGTO_GRAOVERDE=>TT_DESC .
  data:
    gt_tipodoc_rng TYPE RANGE OF blart .
  data GV_XREF1 type XREF1_HD .
  data GV_XREF2 type XREF2_HD .
  data GV_GUID type SYSUUID_X16 .
  data GV_NFENUM type J_1BNFNUM9 .

  methods GET_PARAMETER
    importing
      !IV_MODULO type ZE_PARAM_MODULO
      !IV_CHAVE1 type ZE_PARAM_CHAVE
      !IV_CHAVE2 type ZE_PARAM_CHAVE
    exporting
      !ET_PARAM type TABLE .
  methods ADD_MESSAGE_2_BAPIRET
    importing
      !IV_MSGID type SYMSGID
      !IV_MSGTY type SYMSGTY
      !IV_MSGNO type SYMSGNO
      !IV_MSGV1 type SYMSGV optional
      !IV_MSGV2 type SYMSGV optional
      !IV_MSGV3 type SYMSGV optional
      !IV_MSGV4 type SYMSGV optional .
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCLMM_LIBPG_GRVDE_OP IMPLEMENTATION.


  METHOD factory.

    CASE iv_oper.
      WHEN zifmm_lib_pgto_graoverde=>gc_tipo-transferComp.
        ro_ref ?= NEW zclmm_libpg_grvde_transf( ).
      WHEN zifmm_lib_pgto_graoverde=>gc_tipo-retiradaBloq.
        ro_ref ?= NEW zclmm_libpg_grvde_block( ).
      WHEN OTHERS.
        ro_ref ?= NEW zclmm_libpg_grvde_disc( )->zifmm_lib_pgto_graoverde_desc~create( iv_tipo = iv_oper ).
    ENDCASE.

  ENDMETHOD.


  METHOD get_parameter.

    TRY.

        NEW zclca_tabela_parametros( )->m_get_range(
          EXPORTING
            iv_modulo = iv_modulo
            iv_chave1 = iv_chave1
            iv_chave2 = iv_chave2
          IMPORTING
            et_range  = et_param ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.


  METHOD zifmm_lib_pgto_graoverde~executar.

*    IF NOT line_exists( me->gt_return[ type = if_abap_behv_message=>severity-error ] ).
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*    ELSE.
*      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*    ENDIF.

  ENDMETHOD.


  METHOD add_message_2_bapiret.

    cl_fkk_xi_facade=>add_message_to_bapiret2( EXPORTING i_msgid    = iv_msgid
                                                         i_msgty    = iv_msgty
                                                         i_msgno    = iv_msgno
                                                         i_msgv1    = iv_msgv1
                                                         i_msgv2    = iv_msgv2
                                                         i_msgv3    = iv_msgv3
                                                         i_msgv4    = iv_msgv4
                                                CHANGING t_bapiret2 = me->gt_return ).

  ENDMETHOD.


  METHOD get_messages.
    rt_messages = me->gt_return.
  ENDMETHOD.


  METHOD zifmm_lib_pgto_graoverde~set_properties.

    DATA: lv_idx TYPE i.

    FIELD-SYMBOLS: <fs_tab_values>  TYPE ANY TABLE.

    ASSIGN it_properties->* TO <fs_tab_values>.

    LOOP AT <fs_tab_values> ASSIGNING FIELD-SYMBOL(<fs_value_row>).

      lv_idx = 1.

      APPEND INITIAL LINE TO me->gt_properties ASSIGNING FIELD-SYMBOL(<fs_new_row>).

      DO.

        ASSIGN COMPONENT lv_idx OF STRUCTURE <fs_value_row> TO FIELD-SYMBOL(<fs_new_value>).

        IF sy-subrc NE 0.
          EXIT.
        ENDIF.

        ASSIGN COMPONENT lv_idx OF STRUCTURE <fs_new_row> TO FIELD-SYMBOL(<fs_value>).

        <fs_value> = <fs_new_value>.

        lv_idx += 1.

      ENDDO.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
