CLASS lcl_movcntrl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

    CLASS-METHODS setup_messages
      IMPORTING p_task TYPE clike.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_business,
             werks      TYPE t001k-bwkey,
             bukrs      TYPE t001k-bukrs,
             j_1bbranch TYPE t001w-j_1bbranch,
           END OF ty_business.

    TYPES: BEGIN OF ty_material,
             matnr TYPE mara-matnr,
             bismt TYPE mara-bismt,
             werks TYPE marc-werks,
             lgort TYPE mard-lgort,
             labst TYPE mard-labst,
           END OF ty_material,

           BEGIN OF ty_helper_type,
             id                 TYPE zi_mm_mov_cntrl-id,
             bukrs              TYPE zi_mm_mov_cntrl-bukrs,
             branch             TYPE zi_mm_mov_cntrl-branch,
             mblnrsai           TYPE zi_mm_mov_cntrl-mblnrsai,
             mjahr              TYPE zi_mm_mov_cntrl-mjahr,
             mblpo              TYPE zi_mm_mov_cntrl-mblpo,
             statusgeral        TYPE zi_mm_mov_cntrl-statusgeral,
             statusgeralcrit    TYPE zi_mm_mov_cntrl-statusgeralcrit,
             status1            TYPE zi_mm_mov_cntrl-status1,
             status1crit        TYPE zi_mm_mov_cntrl-status1crit,
             mblnrest           TYPE zi_mm_mov_cntrl-mblnrest,
             mjahrest           TYPE zi_mm_mov_cntrl-mjahrest,
             docnums            TYPE zi_mm_mov_cntrl-docnums,
             status2            TYPE zi_mm_mov_cntrl-status2,
             status2crit        TYPE zi_mm_mov_cntrl-status2crit,
             belnr              TYPE zi_mm_mov_cntrl-belnr,
             bukrsdc            TYPE zi_mm_mov_cntrl-bukrsdc,
             gjahrdc            TYPE zi_mm_mov_cntrl-gjahrdc,
             status3            TYPE zi_mm_mov_cntrl-status3,
             status3crit        TYPE zi_mm_mov_cntrl-status3crit,
             mblnrent           TYPE zi_mm_mov_cntrl-mblnrent,
             mjahrent           TYPE zi_mm_mov_cntrl-mjahrent,
             mblpoent           TYPE zi_mm_mov_cntrl-mblpoent,
             status4            TYPE zi_mm_mov_cntrl-status4,
             status4crit        TYPE zi_mm_mov_cntrl-status4crit,
             mblnrestent        TYPE zi_mm_mov_cntrl-mblnrestent,
             mjahrestent        TYPE zi_mm_mov_cntrl-mjahrestent,
             bldat              TYPE zi_mm_mov_cntrl-bldat,
             docnument          TYPE zi_mm_mov_cntrl-docnument,
             docdat             TYPE zi_mm_mov_cntrl-docdat,
             status5            TYPE zi_mm_mov_cntrl-status5,
             status5crit        TYPE zi_mm_mov_cntrl-status5crit,
             docnumestent       TYPE zi_mm_mov_cntrl-docnumestent,
             docnumestsai       TYPE zi_mm_mov_cntrl-docnumestsai,
             belnrest           TYPE zi_mm_mov_cntrl-belnrest,
             gjahrest           TYPE zi_mm_mov_cntrl-gjahrest,
             bldatest           TYPE zi_mm_mov_cntrl-bldatest,
             etapa              TYPE zi_mm_mov_cntrl-etapa,
             matnr1             TYPE zi_mm_mov_cntrl-matnr1,
             matnr              TYPE zi_mm_mov_cntrl-matnr,
             menge              TYPE zi_mm_mov_cntrl-menge,
             meins              TYPE zi_mm_mov_cntrl-meins,
             werks              TYPE zi_mm_mov_cntrl-werks,
             lgort              TYPE zi_mm_mov_cntrl-lgort,
             posid              TYPE zi_mm_mov_cntrl-posid,
             anln1              TYPE zi_mm_mov_cntrl-anln1,
             anln2              TYPE zi_mm_mov_cntrl-anln2,
             invnr              TYPE zi_mm_mov_cntrl-invnr,
             partner            TYPE zi_mm_mov_cntrl-partner,
             createdby          TYPE zi_mm_mov_cntrl-createdby,
             createdat          TYPE zi_mm_mov_cntrl-createdat,
             lastchangedby      TYPE zi_mm_mov_cntrl-lastchangedby,
             lastchangedat      TYPE zi_mm_mov_cntrl-lastchangedat,
             locallastchangedat TYPE zi_mm_mov_cntrl-locallastchangedat,
             hiddenentrada      TYPE zi_mm_mov_cntrl-hiddenentrada,
             hiddenpep          TYPE zi_mm_mov_cntrl-hiddenpep,
             hiddengoodssaida   TYPE zi_mm_mov_cntrl-hiddengoodssaida,
             hiddensimulacao    TYPE zi_mm_mov_cntrl-hiddensimulacao,
             hiddenimobilizado  TYPE zi_mm_mov_cntrl-hiddenimobilizado,
             hiddennfsaida      TYPE zi_mm_mov_cntrl-hiddennfsaida,
             hiddenposting      TYPE zi_mm_mov_cntrl-hiddenposting,
             hiddennfentrada    TYPE zi_mm_mov_cntrl-hiddennfentrada,
             hiddengoodsentrada TYPE zi_mm_mov_cntrl-hiddengoodsentrada,
           END OF ty_helper_type.
    METHODS set_doc
      IMPORTING
        is_doc        TYPE ty_helper_type
      RETURNING
        VALUE(rs_doc) TYPE ztmm_mov_cntrl.

    CLASS-DATA:
      gt_msg        TYPE bapiret2_tab,
      gs_doc        TYPE ztmm_mov_cntrl,
      gv_wait_async TYPE abap_bool.

    METHODS fill_business_area FOR DETERMINE ON SAVE
      IMPORTING keys FOR movcntrl~fill_business_area.

    METHODS check_key FOR VALIDATE ON SAVE
      IMPORTING keys FOR movcntrl~check_key.

    METHODS registrar FOR MODIFY
      IMPORTING keys FOR ACTION movcntrl~registrar.

    METHODS simul_imp FOR MODIFY
      IMPORTING keys FOR ACTION movcntrl~simul_imp.

    METHODS nfe_saida FOR MODIFY
      IMPORTING keys FOR ACTION movcntrl~nfe_saida.

    METHODS contab FOR MODIFY
      IMPORTING keys FOR ACTION movcntrl~contab.

    METHODS nfe_ent FOR MODIFY
      IMPORTING keys FOR ACTION movcntrl~nfe_ent.

    METHODS mov_merc_ent FOR MODIFY
      IMPORTING keys FOR ACTION movcntrl~mov_merc_ent.

