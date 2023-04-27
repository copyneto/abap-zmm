CLASS lhc__ordem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTMM_ROMANEIO_IN'.

    METHODS validanfpedido FOR VALIDATE ON SAVE
      IMPORTING keys FOR _ordem~validanfpedido.

    METHODS determinarnrdescarga FOR DETERMINE ON SAVE
      IMPORTING keys FOR _ordem~determinarnrdescarga.

    METHODS buscaproximoid
      RETURNING
        VALUE(rv_number) TYPE ebeln.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR _ordem~authoritycreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _ordem RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _ordem RESULT result.

ENDCLASS.

CLASS lhc__ordem IMPLEMENTATION.

  METHOD validanfpedido.
    DATA: lv_nfok           TYPE flag,
          lv_ref_number_imp TYPE xblnr1,
          lv_nf_number9     TYPE j_1bnfdoc-nfenum.

    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
      ENTITY _ordem
      FIELDS ( pedido notafiscal )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_ordem)
      FAILED DATA(ls_erros).

    IF lt_ordem IS NOT INITIAL.
      SELECT ebeln,
             xblnr
         FROM zi_mm_ord_desca_conf_pedido
         FOR ALL ENTRIES IN @lt_ordem
         WHERE ebeln = @lt_ordem-pedido
         INTO TABLE @DATA(lt_nfpedido).
      IF sy-subrc = 0.
        SORT lt_nfpedido BY ebeln.
      ENDIF.
    ENDIF.

    LOOP AT lt_ordem ASSIGNING FIELD-SYMBOL(<fs_ordem>).
      CLEAR: lv_nfok.
      READ TABLE lt_nfpedido
        WITH KEY ebeln = <fs_ordem>-pedido
        TRANSPORTING NO FIELDS
        BINARY SEARCH.
      IF sy-subrc = 0.
        DATA(lv_tabix) = sy-tabix.
        LOOP AT lt_nfpedido ASSIGNING FIELD-SYMBOL(<fs_nfpedido>).

          DATA(lv_ref_number_exp) = CONV xblnr1( <fs_nfpedido>-xblnr ).

          CLEAR: lv_ref_number_imp.

          CALL FUNCTION 'J_1B_NF_NUMBER_SEPARATE'
            EXPORTING
              ref_number         = lv_ref_number_exp
              i_nfeflag          = abap_true
            IMPORTING
              ref_number         = lv_ref_number_imp
              nf_number9         = lv_nf_number9
            EXCEPTIONS
              number_error       = 1
              too_many_dashes    = 2
              docnum_too_long    = 3
              docnum_not_numeric = 4
              series_not_numeric = 5
              OTHERS             = 6.
          SHIFT lv_nf_number9 LEFT DELETING LEADING '0'.
          CONDENSE lv_nf_number9 NO-GAPS.
          IF <fs_ordem>-notafiscal = lv_nf_number9.
            lv_nfok = abap_true.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF lv_nfok IS INITIAL.
        APPEND VALUE #( %tky = <fs_ordem>-%tky ) TO failed-_ordem.

        APPEND VALUE #( %tky        = <fs_ordem>-%tky
                        %state_area = 'NOTAFISCAL'
                        %msg        = new_message( id       = 'ZMM_ROMANEIO'
                                                   number   = '006'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-notafiscal = if_abap_behv=>mk-on ) TO reported-_ordem.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD determinarnrdescarga.
    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
    ENTITY _ordem
    FIELDS ( romaneio )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_ordem).

    DATA: lt_dados TYPE STANDARD TABLE OF ty_adm_ordem_descarga.

    IF NOT line_exists( lt_ordem[ romaneio  = '' ] ).    "#EC CI_STDSEQ
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING lt_ordem TO lt_dados.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_item>).
        <fs_item>-xblnr = CONV xblnr_long( <fs_item>-notafiscal ).
    ENDLOOP.

    IF lt_dados IS NOT INITIAL.

      SELECT ebeln,
             ebelp,
             etens,
             vbeln,
             vbelp,
             menge,
             xblnr,
             matnr,
             maktx,
             charg,
             meins,
             ormng,
             meins_out
        FROM zi_mm_ord_desca_conf_pedido
        FOR ALL ENTRIES IN @lt_dados
        WHERE ebeln = @lt_dados-pedido
          AND ebelp = @lt_dados-itempedido
          AND xblnr_format = @lt_dados-xblnr
        INTO TABLE @DATA(lt_conf_pedido).

    ENDIF.

