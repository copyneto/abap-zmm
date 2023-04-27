CLASS zcxmm_lpp_calc DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF gc_generic_error,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_generic_error.

    CONSTANTS:
      BEGIN OF gc_erro_iva_is_empty,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_iva_is_empty.

    CONSTANTS:
      BEGIN OF gc_erro_po_values_is_empty,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_po_values_is_empty.

    CONSTANTS:
      BEGIN OF gc_erro_conditions_not_found,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_conditions_not_found.

    CONSTANTS:
      BEGIN OF gc_erro_parameters_not_found,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_parameters_not_found.

    CONSTANTS:
      BEGIN OF gc_erro_methods_not_found,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_methods_not_found.

    CONSTANTS:
      BEGIN OF gc_erro_condition_not_found,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_erro_condition_not_found.

    CONSTANTS:
      BEGIN OF gc_err_condition_map_not_found,
        msgid TYPE symsgid VALUE 'ZLPP_CALC',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_err_condition_map_not_found.




    METHODS constructor
      IMPORTING
        !is_textid   LIKE if_t100_message=>t100key OPTIONAL
        !iv_msgv1    TYPE msgv1 OPTIONAL
        !iv_msgv2    TYPE msgv2 OPTIONAL
        !iv_msgv3    TYPE msgv3 OPTIONAL
        !iv_msgv4    TYPE msgv4 OPTIONAL
        !it_bapiret2 TYPE bapiret2_tab OPTIONAL.

    METHODS get_bapireturn_tab
      RETURNING
        VALUE(rt_bapiret_tab) TYPE bapiret2_tab.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: gv_msgv1 TYPE msgv1,
          gv_msgv2 TYPE msgv2,
          gv_msgv3 TYPE msgv3,
          gv_msgv4 TYPE msgv4.

    DATA: gt_bapiret2_tab TYPE bapiret2_tab .

ENDCLASS.



CLASS zcxmm_lpp_calc IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).

    me->gv_msgv1        = iv_msgv1.
    me->gv_msgv2        = iv_msgv2.
    me->gv_msgv3        = iv_msgv3.
    me->gv_msgv4        = iv_msgv4.
    me->gt_bapiret2_tab = it_bapiret2.

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
    <fs_s_bapiret>-message_v1 = gv_msgv1.
    <fs_s_bapiret>-message_v2 = gv_msgv2.
    <fs_s_bapiret>-message_v3 = gv_msgv3.
    <fs_s_bapiret>-message_v4 = gv_msgv4.

    LOOP AT gt_bapiret2_tab ASSIGNING FIELD-SYMBOL(<fs_s_bapiret2_tab>).
      APPEND INITIAL LINE TO rt_bapiret_tab ASSIGNING <fs_s_bapiret>.

      <fs_s_bapiret> = CORRESPONDING #( <fs_s_bapiret2_tab> ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