*    METHODS estorno FOR MODIFY
*      IMPORTING keys FOR ACTION movcntrl~estorno.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR movcntrl RESULT result.
    METHODS valida_mat FOR VALIDATE ON SAVE
      IMPORTING keys FOR movcntrl~valida_mat.


    METHODS set_imobilizado
      CHANGING  cs_doc       TYPE ztmm_mov_cntrl
      RETURNING VALUE(rv_ok) TYPE abap_bool.
    METHODS set_refresh.
    METHODS set_bismt
      IMPORTING
        iv_matnr    TYPE zi_mm_mov_cntrl-matnr
        iv_werks    TYPE zi_mm_mov_cntrl-werks
      CHANGING
        cs_material TYPE ty_material.
    METHODS set_bismt2
      IMPORTING
        iv_matnr    TYPE zi_mm_mov_cntrl-matnr
        iv_werks    TYPE zi_mm_mov_cntrl-werks
      CHANGING
        cs_material TYPE ty_material.
    METHODS check_mat
      IMPORTING
        iv_matnr     TYPE zi_mm_mov_cntrl-matnr
      RETURNING
        VALUE(rv_ok) TYPE abap_bool.
    METHODS check_centro
      IMPORTING
        iv_werks     TYPE zi_mm_mov_cntrl-werks
      RETURNING
        VALUE(rv_ok) TYPE abap_bool.
    METHODS check_dep
      IMPORTING
        iv_dep       TYPE zi_mm_mov_cntrl-lgort
      RETURNING
        VALUE(rv_ok) TYPE abap_bool.
    METHODS check_pep
      IMPORTING
        iv_pep       TYPE zi_mm_mov_cntrl-posid
      RETURNING
        VALUE(rv_ok) TYPE abap_bool.

ENDCLASS.

