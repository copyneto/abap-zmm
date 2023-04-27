CLASS zclmm_adret_arm_graoverde DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_mm_ret_arm_graoverde RESULT result.

    METHODS atribuirmaterial FOR MODIFY
      IMPORTING keys FOR ACTION zi_mm_ret_arm_graoverde~atribuirmaterial.

    METHODS concluirem FOR MODIFY
      IMPORTING keys FOR ACTION zi_mm_ret_arm_graoverde~concluirem.

    METHODS limpar FOR MODIFY
      IMPORTING keys FOR ACTION zi_mm_ret_arm_graoverde~limpar.

ENDCLASS.

CLASS zclmm_adret_arm_graoverde IMPLEMENTATION.

  METHOD read.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD atribuirmaterial.

    DATA: ls_atribuir TYPE ztmm_ret_arm_gv.

    DATA(lo_object) = NEW zclmm_ret_arm_gv( ).

    CONSTANTS lc_id(20) TYPE c VALUE 'ZMM_GRAO_VERDE'.
    CONSTANTS lc_e      TYPE c VALUE 'E'.


    "Verifica se apenas uma linha selecionada
    IF lines( keys ) NE 1.

      APPEND VALUE #( %msg  = new_message( id       = lc_id
                                           number   = '000'
                                           severity =  CONV #( lc_e ) ) ) TO reported-zi_mm_ret_arm_graoverde.
      RETURN.
    ENDIF.

    DATA(ls_key) = keys[ 1 ].

    IF ls_key-%param-materialatribuido IS INITIAL.
      APPEND VALUE #( %msg  = new_message( id       = lc_id
                                           number   = '003'
                                           severity =  CONV #( lc_e ) ) ) TO reported-zi_mm_ret_arm_graoverde.
      RETURN.
    ENDIF.

    "Verifica se já tem GUID e Valida o XML
    DATA(lv_xml) = ls_key-xml.

    lo_object->valida_guid( EXPORTING iv_xml    = lv_xml
                            IMPORTING et_return = DATA(lt_return)
                                      ev_guid   = DATA(lv_guid) ).

    IF line_exists( lt_return[ type = lc_e ] ).
      APPEND VALUE #(  %tky = ls_key-%tky ) TO failed-zi_mm_ret_arm_graoverde.
    ENDIF.

    LOOP AT lt_return INTO DATA(ls_message).

      APPEND VALUE #( %tky        = ls_key-%tky
                      %msg        = new_message( id       = ls_message-id
                                                 number   = ls_message-number
                                                 v1       = ls_message-message_v1
                                                 v2       = ls_message-message_v2
                                                 v3       = ls_message-message_v3
                                                 v4       = ls_message-message_v4
                                                 severity = CONV #( ls_message-type ) )
                       )
        TO reported-zi_mm_ret_arm_graoverde.
      RETURN.
    ENDLOOP.

    IF  lv_guid IS INITIAL.
      lv_guid = lo_object->calcula_guid( ).
    ENDIF.

    ls_atribuir = VALUE #(  doc_uuid_h        = lv_guid
                            lifnr             = ls_key-lifnrcode
                            werks             = ls_key-werkscode
                            cfop              = ls_key-cfop
                            nnf               = ls_key-nnf
                            nfeid             = ls_key-xml
                            demi              = ls_key-dataemissao
                            nitem             = ls_key-nitem
                            usuario           = sy-uname
                            data              = sy-datum
                            materialatribuido = ls_key-%param-materialatribuido  ) .


    lo_object->busca_dados( EXPORTING iv_xml      = lv_xml
                                      iv_atribuir = abap_true
                                      iv_concluir = abap_false
                            IMPORTING et_return   = lt_return
                            CHANGING  cs_atribuir = ls_atribuir ).

    IF line_exists( lt_return[ type = lc_e ] ).
      APPEND VALUE #(  %tky = ls_key-%tky ) TO failed-zi_mm_ret_arm_graoverde.
    ENDIF.

    LOOP AT lt_return INTO DATA(ls_message2).

      APPEND VALUE #( %tky        = ls_key-%tky
                      %msg        = new_message( id       = ls_message2-id
                                                 number   = ls_message2-number
                                                 v1       = ls_message2-message_v1
                                                 v2       = ls_message2-message_v2
                                                 v3       = ls_message2-message_v3
                                                 v4       = ls_message2-message_v4
                                                 severity = CONV #( ls_message2-type ) )
                       )
        TO reported-zi_mm_ret_arm_graoverde.
      RETURN.

    ENDLOOP.
  ENDMETHOD.

  METHOD concluirem.

    DATA: ls_concluir TYPE zsmm_keys_ret.
    DATA: lt_concluir TYPE TABLE OF zsmm_keys_ret.
    CONSTANTS lc_id(20) TYPE c VALUE 'ZMM_GRAO_VERDE'.
    CONSTANTS lc_e      TYPE c VALUE 'E'.

    DATA(lo_object) = NEW zclmm_ret_arm_gv( ).

    DATA(ls_key) = keys[ 1 ].
    DATA(lv_xml) = ls_key-xml.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      APPEND VALUE #(         lifnr             = <fs_keys>-lifnrcode
                              werks             = <fs_keys>-werkscode
                              cfop              = <fs_keys>-cfop
                              nnf               = <fs_keys>-nnf
                              nfeid             = <fs_keys>-xml
                              demi              = <fs_keys>-dataemissao
                              nitem             = <fs_keys>-nitem
                           ) TO lt_concluir.


    ENDLOOP.

    lo_object->valida_tabela( EXPORTING it_concluir   = lt_concluir
                               IMPORTING et_return = DATA(lt_return) ).

    IF line_exists( lt_return[ type = lc_e ] ).
      APPEND VALUE #(  %tky = ls_key-%tky ) TO failed-zi_mm_ret_arm_graoverde.
    ENDIF.

    LOOP AT lt_return INTO DATA(ls_message).

      APPEND VALUE #( %tky        = ls_key-%tky
                      %msg        = new_message( id       = ls_message-id
                                                 number   = ls_message-number
                                                 v1       = ls_message-message_v1
                                                 v2       = ls_message-message_v2
                                                 v3       = ls_message-message_v3
                                                 v4       = ls_message-message_v4
                                                 severity = CONV #( ls_message-type ) )
                       )
        TO reported-zi_mm_ret_arm_graoverde.
      RETURN.
    ENDLOOP.

    lo_object->busca_dados( EXPORTING iv_xml      = lv_xml
                                      it_concluir = lt_concluir
                                      iv_atribuir = abap_false
                                      iv_concluir = abap_true
                            IMPORTING et_return   = lt_return
                            ).


    IF line_exists( lt_return[ type = lc_e ] ).
      APPEND VALUE #(  %tky = ls_key-%tky ) TO failed-zi_mm_ret_arm_graoverde.
    ENDIF.

    LOOP AT lt_return INTO DATA(ls_message2).

      APPEND VALUE #( %tky        = ls_key-%tky
                      %msg        = new_message( id       = ls_message2-id
                                                 number   = ls_message2-number
                                                 v1       = ls_message2-message_v1
                                                 v2       = ls_message2-message_v2
                                                 v3       = ls_message2-message_v3
                                                 v4       = ls_message2-message_v4
                                                 severity = CONV #( ls_message2-type ) )
                       )
        TO reported-zi_mm_ret_arm_graoverde.
      RETURN.

    ENDLOOP.

  ENDMETHOD.

  METHOD limpar.

    SELECT *
      FROM ztmm_ret_arm_gv
      INTO TABLE @DATA(lt_keys).
*      WHERE usuario = @sy-uname.
    IF sy-subrc IS INITIAL.
      DELETE ztmm_ret_arm_gv FROM TABLE lt_keys.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_mm_ret_arm_graoverde DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_zi_mm_ret_arm_graoverde IMPLEMENTATION.

  METHOD check_before_save.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD finalize.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
