"!<p>Classe exceção interface inventário</p>
"!<p><strong>Autor:</strong>Marcos Rubik</p>
"!<p><strong>Data:</strong> 20 de Dezembro de 2021</p>
class ZCLMM_CX_INTERF_INVENTARIO definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

  data IV_MSGV1 type MSGV1 .
  data IV_MSGV2 type MSGV2 .
  data IV_MSGV3 type MSGV3 .
  data IV_MSGV4 type MSGV4 .
  data IT_BAPIRET2_TAB type BAPIRET2_TAB .
  constants:
  "! Estrutura mensagem 001
    BEGIN OF GC_ERRO_PROC_INVENTARIO,
        msgid TYPE symsgid VALUE 'ZMM_INTERF_INV',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF GC_ERRO_PROC_INVENTARIO .

  "! Método contrutor da classe
  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !IV_MSGV1 type MSGV1 optional
      !IV_MSGV2 type MSGV2 optional
      !IV_MSGV3 type MSGV3 optional
      !IV_MSGV4 type MSGV4 optional
      !IT_BAPIRET2_TAB type BAPIRET2_TAB optional .
  "! Método retornar erro gerados pela BAPI
  methods GET_BAPIRETURN_TAB
    returning
      value(RT_BAPIRET_TAB) type BAPIRET2_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CX_INTERF_INVENTARIO IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->IV_MSGV1 = IV_MSGV1 .
me->IV_MSGV2 = IV_MSGV2 .
me->IV_MSGV3 = IV_MSGV3 .
me->IV_MSGV4 = IV_MSGV4 .
me->IT_BAPIRET2_TAB = IT_BAPIRET2_TAB .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.


  METHOD GET_BAPIRETURN_TAB.
    APPEND INITIAL LINE TO rt_bapiret_tab ASSIGNING FIELD-SYMBOL(<fs_s_bapiret>).

    <fs_s_bapiret>-id         = if_t100_message~t100key-msgid.
    <fs_s_bapiret>-number     = if_t100_message~t100key-msgno.
    <fs_s_bapiret>-type       = 'E'.
    <fs_s_bapiret>-message_v1 = iv_msgv1.
    <fs_s_bapiret>-message_v2 = iv_msgv2.
    <fs_s_bapiret>-message_v3 = iv_msgv3.
    <fs_s_bapiret>-message_v4 = iv_msgv4.

    LOOP AT it_bapiret2_tab ASSIGNING    FIELD-SYMBOL(<fs_s_bapiret2_tab>).

      APPEND INITIAL LINE TO rt_bapiret_tab ASSIGNING <fs_s_bapiret>.

      <fs_s_bapiret> = CORRESPONDING #( <fs_s_bapiret2_tab> ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