CLASS lcl_movcntrl IMPLEMENTATION.

  METHOD fill_business_area.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0 AND ls_dados-etapa = 0.

    DATA ls_businees TYPE ty_business.

    IF ls_dados-matnr IS INITIAL OR
       ls_dados-werks IS INITIAL OR
       ls_dados-lgort IS INITIAL.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 024
      severity = if_abap_behv_message=>severity-error
      )
      ) TO reported-movcntrl.

      RETURN.

    ENDIF.

    IF check_mat( ls_dados-matnr ) = abap_false.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 023
      severity = if_abap_behv_message=>severity-error
      )
      ) TO reported-movcntrl.

      RETURN.

    ENDIF.

    IF check_centro( ls_dados-werks ) = abap_false.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 025
      severity = if_abap_behv_message=>severity-error
      )
      ) TO reported-movcntrl.

      RETURN.

    ENDIF.


    IF check_dep( ls_dados-lgort ) = abap_false.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 026
      severity = if_abap_behv_message=>severity-error
      )
      ) TO reported-movcntrl.

      RETURN.

    ENDIF.

    IF ls_dados-menge IS INITIAL.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 027
      severity = if_abap_behv_message=>severity-error
      )
      ) TO reported-movcntrl.

      RETURN.

    ENDIF.

    IF check_pep( ls_dados-posid ) = abap_false.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 028
      severity = if_abap_behv_message=>severity-error
      )
      ) TO reported-movcntrl.

      RETURN.

    ENDIF.

    SELECT SINGLE werks bukrs j_1bbranch
    FROM t001k AS a
    INNER JOIN t001w AS b                              "#EC CI_BUFFJOIN
    ON a~bwkey = b~bwkey
    INTO CORRESPONDING FIELDS OF ls_businees
    WHERE a~bwkey = ls_dados-werks.

    IF sy-subrc <> 0.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 017
      severity = if_abap_behv_message=>severity-error
      )
      %element-bukrs = if_abap_behv=>mk-on
      %element-branch = if_abap_behv=>mk-on
      ) TO reported-movcntrl.


    ENDIF.

    DATA: ls_material TYPE ty_material,
          ls_bismt    TYPE ty_material.

    set_bismt( EXPORTING
                iv_matnr = ls_dados-matnr
                iv_werks = ls_dados-werks
                CHANGING
                cs_material = ls_material ).

    IF ls_material-bismt IS INITIAL.

    ELSE.

      DATA lv_convmat TYPE ze_matnr.

      lv_convmat = ls_material-bismt.
      lv_convmat = |{ lv_convmat ALPHA = IN }|.
      ls_material-bismt = lv_convmat.

      set_bismt2( EXPORTING
                  iv_matnr = ls_material-bismt
                  iv_werks = ls_dados-werks
                  CHANGING
                  cs_material = ls_bismt ).


      IF ls_bismt IS INITIAL OR ls_bismt-labst <= ls_dados-menge .

      ELSE.

        DATA(lv_mat) = ls_material-bismt.

      ENDIF.

    ENDIF.

    MODIFY ENTITIES OF zi_mm_mov_cntrl IN LOCAL MODE
    ENTITY movcntrl
    UPDATE FIELDS ( bukrs branch matnr1 )
    WITH VALUE #( FOR ls_dados2 IN lt_dados (
    %key = ls_dados-%key
    bukrs = ls_businees-bukrs
    branch = ls_businees-j_1bbranch
    matnr1 = lv_mat
    ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD check_key.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    SELECT COUNT( * )
    FROM zi_mm_mov_cntrl
    WHERE bukrs = @ls_dados-bukrs  AND
          branch = @ls_dados-branch AND
          mblnrsai = @ls_dados-mblnrsai AND "tem q gerar mov mercadoria, pra ter este numero
          id <> @ls_dados-id.

    IF sy-subrc = 0.

      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = 'ZMM_BENS_CONSUMO'
      number = 017
      severity = if_abap_behv_message=>severity-error
      )
      %element-bukrs = if_abap_behv=>mk-on
      %element-branch = if_abap_behv=>mk-on
      ) TO reported-movcntrl.

    ELSE.

      DATA: ls_material TYPE ty_material,
            ls_bismt    TYPE ty_material.

      set_bismt( EXPORTING
                  iv_matnr = ls_dados-matnr
                  iv_werks = ls_dados-werks
                  CHANGING
                  cs_material = ls_material ).

      IF ls_material-bismt IS INITIAL.

        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = 'ZMM_BENS_CONSUMO'
        number = 018
        severity = if_abap_behv_message=>severity-error
        )
        %element-bukrs = if_abap_behv=>mk-on
        %element-branch = if_abap_behv=>mk-on
        ) TO reported-movcntrl.

      ELSE.

        DATA lv_convmat TYPE ze_matnr.

        lv_convmat = ls_material-bismt.
        lv_convmat = |{ lv_convmat ALPHA = IN }|.
        ls_material-bismt = lv_convmat.

        set_bismt( EXPORTING
                    iv_matnr = ls_material-bismt
                    iv_werks = ls_dados-werks
                    CHANGING
                    cs_material = ls_bismt ).

        IF ls_bismt IS INITIAL.

          APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

          APPEND VALUE #(
          %tky = ls_dados-%tky
          %msg = new_message(
          id = 'ZMM_BENS_CONSUMO'
          number = 019
          severity = if_abap_behv_message=>severity-error
          )
          ) TO reported-movcntrl.


*        ELSE.
*
**          IF ls_bismt-labst <= ls_dados-Menge .
***
**            APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.
**
**            APPEND VALUE #(
**            %tky = ls_dados-%tky
**            %msg = new_message(
**            id = 'ZMM_BENS_CONSUMO'
**            number = 020
**            severity = if_abap_behv_message=>severity-error
**            )
**            ) TO reported-movcntrl.
**
**          ENDIF.
*
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD registrar.

    READ ENTITIES OF zi_mm_mov_cntrl
      IN LOCAL MODE ENTITY movcntrl
      ALL FIELDS WITH
      CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    set_refresh( ).

*    READ ENTITIES OF zi_mm_mov_cntrl
*          ENTITY movcntrl BY \_matcntrl
*        ALL FIELDS WITH
*      CORRESPONDING #( keys ) RESULT DATA(lt_mat).