*    IF lt_ordem IS NOT INITIAL.
*
*      SELECT ebeln,
*             ebelp,
*             etens,
*             vbeln,
*             vbelp,
*             menge,
*             xblnr,
*             matnr,
*             maktx,
*             charg,
*             meins,
*             ormng,
*             meins_out
*        FROM zi_mm_ord_desca_conf_pedido
*        FOR ALL ENTRIES IN @lt_ordem
*        WHERE ebeln = @lt_ordem-pedido
*          AND ebelp = @lt_ordem-itempedido
*          AND xblnr = @lt_ordem-NotaFiscal
*        INTO TABLE @DATA(lt_conf_pedido).
*
*    ENDIF.

    IF sy-subrc IS INITIAL.
      DATA(ls_conf_pedido) = VALUE #( lt_conf_pedido[ 1 ] OPTIONAL ).
    ENDIF.

    MODIFY ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
    ENTITY _ordem
    UPDATE FIELDS ( romaneio statusordem statusarmazenado statuscompensado recebimento dtentrada )
    WITH VALUE #( FOR ls_ordem IN lt_ordem WHERE ( romaneio IS INITIAL ) ( "#EC CI_STDSEQ
                       %key              =  ls_ordem-%key
                        romaneio         = buscaproximoid( )
                        statusordem      = '1'
                        statusarmazenado = 'N'
                        statuscompensado = 'N'
                        recebimento = ls_conf_pedido-vbeln
                        dtentrada = sy-datum
                       ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD buscaproximoid.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZMMROMANEI'
      IMPORTING
        number                  = rv_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD authoritycreate.
    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
        ENTITY _ordem
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) = abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-_ordem.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_ordem.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-docuuidh = if_abap_behv=>mk-on )
          TO reported-_ordem.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.
    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
        ENTITY _ordem
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>update( gc_table ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>delete( gc_table ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky          = <fs_data>-%tky
                      %update       = lv_update
                      %delete       = lv_delete )
             TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_features.


    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
    ENTITY _ordem
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_ordem)
    FAILED failed.

    LOOP AT lt_ordem ASSIGNING FIELD-SYMBOL(<fs_ordem>).
      result = VALUE #( BASE result (
        %tky    = <fs_ordem>-%tky
        %update = COND #(
          WHEN <fs_ordem>-statusordem = 'Finalizado'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled
        )
        %delete = COND #(
          WHEN <fs_ordem>-statusordem = 'Finalizado'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled
        )
        %assoc-_OrdemItem = COND #(
          WHEN <fs_ordem>-statusordem = 'Finalizado'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled
        )
      ) ).
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lhc__ordemitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _ordemitem RESULT result.

    METHODS determinarinforecebimento FOR DETERMINE ON SAVE
      IMPORTING keys FOR _ordemitem~determinarinforecebimento.
    METHODS checkdeposito FOR VALIDATE ON SAVE
      IMPORTING keys FOR _ordemitem~checkdeposito.

ENDCLASS.

