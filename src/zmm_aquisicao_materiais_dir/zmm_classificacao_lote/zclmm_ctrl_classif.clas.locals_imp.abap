CLASS lcl_valida DEFINITION.
  PUBLIC SECTION.

    METHODS recebimento IMPORTING iv_pedido        TYPE ebeln
                                  iv_item          TYPE ebelp
                        RETURNING VALUE(rv_return) TYPE xfeld.

ENDCLASS.

CLASS lcl_valida IMPLEMENTATION.

  METHOD recebimento.
    SELECT COUNT( * )
      FROM i_purordschedulelinebasic
      UP TO 1 ROWS
      WHERE purchaseorder        EQ @iv_pedido
        AND purchaseorderitem    EQ @iv_item
        AND roughgoodsreceiptqty GT 0. "#EC CI_SEL_NESTED
    IF sy-subrc EQ 0.
      rv_return = abap_true.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_classif DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validaclassif FOR VALIDATE ON SAVE
      IMPORTING keys FOR classif~validaclassif.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR classif RESULT result.

ENDCLASS.

CLASS lcl_classif IMPLEMENTATION.

  METHOD validaclassif.
    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY classif
      FIELDS ( perccorretagem )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_classif)
      FAILED DATA(ls_erros).

    LOOP AT lt_classif ASSIGNING FIELD-SYMBOL(<fs_classif>).
      IF <fs_classif>-perccorretagem GT 100.
        APPEND VALUE #( %tky = <fs_classif>-%tky ) TO failed-classif.

        APPEND VALUE #( %tky        = <fs_classif>-%tky
*                        %state_area = 'PERCENTUAL_CORRETAGEM'
                        %msg        = new_message( id       = 'ZMM_CLASSIF_LOTE'
                                                   number   = '001'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-perccorretagem = if_abap_behv=>mk-on ) TO reported-classif.
      ENDIF.

      IF <fs_classif>-precounitembarcador LT 0.
        APPEND VALUE #( %tky = <fs_classif>-%tky ) TO failed-classif.

        APPEND VALUE #( %tky        = <fs_classif>-%tky
*                        %state_area = 'PRECO_UNIT_EMBARCADOR'
                        %msg        = new_message( id       = 'ZMM_CLASSIF_LOTE'
                                                   number   = '005'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-precounitembarcador = if_abap_behv=>mk-on ) TO reported-classif.
      ENDIF.

      data(lv_tem_recebimento) = NEW lcl_valida( )->recebimento( iv_pedido = <fs_classif>-pedido
                                                                 iv_item   = <fs_classif>-itempedido ).
      if lv_tem_recebimento is not initial.
        APPEND VALUE #( %tky = <fs_classif>-%tky ) TO failed-classif.

        APPEND VALUE #( %tky        = <fs_classif>-%tky
*                        %state_area = 'RECEBIMENTO'
                        %msg        = new_message( id       = 'ZMM_CLASSIF_LOTE'
                                                   number   = '006'
                                                   severity = if_abap_behv_message=>severity-error
                                                   ) ) TO reported-classif.
      endif.


    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY classif
      FIELDS ( deletioncode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_classif)
      FAILED DATA(ls_erros).

    result = VALUE #( FOR ls_classif IN lt_classif
             LET lv_tem_recebimento = NEW lcl_valida( )->recebimento( iv_pedido = ls_classif-pedido
                                                                      iv_item   = ls_classif-itempedido )
*             lv_fill = ls_classif
             IN
             ( %key                          = ls_classif-%key
               %features-%update             = COND #( WHEN ls_classif-deletioncode IS INITIAL
                                                        AND lv_tem_recebimento      IS INITIAL
*                                                        and lv_fill                 is initial
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled   )
              ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lcl_caract DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validacaract FOR VALIDATE ON SAVE
      IMPORTING keys FOR caract~validacaract.

    METHODS setclassif FOR DETERMINE ON SAVE
      IMPORTING keys FOR caract~setclassif.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR caract RESULT result.
    METHODS categ_doc FOR DETERMINE ON SAVE
      IMPORTING keys FOR caract~categ_doc.


ENDCLASS.