*    IF lines( lt_mat ) <> ls_dados-menge.
*
*      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.
*
*      APPEND VALUE #(
*      %tky = ls_dados-%tky
*      %msg = new_message(
*      id = 'ZMM_BENS_CONSUMO'
*      number = 021
*      severity = if_abap_behv_message=>severity-error
*      )
*      %element-bukrs = if_abap_behv=>mk-on
*      %element-branch = if_abap_behv=>mk-on
*      ) TO reported-movcntrl.
*
*    ELSE.

    gv_wait_async = abap_false.

    DATA ls_document TYPE ztmm_mov_cntrl. "ztmm_mov_cntrl.

    ls_document = set_doc( CORRESPONDING #( ls_dados )  ).

    ls_document-etapa = 1. "Botão Registrar - baixa

    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_BAPI_GOODSMVT'
      STARTING NEW TASK 'BENS_CONSUMO_GOODSMVT'
      CALLING setup_messages ON END OF TASK
      CHANGING
        cs_documento = ls_document.

    WAIT UNTIL gv_wait_async = abap_true.

    READ TABLE gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>)
                      WITH KEY type = 'S'
                               number = 001 BINARY SEARCH.

    IF sy-subrc = 0.

      READ ENTITIES OF zi_mm_mov_cntrl IN LOCAL MODE
          ENTITY movcntrl
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_upd).

      MODIFY ENTITIES OF zi_mm_mov_cntrl IN LOCAL MODE
      ENTITY movcntrl
      UPDATE SET FIELDS WITH VALUE #( FOR ls_upd IN lt_upd
                                      ( %key    = ls_upd-%key
                                         mblnrsai = gs_doc-mblnr_sai
                                         mjahr    = gs_doc-mjahr
                                      ) ).


      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = <fs_msg>-id
      number = <fs_msg>-number
      v1 = gs_doc-mblnr_sai
      v2 = gs_doc-mjahr
      severity = if_abap_behv_message=>severity-success
      )
      ) TO reported-movcntrl.

    ELSE.

      LOOP AT gt_msg ASSIGNING <fs_msg>.

        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = <fs_msg>-id
        number = <fs_msg>-number
        severity = if_abap_behv_message=>severity-error
        )
        ) TO reported-movcntrl.

      ENDLOOP.

    ENDIF.

*    ENDIF.

  ENDMETHOD.

  METHOD setup_messages.

    CASE p_task.

      WHEN 'BENS_CONSUMO_GOODSMVT'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPI_GOODSMVT'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.

      WHEN 'BENS_CONSUMO_SIMULATE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPI_ORDER_SIMULATE'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.


      WHEN 'BENS_CONSUMO_NFSAIDA'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPI_CREATE_NF'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.


      WHEN 'BENS_CONSUMO_POSTING'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPI_POSTING'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.

      WHEN 'BENS_CONSUMO_NFENTRADA'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPI_CREATE_NF'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.


      WHEN 'BENS_CONSUMO_GOODSMVTENT'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPI_GOODSMVT'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.

      WHEN 'BENS_CONSUMO_ESTORNO'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_BAPIS_ESTORNO'
            IMPORTING
                et_return = gt_msg
            CHANGING
              cs_documento = gs_doc.


    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.

  METHOD simul_imp.

    DATA lv_partner TYPE bu_partner.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    set_refresh( ).