CLASS lhc__ordemitem IMPLEMENTATION.

  METHOD determinarinforecebimento.
    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
    ENTITY _ordemitem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_ordemitem).

    CHECK lt_ordemitem[] IS NOT INITIAL.


    SELECT docuuidh, recebimento, itempedido
      FROM   zi_mm_adm_ordem_descarga
        FOR ALL ENTRIES IN  @lt_ordemitem
        WHERE docuuidh = @lt_ordemitem-docuuidh
        INTO TABLE @DATA(lt_header).

    IF sy-subrc IS INITIAL.
      SELECT  ebeln,
             ebelp,
             etens,
             vbeln,
             vbelp,
             menge,
             xblnr,
             matnr,
             maktx,
             charg,
             meins,
             ormng,
             meins_out
        FROM zi_mm_ord_desca_conf_pedido
        FOR ALL ENTRIES IN @lt_header
        WHERE vbeln = @lt_header-recebimento
          AND ebelp = @lt_header-itempedido
        INTO TABLE @DATA(lt_conf_pedido).
      IF sy-subrc = 0.
        SORT lt_conf_pedido BY vbeln ebelp.
        LOOP AT lt_ordemitem ASSIGNING FIELD-SYMBOL(<fs_ordemitem>).

          READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<fs_header>) WITH KEY docuuidh = <fs_ordemitem>-docuuidh.
          IF <fs_header> IS ASSIGNED.
            READ TABLE lt_conf_pedido
                INTO DATA(ls_conf_pedido)
              WITH KEY vbeln = <fs_header>-recebimento
                       ebelp = <fs_header>-itempedido
              BINARY SEARCH.
            IF sy-subrc = 0.
              <fs_ordemitem>-recebimento = <fs_header>-recebimento.
              <fs_ordemitem>-itempedido = <fs_header>-itempedido.
              <fs_ordemitem>-itemrecebimento = ls_conf_pedido-vbelp.
              <fs_ordemitem>-notafiscalped   = ls_conf_pedido-xblnr.
              <fs_ordemitem>-material = ls_conf_pedido-matnr.
              <fs_ordemitem>-descmaterial = ls_conf_pedido-maktx.
              <fs_ordemitem>-lote = ls_conf_pedido-charg.
              <fs_ordemitem>-unidade = ls_conf_pedido-meins.
              <fs_ordemitem>-quantidade = ls_conf_pedido-ormng.

              CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
                EXPORTING
                  i_matnr              = ls_conf_pedido-matnr
                  i_in_me              = ls_conf_pedido-meins
                  i_out_me             = ls_conf_pedido-meins_out
                  i_menge              = ls_conf_pedido-menge
                IMPORTING
                  e_menge              = <fs_ordemitem>-qtdekgorig
                EXCEPTIONS
                  error_in_application = 1
                  error                = 2
                  OTHERS               = 3.
              IF sy-subrc <> 0.
                DATA(lv_erro) = abap_true.
              ENDIF.

              MODIFY ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
              ENTITY _ordemitem
              UPDATE FIELDS ( recebimento
                              itempedido
                              itemrecebimento
                              notafiscalped
                              material
                              descmaterial
                              lote
                              unidade
                              quantidade
                              qtdekgorig )
              WITH VALUE #( ( %key-docuuidh    = <fs_ordemitem>-docuuidh
                              recebimento = <fs_ordemitem>-recebimento
                              itempedido  = <fs_ordemitem>-itempedido
                              itemrecebimento  = <fs_ordemitem>-itemrecebimento
                              notafiscalped    = <fs_ordemitem>-notafiscalped
                              material         = <fs_ordemitem>-material
                              descmaterial     = <fs_ordemitem>-descmaterial
                              lote             = <fs_ordemitem>-lote
                              unidade          = <fs_ordemitem>-unidade
                              quantidade       = <fs_ordemitem>-quantidade
                              qtdekgorig       = <fs_ordemitem>-qtdekgorig ) )
              FAILED DATA(lt_failed)
              REPORTED DATA(lt_reported).

              reported = CORRESPONDING #( DEEP lt_reported ).
            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_mm_adm_ordem_descarga IN LOCAL MODE
    ENTITY _ordemitem BY \_Ordem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_ordem).

    LOOP AT lt_ordem ASSIGNING FIELD-SYMBOL(<fs_ordem>).
      result = VALUE #( BASE result (
        %tky    = <fs_ordem>-%tky
        %update = COND #(
          WHEN <fs_ordem>-statusordem = 'Finalizado'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled
        )
        %delete = COND #(
          WHEN <fs_ordem>-statusordem = 'Finalizado'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled
        )
      ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD checkdeposito.


  ENDMETHOD.

ENDCLASS.