CLASS lcl_caract IMPLEMENTATION.

  METHOD validacaract.

    DATA: lv_percent(5) TYPE p DECIMALS 2,
          lv_percent_c  TYPE char6.

    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY classif
      FIELDS ( deletioncode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_classif).
    SORT lt_classif BY pedido itempedido.

    READ TABLE lt_classif ASSIGNING FIELD-SYMBOL(<fs_classif>) INDEX 1.
    IF <fs_classif> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY caract
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_caract)
      FAILED DATA(ls_erros).

    LOOP AT lt_caract ASSIGNING FIELD-SYMBOL(<fs_caract>).
      IF <fs_classif>-deletioncode IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_caract>-%tky ) TO failed-caract.

        APPEND VALUE #( %tky        = <fs_caract>-%tky
                        %state_area = 'ELIMINADO'
                        %msg        = new_message( id       = 'ZMM_CLASSIF_LOTE'
                                                   number   = '004'
                                                   severity = if_abap_behv_message=>severity-error
                                                   v1       = <fs_classif>-itempedido )
                        %element-pedido     = if_abap_behv=>mk-on
                        %element-itempedido = if_abap_behv=>mk-on ) TO reported-caract.
        RETURN.
      ENDIF.



      IF <fs_caract>-peneira19   GT 100
      OR <fs_caract>-peneira18   GT 100
      OR <fs_caract>-peneira17   GT 100
      OR <fs_caract>-peneira16   GT 100
      OR <fs_caract>-peneira15   GT 100
      OR <fs_caract>-peneira14   GT 100
      OR <fs_caract>-peneira13   GT 100
      OR <fs_caract>-peneira12   GT 100
      OR <fs_caract>-peneira11   GT 100
      OR <fs_caract>-peneira10   GT 100
      OR <fs_caract>-mk10        GT 100
      OR <fs_caract>-fundo       GT 100
      OR <fs_caract>-catacao     GT 100
      OR <fs_caract>-umidade     GT 100
      OR <fs_caract>-impureza    GT 100
      OR <fs_caract>-verde       GT 100
      OR <fs_caract>-pretoardido GT 100
      OR <fs_caract>-brocado     GT 100
      OR <fs_caract>-densidade   GT 100.

        APPEND VALUE #( %tky = <fs_caract>-%tky ) TO failed-caract.

        APPEND VALUE #( %tky        = <fs_caract>-%tky
                        %state_area = 'PERCENTUAL'
                        %msg        = new_message( id       = 'ZMM_CLASSIF_LOTE'
                                                   number   = '002'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-peneira19   = COND #( WHEN <fs_caract>-peneira19   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira18   = COND #( WHEN <fs_caract>-peneira18   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira17   = COND #( WHEN <fs_caract>-peneira17   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira16   = COND #( WHEN <fs_caract>-peneira16   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira15   = COND #( WHEN <fs_caract>-peneira15   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira14   = COND #( WHEN <fs_caract>-peneira14   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira13   = COND #( WHEN <fs_caract>-peneira13   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira12   = COND #( WHEN <fs_caract>-peneira12   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira11   = COND #( WHEN <fs_caract>-peneira11   GT 100 THEN if_abap_behv=>mk-on )
                        %element-peneira10   = COND #( WHEN <fs_caract>-peneira10   GT 100 THEN if_abap_behv=>mk-on )
                        %element-mk10        = COND #( WHEN <fs_caract>-mk10        GT 100 THEN if_abap_behv=>mk-on )
                        %element-fundo       = COND #( WHEN <fs_caract>-fundo       GT 100 THEN if_abap_behv=>mk-on )
                        %element-catacao     = COND #( WHEN <fs_caract>-catacao     GT 100 THEN if_abap_behv=>mk-on )
                        %element-umidade     = COND #( WHEN <fs_caract>-umidade     GT 100 THEN if_abap_behv=>mk-on )
                        %element-impureza    = COND #( WHEN <fs_caract>-impureza    GT 100 THEN if_abap_behv=>mk-on )
                        %element-verde       = COND #( WHEN <fs_caract>-verde       GT 100 THEN if_abap_behv=>mk-on )
                        %element-pretoardido = COND #( WHEN <fs_caract>-pretoardido GT 100 THEN if_abap_behv=>mk-on )
                        %element-brocado     = COND #( WHEN <fs_caract>-brocado     GT 100 THEN if_abap_behv=>mk-on )
                        %element-densidade   = COND #( WHEN <fs_caract>-densidade   GT 100 THEN if_abap_behv=>mk-on )
        ) TO reported-caract.

        CONTINUE.
      ENDIF.

      CLEAR lv_percent.
      lv_percent =  <fs_caract>-peneira19 +
                    <fs_caract>-peneira18 +
                    <fs_caract>-peneira17 +
                    <fs_caract>-peneira16 +
                    <fs_caract>-peneira15 +
                    <fs_caract>-peneira14 +
                    <fs_caract>-peneira13 +
                    <fs_caract>-peneira12 +
                    <fs_caract>-peneira11 +
                    <fs_caract>-peneira10 +
                    <fs_caract>-mk10 +
                    <fs_caract>-fundo +
                    <fs_caract>-catacao +
                    <fs_caract>-umidade +
                    <fs_caract>-impureza +
                    <fs_caract>-verde +
                    <fs_caract>-pretoardido +
                    <fs_caract>-brocado +
                    <fs_caract>-densidade.

      IF lv_percent NE 100.
        WRITE lv_percent TO lv_percent_c.
        APPEND VALUE #( %tky = <fs_caract>-%tky ) TO failed-caract.

        APPEND VALUE #( %tky        = <fs_caract>-%tky
                        %state_area = 'TOTAL_PERCENTUAL'
                        %msg        = new_message( id       = 'ZMM_CLASSIF_LOTE'
                                                   number   = '003'
                                                   v1       = lv_percent_c
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-peneira19 = if_abap_behv=>mk-on
                        %element-peneira18 = if_abap_behv=>mk-on
                        %element-peneira17 = if_abap_behv=>mk-on
                        %element-peneira16 = if_abap_behv=>mk-on
                        %element-peneira15 = if_abap_behv=>mk-on
                        %element-peneira14 = if_abap_behv=>mk-on
                        %element-peneira13 = if_abap_behv=>mk-on
                        %element-peneira12 = if_abap_behv=>mk-on
                        %element-peneira11 = if_abap_behv=>mk-on
                        %element-peneira10 = if_abap_behv=>mk-on
                        %element-mk10 = if_abap_behv=>mk-on
                        %element-fundo = if_abap_behv=>mk-on
                        %element-catacao = if_abap_behv=>mk-on
                        %element-umidade = if_abap_behv=>mk-on
                        %element-impureza = if_abap_behv=>mk-on
                        %element-verde = if_abap_behv=>mk-on
                        %element-pretoardido = if_abap_behv=>mk-on
                        %element-brocado = if_abap_behv=>mk-on
                        %element-densidade = if_abap_behv=>mk-on ) TO reported-caract.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY classif
      FIELDS ( deletioncode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_classif)
      FAILED DATA(ls_erros).

    READ TABLE lt_classif INTO DATA(ls_classif) INDEX 1.

    result = VALUE #( FOR ls_keys IN keys
             LET lv_tem_recebimento = NEW lcl_valida( )->recebimento( iv_pedido  = ls_keys-pedido
                                                                      iv_item    = ls_keys-itempedido )

             IN
             ( %key                          = ls_keys-%key
               %features-%update             = COND #( WHEN ls_classif-deletioncode IS INITIAL
                                                        AND lv_tem_recebimento      IS INITIAL
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled   )
               %features-%delete             = COND #( WHEN ls_classif-deletioncode IS INITIAL
                                                        AND lv_tem_recebimento      IS INITIAL
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled   )
              ) ).


  ENDMETHOD.

  METHOD setclassif.
    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY classif
      FIELDS ( pedido itempedido dataclassif statusclassific )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_classif).

    READ TABLE lt_classif ASSIGNING FIELD-SYMBOL(<fs_classif>) INDEX 1.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT ebeln,
           ebelp,
           data_classif,
           status_classific
       FROM ztmm_control_cla
       INTO TABLE @DATA(lt_control_cla)
       WHERE ebeln = @<fs_classif>-pedido.
    SORT lt_control_cla BY ebeln ebelp.


    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY caract
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_caract).

    IF lt_caract IS NOT INITIAL.
      IF <fs_classif>-dataclassif IS INITIAL.
        <fs_classif>-dataclassif = sy-datum.
      ENDIF.
    ELSE.
      CLEAR <fs_classif>-dataclassif.
    ENDIF.

    SELECT ebeln,
           ebelp,
           charg
      FROM ztmm_valor_carac
      INTO TABLE @DATA(lt_valor_carac)
      WHERE ebeln = @<fs_classif>-pedido.

    SORT lt_valor_carac BY ebeln ebelp charg.

    LOOP AT lt_caract ASSIGNING FIELD-SYMBOL(<fs_caract>).
      READ TABLE lt_valor_carac TRANSPORTING NO FIELDS
        WITH KEY ebeln = <fs_caract>-pedido
                 ebelp = <fs_caract>-itempedido
                 charg = <fs_caract>-lote BINARY SEARCH.
      CHECK sy-subrc NE 0.

      INSERT VALUE #( ebeln = <fs_caract>-pedido
                      ebelp = <fs_caract>-itempedido
                      charg = <fs_caract>-lote ) INTO lt_valor_carac INDEX sy-tabix.
    ENDLOOP.
    IF sy-subrc NE 0.
      FREE lt_valor_carac.
    ENDIF.

    IF lines( lt_control_cla ) EQ lines( lt_valor_carac ).
      <fs_classif>-statusclassific = 'S'.
    ELSE.
      <fs_classif>-statusclassific = 'N'.
    ENDIF.

    UPDATE ztmm_control_cla SET status_classific = <fs_classif>-statusclassific
      WHERE ebeln = <fs_classif>-pedido.

    MODIFY ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY classif
      UPDATE FIELDS ( dataclassif statusclassific )
      WITH VALUE #( FOR ls_classif IN lt_classif (
        %key            = ls_classif-%key
        dataclassif     = ls_classif-dataclassif
        statusclassific = ls_classif-statusclassific ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.


  METHOD categ_doc.

    READ ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY caract
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_caract).

    MODIFY ENTITIES OF zi_mm_ctrl_classif IN LOCAL MODE
      ENTITY caract
        UPDATE FIELDS ( cagetoriadocumento )
        WITH VALUE #( FOR ls_caract IN lt_caract (
                        %key               = ls_caract-%key
                        cagetoriadocumento = 'F' ) )
      REPORTED DATA(lt_reported).

  ENDMETHOD.




ENDCLASS.