*    lv_partner = keys[ 1 ]-%param-partner.

    gv_wait_async = abap_false.

    DATA ls_document TYPE ztmm_mov_cntrl.

    ls_document = set_doc( CORRESPONDING #( ls_dados ) ).

    SELECT SINGLE kunnr
      FROM t001w
      WHERE werks = @ls_document-werks
      INTO @DATA(lv_kunnr).

    CHECK sy-subrc = 0.

    ls_document-partner = lv_kunnr.

    ls_document-etapa = 2. "Botão Simular impostos

    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_BAPI_ORDER_SIMULATE'
      STARTING NEW TASK 'BENS_CONSUMO_SIMULATE'
      CALLING setup_messages ON END OF TASK
      CHANGING
        cs_documento = ls_document.

    WAIT UNTIL gv_wait_async = abap_true.

    READ TABLE gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>)
                      WITH KEY type = 'S'
                               number = 004 BINARY SEARCH.

    IF sy-subrc = 0.


      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = <fs_msg>-id
      number = <fs_msg>-number
      severity = if_abap_behv_message=>severity-success
      )
      ) TO reported-movcntrl.

    ELSE.

      LOOP AT gt_msg ASSIGNING <fs_msg>.

        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = <fs_msg>-id
        number = <fs_msg>-number
        severity = if_abap_behv_message=>severity-error
        )
        ) TO reported-movcntrl.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD nfe_saida.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    set_refresh( ).

    gv_wait_async = abap_false.

    DATA ls_document TYPE ztmm_mov_cntrl.

    ls_document = set_doc( CORRESPONDING #( ls_dados ) ).

    ls_document-etapa = 3. "Botão Gerar NFe saída

    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_BAPI_CREATE_NF'
      STARTING NEW TASK 'BENS_CONSUMO_NFSAIDA'
      CALLING setup_messages ON END OF TASK
      CHANGING
        cs_documento = ls_document.

    WAIT UNTIL gv_wait_async = abap_true.

    READ TABLE gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>)
                      WITH KEY type = 'S'
                               number = 006 BINARY SEARCH.

    IF sy-subrc = 0.

      READ ENTITIES OF zi_mm_mov_cntrl IN LOCAL MODE
      ENTITY movcntrl
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_upd).

      MODIFY ENTITIES OF zi_mm_mov_cntrl IN LOCAL MODE
      ENTITY movcntrl
      UPDATE SET FIELDS WITH VALUE #( FOR ls_upd IN lt_upd
                                      ( %key    = ls_upd-%key
                                         docnums = gs_doc-docnum_s
                                      ) ).

      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #(
      %tky      = ls_dados-%tky
      %msg      = new_message(
      id        = <fs_msg>-id
      number    = <fs_msg>-number
      v1        = gs_doc-docnum_s
      severity  = if_abap_behv_message=>severity-success
      )
      ) TO reported-movcntrl.

    ELSE.

      LOOP AT gt_msg ASSIGNING <fs_msg>.

        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = <fs_msg>-id
        number = <fs_msg>-number
        severity = if_abap_behv_message=>severity-error
        )
        ) TO reported-movcntrl.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD contab.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    set_refresh( ).

    gv_wait_async = abap_false.

    DATA ls_document TYPE ztmm_mov_cntrl.

    ls_document = set_doc( CORRESPONDING #( ls_dados ) ).

    ls_document-etapa = 4. "Botão Contabilizar

    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_BAPI_POSTING'
      STARTING NEW TASK 'BENS_CONSUMO_POSTING'
      CALLING setup_messages ON END OF TASK
      CHANGING
        cs_documento = ls_document.

    WAIT UNTIL gv_wait_async = abap_true.

    READ TABLE gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>)
                      WITH KEY type = 'S'
                               number = 008 BINARY SEARCH.

    IF sy-subrc = 0.

      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = <fs_msg>-id
      number = <fs_msg>-number
      v1 = gs_doc-belnr
      v2 = gs_doc-gjahr_dc
      severity = if_abap_behv_message=>severity-success
      )
      ) TO reported-movcntrl.

    ELSE.

      LOOP AT gt_msg ASSIGNING <fs_msg>.

        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = <fs_msg>-id
        number = <fs_msg>-number
        severity = if_abap_behv_message=>severity-error
        )
        ) TO reported-movcntrl.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD nfe_ent.

    READ ENTITIES OF zi_mm_mov_cntrl
      IN LOCAL MODE ENTITY movcntrl
      ALL FIELDS WITH
      CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    READ ENTITIES OF zi_mm_mov_cntrl
          ENTITY movcntrl BY \_matcntrl
        ALL FIELDS WITH
      CORRESPONDING #( keys ) RESULT DATA(lt_mat).

    IF lt_mat IS INITIAL.

      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #( %tky = ls_dados-%tky
                      %msg = new_message(
                        id = 'ZMM_BENS_CONSUMO'
                    number = 021
                  severity = if_abap_behv_message=>severity-error )

      %element-bukrs  = if_abap_behv=>mk-on
      %element-branch = if_abap_behv=>mk-on ) TO reported-movcntrl.

      RETURN.

    ENDIF.

    set_refresh( ).

    gv_wait_async = abap_false.

    DATA ls_document TYPE ztmm_mov_cntrl.

    ls_document = set_doc( CORRESPONDING #( ls_dados ) ).

    IF set_imobilizado( CHANGING cs_doc = ls_document ) = abap_true.

      ls_document-etapa = 5. "Botão Gerar NFe entrada

      gv_wait_async = abap_false.

      CALL FUNCTION 'ZFMMM_BAPI_CREATE_NF'
        STARTING NEW TASK 'BENS_CONSUMO_NFENTRADA'
        CALLING setup_messages ON END OF TASK
        EXPORTING
          iv_nfe_entrada = abap_true
        CHANGING
          cs_documento   = ls_document.

      WAIT UNTIL gv_wait_async = abap_true.

      READ TABLE gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>)
                        WITH KEY type = 'S'
                                 number = 006 BINARY SEARCH.

      IF sy-subrc = 0.


        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = <fs_msg>-id
        number = <fs_msg>-number
        v1      = gs_doc-docnum_ent
        severity = if_abap_behv_message=>severity-success
        )
        ) TO reported-movcntrl.

      ELSE.

        LOOP AT gt_msg ASSIGNING <fs_msg>.

          APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

          APPEND VALUE #(
          %tky = ls_dados-%tky
          %msg = new_message(
          id = <fs_msg>-id
          number = <fs_msg>-number
          severity = if_abap_behv_message=>severity-error
          )
          ) TO reported-movcntrl.

        ENDLOOP.
      ENDIF.

