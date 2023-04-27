"!<p>Classe exceção interface Recebimento Fisico</p>
"!<p><strong>Autor:</strong>Rodrigo Felix</p>
"!<p><strong>Data:</strong> 18 de Abril de 2022</p>
CLASS zclmm_cx_recebimento_fisico DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    DATA gv_msgv1 TYPE msgv1 .
    DATA gv_msgv2 TYPE msgv2 .
    DATA gv_msgv3 TYPE msgv3 .
    DATA gv_msgv4 TYPE msgv4 .
    DATA gt_bapiret2_tab TYPE bapiret2_tab .
    CONSTANTS:
      "! Estrutura mensagem 001
      BEGIN OF gc_erro_proc_receb,
        msgid TYPE symsgid VALUE 'ZMM_ERROINTERFACE_ME',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_proc_receb.

    "! Método contrutor da classe
    METHODS constructor
      IMPORTING
        !is_textid       LIKE if_t100_message=>t100key OPTIONAL
        !io_previous     LIKE previous OPTIONAL
        !iv_msgv1        TYPE msgv1 OPTIONAL
        !iv_msgv2        TYPE msgv2 OPTIONAL
        !iv_msgv3        TYPE msgv3 OPTIONAL
        !iv_msgv4        TYPE msgv4 OPTIONAL
        !it_bapiret2_tab TYPE bapiret2_tab OPTIONAL .
    "! Método retornar erro gerados pela BAPI
    METHODS get_bapireturn_tab
      RETURNING
        VALUE(rt_bapiret_tab) TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclmm_cx_recebimento_fisico IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    me->gv_msgv1 = iv_msgv1 .
    me->gv_msgv2 = iv_msgv2 .
    me->gv_msgv3 = iv_msgv3 .
    me->gv_msgv4 = iv_msgv4 .
    me->gt_bapiret2_tab = it_bapiret2_tab .
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = is_textid.
    ENDIF.
  ENDMETHOD.


  METHOD get_bapireturn_tab.
    APPEND INITIAL LINE TO rt_bapiret_tab ASSIGNING FIELD-SYMBOL(<fs_s_bapiret>).

    <fs_s_bapiret>-id         = if_t100_message~t100key-msgid.
    <fs_s_bapiret>-number     = if_t100_message~t100key-msgno.
    <fs_s_bapiret>-type       = 'E'.
    <fs_s_bapiret>-message_v1 = me->gv_msgv1.
    <fs_s_bapiret>-message_v2 = me->gv_msgv2.
    <fs_s_bapiret>-message_v3 = me->gv_msgv3.
    <fs_s_bapiret>-message_v4 = me->gv_msgv4.

    LOOP AT gt_bapiret2_tab ASSIGNING    FIELD-SYMBOL(<fs_s_bapiret2_tab>).

      APPEND INITIAL LINE TO rt_bapiret_tab ASSIGNING <fs_s_bapiret>.

      <fs_s_bapiret> = CORRESPONDING #( <fs_s_bapiret2_tab> ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