*    ELSE.

    ENDIF.

  ENDMETHOD.

  METHOD set_imobilizado.

    rv_ok = abap_true.


  ENDMETHOD.

  METHOD mov_merc_ent.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    set_refresh( ).

    gv_wait_async = abap_false.

    DATA ls_document TYPE ztmm_mov_cntrl.

    ls_document = set_doc( CORRESPONDING #( ls_dados ) ).

    ls_document-etapa = 6. "Botão Gerar Mov.Mercadoria Entrada

    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_BAPI_GOODSMVT'
      STARTING NEW TASK 'BENS_CONSUMO_GOODSMVTENT'
      CALLING setup_messages ON END OF TASK
      CHANGING
        cs_documento = ls_document.

    WAIT UNTIL gv_wait_async = abap_true.

    READ TABLE gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>)
                      WITH KEY type = 'S'
                               number = 001 BINARY SEARCH.

    IF sy-subrc = 0.


      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

      APPEND VALUE #(
      %tky = ls_dados-%tky
      %msg = new_message(
      id = <fs_msg>-id
      number = <fs_msg>-number
      v1 = gs_doc-mblnr_ent
      v2 = gs_doc-mjahr_ent
      severity = if_abap_behv_message=>severity-success
      )
      ) TO reported-movcntrl.

    ELSE.

      LOOP AT gt_msg ASSIGNING <fs_msg>.

        APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

        APPEND VALUE #(
        %tky = ls_dados-%tky
        %msg = new_message(
        id = <fs_msg>-id
        number = <fs_msg>-number
        severity = if_abap_behv_message=>severity-error
        )
        ) TO reported-movcntrl.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.

*  METHOD estorno.
*
*    READ ENTITIES OF zi_mm_mov_cntrl
*    IN LOCAL MODE ENTITY movcntrl
*    ALL FIELDS WITH
*    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).
*
*    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA
*
*    CHECK sy-subrc = 0.
*
*    DATA ls_document TYPE ztmm_mov_cntrl.
*
*    ls_document = set_doc( ls_dados ).
*
*    gv_wait_async = abap_false.
*
*    CALL FUNCTION 'ZFMMM_BAPIS_ESTORNO'
*      STARTING NEW TASK 'BENS_CONSUMO_ESTORNO'
*      CALLING setup_messages ON END OF TASK
*      CHANGING
*        cs_documento = ls_document.
*
*    WAIT UNTIL gv_wait_async = abap_true.
*
*    LOOP AT gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
*
*      IF <fs_msg>-type = 'S'.
*
*        DATA(lv_severity) = if_abap_behv_message=>severity-error.
*
*      ELSEIF <fs_msg>-type = 'E'.
*
*        lv_severity = if_abap_behv_message=>severity-error.
*
*      ENDIF.
*
*
*      APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.
*
*      APPEND VALUE #(
*      %tky = ls_dados-%tky
*      %msg = new_message(
*      id = <fs_msg>-id
*      number = <fs_msg>-number
*      severity = lv_severity
*      )
*      ) TO reported-movcntrl.
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    result = VALUE #( FOR ls_entity IN lt_dados
                     ( %key = ls_entity-%key

    %features = VALUE #(

    %delete = COND #( WHEN ls_entity-etapa = 0
                      THEN if_abap_behv=>fc-o-enabled
                      ELSE if_abap_behv=>fc-o-disabled )

    %action-registrar = COND #( WHEN ls_entity-etapa = 0
                        THEN if_abap_behv=>fc-o-enabled
                        ELSE if_abap_behv=>fc-o-disabled )

    %action-simul_imp = COND #( WHEN ls_entity-etapa = 1
                        THEN if_abap_behv=>fc-o-enabled
                        ELSE if_abap_behv=>fc-o-disabled )

    %action-nfe_saida = COND #( WHEN ls_entity-etapa = 2
                        THEN if_abap_behv=>fc-o-enabled
                        ELSE if_abap_behv=>fc-o-disabled )

    %action-contab = COND #( WHEN ls_entity-etapa = 3
                        THEN if_abap_behv=>fc-o-enabled
                        ELSE if_abap_behv=>fc-o-disabled )

    %action-nfe_ent = COND #( WHEN ls_entity-etapa = 4
                        THEN if_abap_behv=>fc-o-enabled
                        ELSE if_abap_behv=>fc-o-disabled )

    %action-mov_merc_ent = COND #( WHEN ls_entity-etapa = 5
                        THEN if_abap_behv=>fc-o-enabled
                        ELSE if_abap_behv=>fc-o-disabled )

*    %action-estorno = COND #( WHEN ls_entity-etapa BETWEEN 1 AND 6
*                        THEN if_abap_behv=>fc-o-enabled
*                        ELSE if_abap_behv=>fc-o-disabled )

    %assoc-_matcntrl = COND #( WHEN ls_entity-etapa = 0
                                 OR ls_entity-etapa = 1
                                 OR ls_entity-etapa = 2
                                 OR ls_entity-etapa = 3
                                 OR ls_entity-etapa = 4
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

    %field-matnr = COND #( WHEN ls_entity-etapa > 0
                             OR ls_entity-posid IS NOT INITIAL
        THEN if_abap_behv=>fc-f-read_only
        ELSE if_abap_behv=>fc-f-unrestricted )

    %field-werks = COND #( WHEN ls_entity-etapa > 0 OR ls_entity-posid IS NOT INITIAL
           THEN if_abap_behv=>fc-f-read_only
           ELSE if_abap_behv=>fc-f-unrestricted )

    %field-menge = COND #( WHEN ls_entity-etapa > 0 OR ls_entity-posid IS NOT INITIAL
           THEN if_abap_behv=>fc-f-read_only
           ELSE if_abap_behv=>fc-f-unrestricted )

    %field-meins = COND #( WHEN ls_entity-etapa > 0 OR ls_entity-posid IS NOT INITIAL
           THEN if_abap_behv=>fc-f-read_only
           ELSE if_abap_behv=>fc-f-unrestricted )

    %field-lgort = COND #( WHEN ls_entity-etapa > 0 OR ls_entity-posid IS NOT INITIAL
           THEN if_abap_behv=>fc-f-read_only
           ELSE if_abap_behv=>fc-f-unrestricted )

    %field-posid = COND #( WHEN ls_entity-etapa > 0
           THEN if_abap_behv=>fc-f-read_only
           ELSE if_abap_behv=>fc-f-unrestricted )

    ) ) ).


  ENDMETHOD.


  METHOD set_refresh.

    FREE: gt_msg, gs_doc.

  ENDMETHOD.


  METHOD set_doc.

*    DATA: lv_lgort TYPE lgort_d.
*
*    DATA(lo_param) = NEW zclca_tabela_parametros( ).
*
*    TRY.
*        lo_param->m_get_single(
*          EXPORTING
*            iv_modulo = 'MM'
*            iv_chave1 = 'MONITOR_IMOBILIZACAO'
*            iv_chave2 = 'DEPOSITO'
**        iv_chave3 =
*          IMPORTING
*            ev_param  = lv_lgort ).
*
*      CATCH zcxca_tabela_parametros.
*    ENDTRY.

    rs_doc-id           = is_doc-id.
    rs_doc-bukrs        = is_doc-bukrs.
    rs_doc-branch       = is_doc-branch.
    rs_doc-mblnr_sai    = is_doc-mblnrsai.
    rs_doc-mjahr        = is_doc-mjahr.
    rs_doc-mblpo        = is_doc-mblpo.
    rs_doc-status_geral = is_doc-statusgeral.
    rs_doc-status1      = is_doc-status1.
    rs_doc-mblnr_est    = is_doc-mblnrest.
    rs_doc-mjahr_est    = is_doc-mjahrest.
    rs_doc-docnum_s     = is_doc-docnums.
    rs_doc-status2      = is_doc-status2.
    rs_doc-belnr        = is_doc-belnr.
    rs_doc-bukrs_dc     = is_doc-bukrsdc.
    rs_doc-gjahr_dc     = is_doc-gjahrdc.
    rs_doc-status3      = is_doc-status3.
    rs_doc-mblnr_ent    = is_doc-mblnrent.
    rs_doc-mjahr_ent    = is_doc-mjahrent.
    rs_doc-mblpo_ent    = is_doc-mblpoent.
    rs_doc-status4      = is_doc-status4.
    rs_doc-mblnr_est_ent = is_doc-mblnrestent.
    rs_doc-bldat        = is_doc-bldat.
    rs_doc-docnum_ent   = is_doc-docnument.
    rs_doc-docdat       = is_doc-docdat.
    rs_doc-status5      = is_doc-status5.
    rs_doc-docnum_est_ent = is_doc-docnumestent.
    rs_doc-docnum_est_sai = is_doc-docnumestsai.
    rs_doc-belnr_est    = is_doc-belnrest.
    rs_doc-gjahr_est    = is_doc-gjahrest.
    rs_doc-bldat_est    = is_doc-bldatest.
    rs_doc-etapa        = is_doc-etapa.
    rs_doc-matnr        = is_doc-matnr.
    rs_doc-matnr1       = is_doc-matnr1.
    rs_doc-werks        = is_doc-werks.
    rs_doc-menge        = is_doc-menge.
    rs_doc-meins        = is_doc-meins.
    rs_doc-lgort        = is_doc-lgort.
*    rs_doc-lgort        = lv_lgort.
    rs_doc-posid        = is_doc-posid.
    rs_doc-anln1        = is_doc-anln1.
    rs_doc-anln2        = is_doc-anln2.
    rs_doc-invnr        = is_doc-invnr.
    rs_doc-partner      = is_doc-partner.
    rs_doc-mjahr_est_ent = is_doc-mjahrestent.

  ENDMETHOD.

  METHOD set_bismt.

    SELECT SINGLE
      a~matnr,
      a~bismt,
      c~werks,
      d~lgort,
      d~labst
    FROM mara AS a
   INNER JOIN marc AS c ON a~matnr = c~matnr
   INNER JOIN mard AS d ON a~matnr = d~matnr
                       AND c~werks = d~werks
   WHERE a~matnr = @iv_matnr
     AND c~werks = @iv_werks
    INTO @cs_material.

  ENDMETHOD.

  METHOD set_bismt2.

    DATA: lv_lgort TYPE lgort_d.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_single(
          EXPORTING
            iv_modulo = 'MM'
            iv_chave1 = 'MONITOR_IMOBILIZACAO'
            iv_chave2 = 'DEPOSITO'
*        iv_chave3 =
          IMPORTING
            ev_param  = lv_lgort ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    SELECT SINGLE
      a~matnr,
      a~bismt,
      c~werks,
      d~lgort,
      d~labst
    FROM mara AS a
   INNER JOIN marc AS c ON a~matnr = c~matnr
   INNER JOIN mard AS d ON a~matnr = d~matnr
                       AND c~werks = d~werks
                       AND d~lgort = @lv_lgort
   WHERE a~matnr = @iv_matnr
     AND c~werks = @iv_werks
    INTO @cs_material.

  ENDMETHOD.

  METHOD check_mat.

    SELECT COUNT(*)
    FROM mara
    WHERE matnr = iv_matnr.

    IF sy-subrc = 0.

      rv_ok = abap_true.

    ELSE.

      rv_ok = abap_false.

    ENDIF.

  ENDMETHOD.

  METHOD check_centro.

    SELECT COUNT(*)
    FROM t001w                                           "#EC CI_BYPASS
    WHERE werks = iv_werks.

    IF sy-subrc = 0.

      rv_ok = abap_true.

    ELSE.

      rv_ok = abap_false.

    ENDIF.

  ENDMETHOD.

  METHOD check_dep.

    SELECT COUNT(*)
      FROM i_productionstoragelocationvh
     WHERE prodorderissuelocation = @iv_dep.

    IF sy-subrc = 0.
      rv_ok = abap_true.
    ELSE.
      rv_ok = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD check_pep.

    rv_ok = abap_true.

    CALL FUNCTION 'CONVERSION_EXIT_ABPSP_INPUT'
      EXPORTING
        input     = iv_pep
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    IF sy-subrc <> 0.
      rv_ok = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD valida_mat.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    IF sy-subrc IS INITIAL.

*       SELECT MATNR,
*              WERKS,
*              LGORT,
*              LABST
*         from MARD



    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_matcntrl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS check_imob FOR VALIDATE ON SAVE
      IMPORTING keys FOR _matcntrl~check_imob.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _matcntrl RESULT result.

ENDCLASS.

CLASS lcl_matcntrl IMPLEMENTATION.

  METHOD check_imob.

    READ ENTITIES OF zi_mm_mov_cntrl
    IN LOCAL MODE ENTITY movcntrl
    ALL FIELDS WITH
    CORRESPONDING #( keys ) RESULT DATA(lt_dados) FAILED DATA(lt_erro).

    READ TABLE lt_dados INTO DATA(ls_dados) INDEX 1. "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    APPEND VALUE #( %tky = ls_dados-%tky ) TO failed-movcntrl.

    APPEND VALUE #(
    %tky = ls_dados-%tky
    %msg = new_message(
    id = 'ZMM_BENS_CONSUMO'
    number = 100
    severity = if_abap_behv_message=>severity-error
    )
    ) TO reported-movcntrl.


  ENDMETHOD.

  METHOD get_features.


    READ ENTITIES OF zi_mm_mov_cntrl
      IN LOCAL MODE ENTITY _matcntrl
      ALL FIELDS WITH
      CORRESPONDING #( keys ) RESULT DATA(lt_mat) FAILED DATA(lt_erro).

    DATA(lv_key) = lt_mat[ 1 ]-idmov.

    READ ENTITIES OF zi_mm_mov_cntrl
      ENTITY _matcntrl BY \_movcntrl
        ALL FIELDS WITH

    CORRESPONDING #( keys ) RESULT DATA(lt_mov).

    READ TABLE lt_mov INTO DATA(ls_mov) INDEX 1.   "#EC CI_LOOP_INTO_WA

    CHECK sy-subrc = 0.

    result = VALUE #( FOR ls_entity IN lt_mat
                       ( %key = ls_entity-%key

    %features = VALUE #(


      %delete = COND #( WHEN ls_mov-etapa = 0
                          OR ls_mov-etapa = 1
                          OR ls_mov-etapa = 2
                          OR ls_mov-etapa = 3
                          OR ls_mov-etapa = 4
                          THEN if_abap_behv=>fc-o-enabled
                          ELSE if_abap_behv=>fc-o-disabled )

      %update = COND #( WHEN ls_mov-etapa = 0
                          THEN if_abap_behv=>fc-o-enabled
                          ELSE if_abap_behv=>fc-o-disabled )

    %field-anln1 = COND #( WHEN ls_mov-etapa > 0
         THEN if_abap_behv=>fc-f-read_only
         ELSE if_abap_behv=>fc-f-unrestricted )

         %field-anln2 = if_abap_behv=>fc-f-read_only

         %field-invnr = if_abap_behv=>fc-f-read_only

         %field-lgort = if_abap_behv=>fc-f-read_only

         ) ) ).


  ENDMETHOD.

ENDCLASS.
