class ZCLMM_RET_ARM_GV definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_linha_lote,
        lifnr       TYPE lfa1-lifnr,
        werks       TYPE t001w-werks,
        matnr       TYPE matdoc-matnr,
        xml         TYPE /xnfe/id,
        matnr_req   TYPE j_1bnflin-matnr,
        lifnr_req   TYPE j_1bnfe_active-parid,
        werks_req   TYPE j_1bnflin-werks,
        mat_xml     TYPE /xnfe/matnr,
        nnf         TYPE /xnfe/nnf,
        dataemissao TYPE /xnfe/demi,
        nitem       TYPE /xnfe/nitem,
        serie       TYPE /xnfe/serie,
        qtd         TYPE mslb-lblab,
        lote        TYPE mslb-charg,
        valor       TYPE /xnfe/nftot,
        deposito    TYPE mseg-lgort,
        um          TYPE /xnfe/meins,
      END OF ty_linha_lote .
  types:
    ty_t_linha_lote TYPE TABLE OF ty_linha_lote .
  types:
    ty_hd  TYPE STANDARD TABLE OF /xnfe/innfehd .
  types:
    ty_act TYPE STANDARD TABLE OF  j_1bnfe_active .
  types:
    ty_lin  TYPE STANDARD TABLE OF  j_1bnflin .
  types TY_NFE type /XNFE/IF_NFE_DET_400_T .
  types:
    ty_mat  TYPE STANDARD TABLE OF  matdoc .
  types:
    ty_mslb TYPE STANDARD TABLE OF  mslb .
  types:
    BEGIN OF ty_act_aux,
        regio   TYPE j_1bnfe_active-regio,
        nfyear  TYPE j_1bnfe_active-nfyear,
        nfmonth TYPE j_1bnfe_active-nfmonth,
        stcd1   TYPE j_1bnfe_active-stcd1,
        model   TYPE j_1bnfe_active-model,
        nfnum9  TYPE j_1bnfe_active-nfnum9,
      END OF ty_act_aux .
  types:
    BEGIN OF ty_mat_aux,
        mblnr TYPE matdoc-mblnr,
        mjahr TYPE matdoc-mjahr,
      END OF ty_mat_aux .

  constants GC_MSG_ID type SY-MSGID value 'ZMM_GRAO_VERDE' ##NO_TEXT.

  methods CALCULA_GUID
    exporting
      !EV_GUID type SYSUUID_X16
      !ET_RETURN type BAPIRET2_T
    returning
      value(RV_GUID) type SYSUUID_X16 .
  methods VALIDA_GUID
    importing
      !IV_XML type /XNFE/ID
    exporting
      !ET_RETURN type BAPIRET2_T
      value(EV_GUID) type SYSUUID_X16 .
  methods BUSCA_DADOS
    importing
      !IV_XML type /XNFE/ID optional
      !IV_ATRIBUIR type LXEBOOL
      !IT_CONCLUIR type ZCTGMM_KEYS_RET optional
      !IV_CONCLUIR type LXEBOOL
    exporting
      !ET_RETURN type BAPIRET2_T
    changing
      !CS_ATRIBUIR type ZTMM_RET_ARM_GV optional .
  methods VALIDA_TABELA
    importing
      !IT_CONCLUIR type ZCTGMM_KEYS_RET
    exporting
      !ET_RETURN type BAPIRET2_T .
  class-methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .
protected section.
private section.

  class-data GV_WAIT_ASYNC_1 type ABAP_BOOL .
  class-data GV_WAIT_ASYNC_2 type ABAP_BOOL .
  class-data GV_WAIT_ASYNC_3 type ABAP_BOOL .
  class-data GS_MATERIALDOCUMENTO type BAPI2017_GM_HEAD_RET-MAT_DOC .
  class-data GS_MATDOCUMENTYEAR type BAPI2017_GM_HEAD_RET-DOC_YEAR .
  class-data GT_RETURN type BAPIRET2_T .
  constants GC_MSG_02 type SY-MSGNO value '002' ##NO_TEXT.
  constants GC_MSG_ERROR type SY-MSGTY value 'E' ##NO_TEXT.
  constants GC_MSG_SUCESS type SY-MSGTY value 'S' ##NO_TEXT.
  constants GC_MSG_03 type SY-MSGNO value '003' ##NO_TEXT.
  constants GC_MOVIMENT_RETORNO type BWART value 'Y42' ##NO_TEXT.
  constants GC_CODE_IVA type MWSKZ value 'C0' ##NO_TEXT.
  constants GC_MOVIMENT_BENEF_1 type BWART value 'Z43' ##NO_TEXT.
  constants GC_MOVIMENT_BENEF_2 type BWART value 'X01' ##NO_TEXT.
  constants GC_ACCOUNT_BENEF_1 type SAKNR value '2112000001' ##NO_TEXT.

  methods ATRIBUIR_MATERIAL
    importing
      !IT_HD type TY_HD
      !IT_NFE type TY_NFE
      !IT_ACT type TY_ACT
      !IT_LIN type TY_LIN
    exporting
      !ET_RETURN type BAPIRET2_T
    changing
      !CS_ATRIBUIR type ZTMM_RET_ARM_GV .
  methods LINHA_LOTE
    importing
      !IT_MAT type TY_MAT
      !IT_MSL type TY_MSLB
      !IT_NFE type /XNFE/IF_NFE_DET_400_T
      !IT_ACT type TY_ACT
      !IT_LIN type TY_LIN
      !IT_CONCLUIR type ZCTGMM_KEYS_RET
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods RETORNO
    importing
      !IS_LINHA_LOTE type TY_LINHA_LOTE
      !IT_LINHA_LOTE type TY_T_LINHA_LOTE
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods BENEFICIAMENTO
    importing
      !IS_LINHA_LOTE type TY_LINHA_LOTE
      !IT_LINHA_LOTE type TY_T_LINHA_LOTE
    exporting
      !ET_RETURN type BAPIRET2_T .
ENDCLASS.



CLASS ZCLMM_RET_ARM_GV IMPLEMENTATION.


  METHOD atribuir_material.

*    SELECT *                                   " tabela com poucos campos, será necessário utilizar todos
    SELECT lifnrcode,
           werkscode,
           cfop,
           nnf,
           xml,
           dataemissao,
           nitem,
           docnum,
*           credat,
           materialatribuido,
           processo,
*           docmaterial,
*           status,
*           statuscriticality,
           qcom,
           ucom,
           vprod,
           cprod,
           serie
      FROM zi_mm_ret_arm_graoverde
     WHERE lifnrcode   = @cs_atribuir-lifnr
       AND werkscode   = @cs_atribuir-werks
       AND cfop        = @cs_atribuir-cfop
       AND nnf         = @cs_atribuir-nnf
       AND xml         = @cs_atribuir-nfeid
       AND dataemissao = @cs_atribuir-demi
       AND nitem       = @cs_atribuir-nitem
      INTO @DATA(ls_ret)
        UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      DATA(lt_lin) = it_lin[].
      SORT lt_lin BY docnum.

      DATA(lt_nfe_aux) = it_nfe[].
      SORT lt_nfe_aux BY n_item.

      READ TABLE lt_nfe_aux ASSIGNING FIELD-SYMBOL(<fs_nfe>)
                                          WITH KEY n_item = cs_atribuir-nitem
                                          BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        DATA(lt_act_aux) = it_act[].
        SORT lt_act_aux BY parid.

        READ TABLE lt_act_aux TRANSPORTING NO FIELDS
                                            WITH KEY parid = cs_atribuir-lifnr
                                            BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          LOOP AT lt_act_aux ASSIGNING FIELD-SYMBOL(<fs_act>) FROM sy-tabix.
            IF <fs_act>-parid NE cs_atribuir-lifnr.
              EXIT.
            ENDIF.

            DATA(lv_nfnum) = <fs_act>-nfnum9.

            DATA(lv_nfnum9) = <fs_act>-nfnum9.

            SHIFT lv_nfnum LEFT DELETING LEADING '0'.

            IF <fs_nfe>-inf_ad_prod CS lv_nfnum.
              EXIT.
            ENDIF.

            CLEAR lv_nfnum.
          ENDLOOP.
        ENDIF.
      ENDIF.

      IF lv_nfnum IS INITIAL.
        "" NF-e de referência não encontrada pelo informação do item".
        et_return[] = VALUE #( BASE et_return ( type   = 'E'
                                                id     = 'ZMM_GRAO_VERDE'
                                                number = '005' ) ).
        RETURN.
      ENDIF.

      lt_act_aux[] = it_act[].
      SORT lt_act_aux BY parid
                         nfnum9.

      READ TABLE lt_act_aux ASSIGNING FIELD-SYMBOL(<fs_act_aux>)
                                          WITH KEY parid  = cs_atribuir-lifnr
                                                   nfnum9 = lv_nfnum9
                                                   BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_lin TRANSPORTING NO FIELDS
                                        WITH KEY docnum = <fs_act_aux>-docnum
                                        BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) FROM sy-tabix.

            IF cs_atribuir-materialatribuido IS INITIAL.
              DATA(lv_materialatribuido) = ls_ret-materialatribuido.
            ELSE.
              lv_materialatribuido = cs_atribuir-materialatribuido.
            ENDIF.

            IF <fs_lin>-matnr EQ  lv_materialatribuido.
              DATA(lv_processo) = 1.
            ELSE.
              lv_processo = 2.
            ENDIF.

            IF <fs_lin>-docnum = <fs_act_aux>-docnum.
              EXIT.
            ENDIF.
          ENDLOOP.
        ENDIF.

        IF lv_processo IS NOT INITIAL.
          cs_atribuir-processo = lv_processo.
        ENDIF.

        MODIFY ztmm_ret_arm_gv FROM cs_atribuir.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD busca_dados.

    DATA: lt_act_aux TYPE STANDARD TABLE OF ty_act_aux,
          lt_mat_aux TYPE STANDARD TABLE OF ty_mat_aux,
          lt_nfe_det TYPE /xnfe/if_nfe_det_400_t.

    SELECT *
      FROM /xnfe/innfehd
     WHERE nfeid = @iv_xml
      INTO TABLE @DATA(lt_hd).

    IF sy-subrc IS INITIAL.

      DATA(lt_hd_aux) = lt_hd[].
      SORT lt_hd_aux BY guid_header.
      DELETE ADJACENT DUPLICATES FROM lt_hd_aux COMPARING guid_header.

      DATA(lt_hd_nfeid) = lt_hd[].
      SORT lt_hd_nfeid BY nfeid.   "Binary search

      " seleção para classificação de lote
      lt_hd_aux[] = lt_hd[].
      SORT lt_hd_aux BY guid_header.
      DELETE ADJACENT DUPLICATES FROM lt_hd_aux COMPARING guid_header.

      IF lt_hd_aux[] IS NOT INITIAL.
        SELECT guid_header,
               access_key
          FROM /xnfe/innfenfe
           FOR ALL ENTRIES IN @lt_hd_aux
         WHERE guid_header = @lt_hd_aux-guid_header
          INTO TABLE @DATA(lt_nfe).
*
        IF sy-subrc IS INITIAL.
*          DATA(lt_nfe_aux) = lt_nfe[].
*          SORT lt_nfe_aux BY access_key.
*          DELETE ADJACENT DUPLICATES FROM lt_nfe_aux COMPARING access_key.
*          IF lt_nfe_aux IS NOT INITIAL.
*
*            SELECT *
*              FROM /xnfe/innfehd
*              INTO TABLE @DATA(lt_hd_act)
*           FOR ALL ENTRIES IN @lt_nfe_aux
*             WHERE nfeid = @lt_nfe_aux-access_key.
*            IF sy-subrc IS INITIAL.


*              LOOP AT lt_hd_act ASSIGNING FIELD-SYMBOL(<fs_hd>).
*                APPEND INITIAL LINE TO lt_act_aux ASSIGNING FIELD-SYMBOL(<fs_act>).
*                <fs_act>-regio   =  <fs_hd>-uf_emit.
*                <fs_act>-nfyear  =  <fs_hd>-demi(4).
*                <fs_act>-nfmonth =  <fs_hd>-demi+4(2).
*                <fs_act>-stcd1   =  <fs_hd>-cnpj_emit.
*                <fs_act>-model   =  <fs_hd>-mod.
*                <fs_act>-nfnum9  =  <fs_hd>-nnf.
*              ENDLOOP.

*              IF  lt_act_aux[] IS NOT INITIAL.
          LOOP AT lt_nfe ASSIGNING FIELD-SYMBOL(<fs_nfe>).
            APPEND INITIAL LINE TO lt_act_aux ASSIGNING FIELD-SYMBOL(<fs_act>).
            <fs_act>-regio   = <fs_nfe>-access_key(2).
            <fs_act>-nfyear  = <fs_nfe>-access_key+2(2).
            <fs_act>-nfmonth = <fs_nfe>-access_key+4(2).
            <fs_act>-stcd1   = <fs_nfe>-access_key+6(14).
            <fs_act>-model   = <fs_nfe>-access_key+20(2).
            <fs_act>-nfnum9  = <fs_nfe>-access_key+25(9).
          ENDLOOP.

          IF  lt_act_aux[] IS NOT INITIAL.

            SELECT *
              FROM j_1bnfe_active
               FOR ALL ENTRIES IN @lt_act_aux
             WHERE regio   = @lt_act_aux-regio
               AND nfyear  = @lt_act_aux-nfyear
               AND nfmonth = @lt_act_aux-nfmonth
               AND stcd1   = @lt_act_aux-stcd1
               AND model   = @lt_act_aux-model
               AND nfnum9  = @lt_act_aux-nfnum9
              INTO TABLE @DATA(lt_act).

            IF sy-subrc IS INITIAL.
              DATA(lt_act_aux2) = lt_act[].
              SORT lt_act_aux2 BY docnum.
              DELETE ADJACENT DUPLICATES FROM lt_act_aux2 COMPARING docnum.
              IF lt_act_aux2[] IS NOT INITIAL.

                SELECT *
                  FROM j_1bnflin
                   FOR ALL ENTRIES IN @lt_act_aux2
                 WHERE docnum  = @lt_act_aux2-docnum
                  INTO TABLE @DATA(lt_lin).

                IF sy-subrc IS INITIAL.

                  LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).
                    APPEND INITIAL LINE TO lt_mat_aux ASSIGNING FIELD-SYMBOL(<fs_mat>).
                    <fs_mat>-mblnr   =  <fs_lin>-refkey(10).
                    <fs_mat>-mjahr  =  <fs_lin>-refkey+10(4).
                  ENDLOOP.

                  SELECT *
                    FROM matdoc
                     FOR ALL ENTRIES IN @lt_mat_aux
                   WHERE mblnr  = @lt_mat_aux-mblnr
                     AND mjahr  = @lt_mat_aux-mjahr
                    INTO TABLE @DATA(lt_mat).

                  IF sy-subrc IS INITIAL.

*                    DATA(lt_lin_aux) = lt_lin[].
*                    SORT lt_lin_aux BY matnr werks charg.
*                    DELETE ADJACENT DUPLICATES FROM lt_lin_aux COMPARING charg.
*                    IF lt_lin_aux[] IS NOT INITIAL.

                    DATA(lt_mat_aux2) = lt_mat[].
                    SORT lt_mat_aux2 BY matnr
                                        werks
                                        charg.
                    DELETE ADJACENT DUPLICATES FROM lt_mat_aux2 COMPARING charg.
                    IF lt_mat_aux2[] IS NOT INITIAL.

                      DATA(ls_act) = lt_act[ 1 ].

                      SELECT *
                        FROM mslb
                         FOR ALL ENTRIES IN @lt_mat_aux2
                       WHERE matnr = @lt_mat_aux2-matnr
                         AND werks = @lt_mat_aux2-werks
                         AND charg = @lt_mat_aux2-charg
                         AND sobkz = 'O'
                         AND lifnr = @ls_act-parid
                        INTO TABLE @DATA(lt_msl).

                      IF sy-subrc IS INITIAL.

                      ENDIF.
                    ENDIF.
                  ELSE.
                    " Item pendente de atribuição de material.
                    et_return[] = VALUE #( BASE et_return ( type   = gc_msg_error
                                                            id     = gc_msg_id
                                                            number = gc_msg_03 ) ).
                    RETURN.
                  ENDIF.

                ENDIF.
                READ TABLE lt_hd_nfeid ASSIGNING FIELD-SYMBOL(<fs_hd_xml>)
                                                     WITH KEY nfeid = iv_xml
                                                     BINARY SEARCH.
                IF sy-subrc IS INITIAL.

                         SELECT SINGLE xmlstring
                            FROM zi_mm_xnfe_inxml
                           WHERE guidheader = @<fs_hd_xml>-guid_header
                           INTO @DATA(lv_xmlstring).

                  IF sy-subrc IS INITIAL.
                    CALL FUNCTION '/XNFE/TRANSFORM_NFE_TO_ERP_400'
                      EXPORTING
                        iv_xml          = lv_xmlstring
                      IMPORTING
                        et_nfe_det      = lt_nfe_det
                      EXCEPTIONS
                        technical_error = 1
                        OTHERS          = 2.

                    IF sy-subrc <> 0.
                      " Implement suitable error handling here
                    ENDIF.
                  ENDIF.
                ENDIF.

                IF iv_atribuir IS NOT INITIAL.
                  me->atribuir_material( EXPORTING it_hd  = lt_hd
                                                   it_nfe = lt_nfe_det
                                                   it_act = lt_act
                                                   it_lin = lt_lin
                                         IMPORTING et_return = et_return
                                          CHANGING cs_atribuir = cs_atribuir ).

                ENDIF.
                IF iv_concluir IS NOT INITIAL.

                  me->linha_lote( EXPORTING it_mat      = lt_mat
                                            it_msl      = lt_msl
                                            it_nfe      = lt_nfe_det
                                            it_act      = lt_act
                                            it_lin      = lt_lin
                                            it_concluir = it_concluir
                                  IMPORTING et_return = et_return ).

                  " Processo executado com Sucesso, limpar tabela Z
                  READ TABLE et_return TRANSPORTING NO FIELDS
                                                     WITH KEY id = 'E'.

                  IF sy-subrc IS NOT INITIAL.
                    SELECT *
                      FROM ztmm_ret_arm_gv
                     WHERE usuario = @sy-uname
                      INTO TABLE @DATA(lt_keys).
                    IF sy-subrc IS INITIAL.
                      DELETE ztmm_ret_arm_gv FROM TABLE lt_keys.
                    ENDIF.
                  ENDIF.

                ENDIF.
              ENDIF.
            ELSE.
              et_return = VALUE #( BASE et_return ( id     = gc_msg_id
                                                    type   = gc_msg_error
                                                    number = gc_msg_02 ) ).
            ENDIF.
*          ENDIF.
*            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD calcula_guid.

    FREE: ev_guid.

    TRY.
        rv_guid = ev_guid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '005'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD valida_guid.
    "Valida se o usuário já executou algum processo na mesma data
*    SELECT *
*      FROM ztmm_ret_arm_gv
*      INTO TABLE @DATA(lt_xml)
*      WHERE usuario = @sy-uname AND
*            data = @sy-datum.
    SELECT *
      FROM ztmm_ret_arm_gv
      INTO TABLE @DATA(lt_xml)
      WHERE nfeid = @iv_xml.

    IF sy-subrc IS INITIAL.
      DATA(ls_xml) = lt_xml[ 1 ].
      IF iv_xml EQ ls_xml-nfeid.
        ev_guid = ls_xml-doc_uuid_h.
      ELSE.
      "XML diverge do processo já iniciado
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '001' ) )   .
      RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD linha_lote.

    DATA lt_linha_lote TYPE TABLE OF ty_linha_lote.
    DATA ls_linha_lote TYPE ty_linha_lote.
    DATA lv_conv_meins TYPE mseh3.
    DATA lv_qtde TYPE /xnfe/qcom_v20.
    DATA lv_valor TYPE /xnfe/nftot.
    DATA lv_menge TYPE  ekpo-menge.
    DATA lv_total TYPE mslb-lblab.
    DATA lv_valor_unit TYPE /xnfe/nftot.
    DATA lv_dif TYPE /xnfe/nftot.

    IF it_concluir[] IS NOT INITIAL.

      SELECT  *
        FROM zi_mm_ret_arm_graoverde
         FOR ALL ENTRIES IN @it_concluir
       WHERE lifnrcode   = @it_concluir-lifnr
         AND werkscode   = @it_concluir-werks
         AND cfop        = @it_concluir-cfop
         AND nnf         = @it_concluir-nnf
         AND xml         = @it_concluir-nfeid
         AND dataemissao = @it_concluir-demi
         AND nitem       = @it_concluir-nitem
        INTO TABLE @DATA(lt_ret).

      IF sy-subrc IS INITIAL.

        DATA(lt_lin) = it_lin[].
*        SORT lt_lin BY docnum.                      "Binary Search
        SORT lt_lin BY docnum matnr.
        DELETE ADJACENT DUPLICATES FROM lt_lin COMPARING docnum matnr.

        DATA(lt_act) = it_act[].
        SORT lt_act BY parid.                       "Binary Search
        DATA(lt_mat) = it_mat[].
        SORT lt_mat BY mblnr mjahr zeile.           "Binary Search
        DATA(lt_msl) = it_msl[].
        SORT lt_msl BY matnr ASCENDING lblab DESCENDING.
        SORT lt_ret BY nitem ASCENDING.

        LOOP AT lt_ret ASSIGNING FIELD-SYMBOL(<fs_ret>).

          CLEAR: lv_total, lv_qtde, lv_valor.

          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
            EXPORTING
              input          = <fs_ret>-ucom
              language       = sy-langu
            IMPORTING
              output         = lv_conv_meins
            EXCEPTIONS
              unit_not_found = 1
              OTHERS         = 2.

          IF lv_conv_meins IS NOT INITIAL.
            <fs_ret>-ucom = lv_conv_meins.
          ELSE.
            SELECT um_out
              UP TO 1 ROWS
             FROM ztmm_fiscal_inb
       INTO @DATA(lv_meins)
       WHERE lifnr = @<fs_ret>-lifnrcode AND
*             matnr = @<fs_ret>-material AND
             matnr = @<fs_ret>-materialatribuido AND
             um_in = @<fs_ret>-ucom.
            ENDSELECT.
            IF sy-subrc IS INITIAL.
              <fs_ret>-ucom = lv_meins.
            ELSE.
              SELECT um_out
                UP TO 1 ROWS
                FROM ztmm_fiscal_inb
                INTO @lv_meins
                WHERE lifnr = @<fs_ret>-lifnrcode AND
               matnr = @space AND
               um_in = @<fs_ret>-ucom.
              ENDSELECT.
              IF sy-subrc IS INITIAL.
                <fs_ret>-ucom = lv_meins.
              ELSE.
                SELECT um_out
                  UP TO 1 ROWS
                  FROM ztmm_fiscal_inb
                  INTO @lv_meins
                  WHERE lifnr = @space AND
                 matnr = @space AND
                 um_in = @<fs_ret>-ucom.
                ENDSELECT.
                IF sy-subrc IS INITIAL.
                  <fs_ret>-ucom = lv_meins.
                ELSE.
                  "message error
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

          READ TABLE it_nfe ASSIGNING FIELD-SYMBOL(<fs_nfe>) WITH KEY n_item = <fs_ret>-nitem.
          IF sy-subrc IS INITIAL.

            READ TABLE lt_act WITH KEY parid = <fs_ret>-lifnrcode
                              TRANSPORTING NO FIELDS BINARY SEARCH.

            LOOP AT lt_act ASSIGNING FIELD-SYMBOL(<fs_act>) FROM sy-tabix.
              IF <fs_act>-parid <> <fs_ret>-lifnrcode.
                EXIT.
              ENDIF.
              DATA(lv_nfnum) = <fs_act>-nfnum9.
              IF <fs_nfe>-inf_ad_prod CS lv_nfnum.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
          IF lv_nfnum IS INITIAL.
            ""NF-e de referência não encontrada pelo informação do item".
            et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '005' ) ).
            RETURN.
          ENDIF.
          READ TABLE it_act ASSIGNING FIELD-SYMBOL(<fs_act_aux>) WITH KEY parid  = <fs_ret>-lifnrcode
                                                                          nfnum9 = lv_nfnum.
          IF sy-subrc IS INITIAL.
            READ TABLE lt_lin WITH KEY docnum = <fs_act_aux>-docnum
                              TRANSPORTING NO FIELDS BINARY SEARCH.

            IF sy-subrc IS INITIAL.
*              LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) FROM sy-tabix.
              LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) WHERE docnum = <fs_act_aux>-docnum.
*                IF <fs_lin>-docnum <> <fs_act_aux>-docnum.
*                  EXIT.
*                ENDIF.
                CLEAR:  ls_linha_lote.
                ls_linha_lote-matnr       = <fs_ret>-materialatribuido.
                ls_linha_lote-lifnr       = <fs_ret>-lifnrcode.
                ls_linha_lote-werks       = <fs_ret>-werkscode.
                ls_linha_lote-nnf         = <fs_ret>-nnf.
                ls_linha_lote-xml         = <fs_ret>-xml.
                ls_linha_lote-mat_xml     = <fs_ret>-cprod.
                ls_linha_lote-dataemissao = <fs_ret>-dataemissao.
                ls_linha_lote-nitem       = <fs_ret>-nitem.
                ls_linha_lote-serie       = <fs_ret>-serie.
                ls_linha_lote-matnr_req   = <fs_lin>-matnr.
                ls_linha_lote-werks_req   = <fs_lin>-werks.
                ls_linha_lote-lifnr_req   = <fs_act_aux>-parid.
                ls_linha_lote-um          = <fs_ret>-ucom.

                READ TABLE lt_mat ASSIGNING FIELD-SYMBOL(<fs_mat>) WITH KEY mblnr = <fs_lin>-refkey(10)
                                                                  mjahr = <fs_lin>-refkey+4(10)
                                                                  zeile = <fs_lin>-refitm
                                                                  BINARY SEARCH.
                IF sy-subrc IS  INITIAL.
                  ls_linha_lote-deposito = <fs_mat>-lgort.
                  ls_linha_lote-um = <fs_mat>-meins.
*       Converter quantidade para Unidade de Medida Básica:
                  IF lv_total IS INITIAL.
                    lv_menge = <fs_ret>-qcom.

                    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
                      EXPORTING
                        i_matnr  = <fs_ret>-materialatribuido
                        i_in_me  = <fs_ret>-ucom
                        i_out_me = <fs_mat>-meins
                        i_menge  = lv_menge
                      IMPORTING
                        e_menge  = lv_menge
                                   EXCEPTIONS
                                   error_in_application
                                   error.
                    IF sy-subrc <> 0.
* Implement suitable error handling here
                    ENDIF.

                    <fs_ret>-qcom = lv_menge.
                    lv_total = <fs_ret>-qcom.
                    lv_valor_unit = <fs_ret>-vprod / lv_total.
                  ENDIF.

*                  READ TABLE lt_msl ASSIGNING FIELD-SYMBOL(<fs_msl>) WITH KEY matnr = <fs_mat>-matnr
*                                                                              werks = <fs_mat>-werks
**                                                                              charg = <fs_mat>-charg
*                                                                              lifnr = <fs_act_aux>-parid.
*                  IF sy-subrc IS INITIAL.
                  LOOP AT lt_msl ASSIGNING FIELD-SYMBOL(<fs_msl>) WHERE matnr = <fs_mat>-matnr AND
                                                                        werks = <fs_mat>-werks AND
                                                                        charg = <fs_lin>-charg AND
                                                                        lifnr = <fs_act_aux>-parid.
                    DATA(lv_tabix) = sy-tabix.
                    DATA(lv_lblab) = <fs_msl>-lblab.

                    IF lv_total <= <fs_msl>-lblab .

                      ls_linha_lote-qtd   = lv_total.
                      ls_linha_lote-lote  = <fs_msl>-charg.
*                      ls_linha_lote-valor = <fs_ret>-vprod / ls_linha_lote-qtd.
                      ls_linha_lote-valor = lv_valor_unit * ls_linha_lote-qtd.
                      lv_qtde             = ls_linha_lote-qtd + lv_qtde.
                      lv_valor            = ls_linha_lote-valor + lv_valor.
*                      <fs_msl>-lblab      = <fs_msl>-lblab - <fs_ret>-qcom.
                      <fs_msl>-lblab      = <fs_msl>-lblab - lv_total.

                      IF <fs_msl>-lblab = 0.
                        DELETE lt_msl INDEX lv_tabix.
*                    ELSE.
*                     modificar linha da tabela interna mslb.
                      ENDIF.

*                      IF lv_qtde = lv_total.
                      IF lv_qtde =  <fs_ret>-qcom.
                        CLEAR: lv_dif.
                        lv_dif = <fs_ret>-vprod - lv_valor.

                        IF lv_dif < 0.
                          ls_linha_lote-valor = ls_linha_lote-valor - lv_dif.
                          APPEND ls_linha_lote TO lt_linha_lote.
                          EXIT.
                        ELSE.
                          ls_linha_lote-valor = ls_linha_lote-valor + lv_dif.
                          APPEND ls_linha_lote TO lt_linha_lote.
                          EXIT.
                        ENDIF.

                      ENDIF.

                      APPEND ls_linha_lote TO lt_linha_lote.

                    ELSE.

                      ls_linha_lote-qtd   = <fs_msl>-lblab.
                      ls_linha_lote-lote  = <fs_msl>-charg.
*                      ls_linha_lote-valor = <fs_ret>-vprod / ls_linha_lote-qtd.
                      ls_linha_lote-valor = lv_valor_unit * ls_linha_lote-qtd.
                      lv_valor            = ls_linha_lote-valor + lv_valor.
                      lv_qtde             = ls_linha_lote-qtd + lv_qtde.

                      DELETE lt_msl INDEX lv_tabix.

                      IF lv_qtde =  <fs_ret>-qcom.

                        lv_dif = <fs_ret>-vprod - lv_valor.

                        IF lv_dif < 0.
                          ls_linha_lote-valor = ls_linha_lote-valor - lv_dif.
                          APPEND ls_linha_lote TO lt_linha_lote.
                          EXIT.
                        ELSE.
                          ls_linha_lote-valor = ls_linha_lote-valor + lv_dif.
                          APPEND ls_linha_lote TO lt_linha_lote.
                          EXIT.
                        ENDIF.

                      ENDIF.

                      APPEND ls_linha_lote TO lt_linha_lote.
                      CLEAR lv_tabix.
                    ENDIF.

                    lv_total = lv_total - lv_lblab.
                    CLEAR lv_lblab.
*                  ENDIF.
                  ENDLOOP.
                ENDIF.
              ENDLOOP.

              "Saldo insuficiente em depósito especial do fornecedor".
              IF lv_qtde < <fs_ret>-qcom.
                et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '007' ) ).
                RETURN.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDLOOP.

        IF lt_linha_lote[] IS NOT INITIAL.
          IF <fs_ret>-processo EQ 1. " Retorno

            me->retorno( EXPORTING is_linha_lote = ls_linha_lote
                                   it_linha_lote = lt_linha_lote
                         IMPORTING et_return = et_return ).

          ELSEIF <fs_ret>-processo EQ 2. " Beneficiamento
            me->beneficiamento( EXPORTING is_linha_lote = ls_linha_lote
                                          it_linha_lote = lt_linha_lote
                                IMPORTING et_return = et_return ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD valida_tabela.

    SELECT *
      FROM ztmm_ret_arm_gv
      INTO TABLE @DATA(lt_ret)
      WHERE usuario = @sy-uname.

    IF sy-subrc IS INITIAL.

      DATA(lt_ret_aux) = lt_ret[].
      SORT lt_ret_aux BY nfeid.
      DELETE ADJACENT DUPLICATES FROM lt_ret_aux COMPARING nfeid.
      DATA(lt_ret_aux2) = lt_ret[].
      SORT lt_ret_aux2 BY nfeid.
      DELETE ADJACENT DUPLICATES FROM lt_ret_aux2 COMPARING processo.

      IF lines( lt_ret_aux ) NE 1.
        "Para este Processo selecionar item de uma NF-e".
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '001' ) ).
      ELSEIF lines( lt_ret_aux2 ) NE 1.
        "NF-e não pode contemplar dois processos para entrada".
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '006' ) ).
      ELSE.

        IF it_concluir[] IS NOT INITIAL.

          SELECT *
            FROM ztmm_ret_arm_gv
            INTO TABLE @DATA(lt_ret2)
            FOR ALL ENTRIES IN @it_concluir
            WHERE lifnr = @it_concluir-lifnr AND
                  werks = @it_concluir-werks AND
                  cfop  = @it_concluir-cfop  AND
                  nnf   = @it_concluir-nnf   AND
                  nfeid = @it_concluir-nfeid AND
                  demi  = @it_concluir-demi  AND
                  nitem = @it_concluir-nitem.

          IF sy-subrc IS INITIAL.

            IF lines( lt_ret2 ) NE lines( it_concluir ).
              "Selecionar todos os itens para o Processo
            ELSE.

              SORT lt_ret2 BY nfeid.
              DELETE ADJACENT DUPLICATES FROM lt_ret2 COMPARING nfeid.

              IF lines( lt_ret2 ) NE 1.
                "Para este Processo selecionar item de uma NF-e".
                et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '001' ) ).
              ELSE.
                READ TABLE lt_ret_aux ASSIGNING FIELD-SYMBOL(<fs_ret>) INDEX 1.
                IF sy-subrc IS INITIAL.
                  READ TABLE lt_ret2 ASSIGNING FIELD-SYMBOL(<fs_ret2>) INDEX 1.
                  IF sy-subrc IS INITIAL.
                    IF <fs_ret>-nfeid NE <fs_ret2>-nfeid.
                      "Para este Processo selecionar item de uma NF-e".
                      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_GRAO_VERDE' number = '001' ) ).
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD beneficiamento.

    DATA: lt_gooditems_create  TYPE TABLE OF bapi2017_gm_item_create,
          lt_gooditems_create2 TYPE TABLE OF bapi2017_gm_item_create,
          lt_return            TYPE TABLE OF bapiret2,
          lt_nfe_item_erp      TYPE  j1b_nf_xml_item_tab.

    DATA: ls_nfe_header_erp TYPE  j1b_nf_xml_header,
          ls_step_result    TYPE /xnfe/step_result_s.

    DATA: lv_materialdocumento TYPE bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear   TYPE bapi2017_gm_head_ret-doc_year,
          lv_auth_date         TYPE j_1bauthdate,
          lv_auth_time         TYPE j_1bauthtime,
          lv_acckey            TYPE j_1b_nfe_access_key,
          lv_memory_id         TYPE indx_srtfd,
          lv_guid              TYPE /xnfe/guid_16.

    CONSTANTS: lc_1 TYPE bapi2017_gm_code VALUE '01'.

    SELECT guid_header,
           nfeid,
           nprot,
           xmlversion,
           dhrecbto
      FROM /xnfe/innfehd
      INTO TABLE @DATA(lt_hd)
     WHERE nnf   = @is_linha_lote-nnf
       AND nfeid = @is_linha_lote-xml
       AND demi  = @is_linha_lote-dataemissao
       AND serie = @is_linha_lote-serie.

    IF sy-subrc IS INITIAL.
      DATA(ls_hd) = lt_hd[ 1 ].
    ENDIF.

    DATA(ls_header) = VALUE bapi2017_gm_head_01( pstng_date = sy-datum
                                                 doc_date   = is_linha_lote-dataemissao
                                                 ref_doc_no = is_linha_lote-nnf && '-' && is_linha_lote-serie ).

    lt_gooditems_create = VALUE #( FOR ls_linha_lote IN it_linha_lote
                                 (  material    = ls_linha_lote-matnr_req
                                    plant       = ls_linha_lote-werks
                                    stge_loc    = ls_linha_lote-deposito
                                    batch       = ls_linha_lote-lote
                                    move_type   = gc_moviment_benef_1 " Z43
                                    spec_stock  = 'O'
                                    vendor      = ls_linha_lote-lifnr_req
                                    item_text   = ls_linha_lote-mat_xml
                                    entry_qnt   = ls_linha_lote-qtd
                                    entry_uom   = ls_linha_lote-um
                                    amount_lc   = is_linha_lote-valor ) ).
*                                    gl_account  = gc_account_benef_1 ) ).

    CALL FUNCTION 'ZFMMM_GOODSMVT_CREATE'
      STARTING NEW TASK 'MM_RET_ARMAZ_1'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_goodsmvt_header = ls_header
        is_goodsmvt_code   = lc_1
      TABLES
        goodsmvt_item      = lt_gooditems_create
        return             = gt_return.

    WAIT UNTIL gv_wait_async_1 = abap_true.
    FREE gv_wait_async_1.

    IF gs_materialdocumento IS NOT INITIAL.

      CLEAR: gt_return[], gs_materialdocumento.

      lt_gooditems_create2 = VALUE #( FOR ls_linha_lote IN it_linha_lote
                                  (  material         = ls_linha_lote-matnr
                                     plant            = ls_linha_lote-werks
                                     stge_loc         = ls_linha_lote-deposito
                                     move_type        = gc_moviment_benef_2 " X01
                                     vendor           = ls_linha_lote-lifnr
                                     item_text        = ls_linha_lote-mat_xml
                                     entry_qnt        = ls_linha_lote-qtd
                                     entry_uom        = ls_linha_lote-um
                                     amount_lc        = ls_linha_lote-valor
                                     ext_base_amount  = ls_linha_lote-valor
                                     tax_code         = gc_code_iva )  ).
*                                     gl_account       = '2112000001'  )  ).

      lv_guid = ls_hd-guid_header.
      lv_memory_id = |{ 'GV-' }{ is_linha_lote-nnf }|.
      EXPORT lv_guid FROM lv_guid TO DATABASE indx(zm) ID lv_memory_id.
      " Import na include ZMMI_ESCRT_NFE_GRAOVERDE

      CALL FUNCTION 'ZFMMM_GOODSMVT_CREATE'
        STARTING NEW TASK 'MM_RET_ARMAZ_2'
        CALLING setup_messages ON END OF TASK
        EXPORTING
          is_goodsmvt_header = ls_header
          is_goodsmvt_code   = lc_1
        TABLES
          goodsmvt_item      = lt_gooditems_create2
          return             = gt_return.

      WAIT UNTIL gv_wait_async_2 = abap_true.
      FREE gv_wait_async_2.

      IF gs_materialdocumento IS NOT INITIAL.

        DATA(lv_refkey) = gs_materialdocumento && gs_matdocumentyear.

        DO 10 TIMES.

          WAIT UP TO 1 SECONDS.

          SELECT docnum
            FROM j_1bnflin
            INTO TABLE @DATA(lt_lin)
           WHERE refkey = @lv_refkey.
          IF sy-subrc IS INITIAL.
            EXIT.
          ENDIF.

        ENDDO.

        IF lt_lin[] IS NOT INITIAL.

*          lv_auth_date = ls_hd-dhrecbto(8).
*          lv_auth_time = ls_hd-dhrecbto+8(6).
*          lv_acckey = ls_hd-nfeid.
*
*          CALL FUNCTION 'J_1BNFE_EXIST_CHECK_AND_UPDATE'
*            EXPORTING
*              i_acckey     = lv_acckey
*              i_authcode   = ls_hd-nprot
*              i_auth_date  = lv_auth_date
*              i_auth_time  = lv_auth_time
*              i_xmlgovvers = ls_hd-xmlversion
*            IMPORTING
*              e_xml_header = ls_nfe_header_erp
*              et_xml_item  = lt_nfe_item_erp
*            TABLES
*              et_bapiret2  = et_return.
*
*          DATA(lv_uname) = sy-uname.
*
*          ls_step_result-stepstatus  = '01'.
*          ls_step_result-msgid  =  '/XNFE/APPB2BSTEPS'.
*          ls_step_result-msgno = '001'.
*          ls_step_result-msgv1 =  lv_uname.
*
*          CALL FUNCTION '/XNFE/B2BNFE_SET_STEPRESULT'
*            EXPORTING
*              iv_guid_header = ls_hd-guid_header
*              iv_proc_step   = 'ACCPTNFE'
*              is_step_result = ls_step_result
*                               EXCEPTIONS
*                               nfe_does_not_exist
*                               nfe_locked
*                               procstep_not_allowed
*                               no_proc_allowed
*                               technical_error.
*          IF sy-subrc IS NOT INITIAL.
*            "error
*          ENDIF.
*
*          CALL FUNCTION '/XNFE/B2BNFE_SAVE_TO_DB'.
*
*          CALL FUNCTION '/XNFE/COMMIT_WORK'.
*          WAIT UP TO 1 SECONDS.
*          CALL FUNCTION '/XNFE/NFE_PROCFLOW_EXECUTION'
*            EXPORTING
*              iv_guid_header = ls_hd-guid_header
*                               EXCEPTIONS
*                               no_proc_allowed
*                               error_in_process
*                               technical_error
*                               error_reading_nfe
*                               no_logsys.
*
*          IF sy-subrc <> 0.
** Implement suitable error handling here
*          ENDIF.
*          EXIT.
*        ENDIF.

          CALL FUNCTION 'ZFMMM_NFEIN_ACCPTNFE'
          STARTING NEW TASK 'MM_RET_ARMAZ_3'
            EXPORTING
              is_dhrecbto          = ls_hd-dhrecbto
              is_nfeid             = ls_hd-nfeid
              is_nprot             = ls_hd-nprot
              is_xmlversion        = ls_hd-xmlversion
              is_guid_header       = ls_hd-guid_header.

          WAIT UNTIL gv_wait_async_3 = abap_true.
          FREE gv_wait_async_3.

        ENDIF.
      ENDIF.
    ENDIF.

    et_return[] = gt_return[].

  ENDMETHOD.


  METHOD retorno.

    DATA: lt_gooditems_create TYPE TABLE OF bapi2017_gm_item_create,
          lt_return           TYPE TABLE OF bapiret2,
          lt_nfe_item_erp     TYPE  j1b_nf_xml_item_tab.

    DATA: ls_nfe_header_erp TYPE  j1b_nf_xml_header,
          ls_step_result    TYPE /xnfe/step_result_s.

    DATA: lv_auth_date         TYPE  j_1bauthdate,
          lv_auth_time         TYPE  j_1bauthtime,
          lv_acckey            TYPE  j_1b_nfe_access_key,
          lv_materialdocumento TYPE bapi2017_gm_head_ret-mat_doc,
          lv_matdocumentyear   TYPE bapi2017_gm_head_ret-doc_year,
          lv_memory_id         TYPE indx_srtfd,
          lv_guid              TYPE /xnfe/guid_16,
          lt_hd                TYPE TABLE OF /xnfe/innfehd,
          ls_hd                TYPE /xnfe/innfehd.

    CONSTANTS: lc_4 TYPE bapi2017_gm_code VALUE '04'.

    SELECT dhrecbto
            nfeid
            nprot
            xmlversion
            guid_header
     FROM /xnfe/innfehd
     INTO CORRESPONDING FIELDS OF TABLE lt_hd
    WHERE nnf   = is_linha_lote-nnf
      AND nfeid = is_linha_lote-xml
      AND demi  = is_linha_lote-dataemissao
      AND serie = is_linha_lote-serie.

    IF sy-subrc IS INITIAL.

      ls_hd = CORRESPONDING #( lt_hd[ 1 ] ).

    ENDIF.

    DATA(ls_header) = VALUE bapi2017_gm_head_01( pstng_date = sy-datum
                                                 doc_date   = is_linha_lote-dataemissao
                                                 ref_doc_no = is_linha_lote-nnf && '-' && is_linha_lote-serie ).

    lt_gooditems_create = VALUE #( FOR ls_linha_lote IN it_linha_lote
                                 (  material        = ls_linha_lote-matnr
                                    plant           = ls_linha_lote-werks
                                    stge_loc        = ls_linha_lote-deposito
                                    vendor          = ls_linha_lote-lifnr
*                                    move_type       = '542'
                                    move_type       = gc_moviment_retorno " Y42
                                    item_text       = ls_linha_lote-mat_xml
                                    entry_qnt       = ls_linha_lote-qtd
                                    entry_uom       = ls_linha_lote-um
                                    batch           = ls_linha_lote-lote
                                    ext_base_amount = ls_linha_lote-valor
                                    tax_code        = gc_code_iva ) ).

*    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
*      EXPORTING
*        goodsmvt_header  = ls_header
*        goodsmvt_code    = lc_4
*      IMPORTING
*        materialdocument = lv_materialdocumento
*        matdocumentyear  = lv_matdocumentyear
*      TABLES
*        goodsmvt_item    = lt_gooditems_create
*        return           = et_return.
*
*    IF lv_materialdocumento IS NOT INITIAL.
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = abap_true.
*    ENDIF.
*
*    DATA(lv_refkey) = lv_materialdocumento && lv_matdocumentyear.
*
*    DO 10 TIMES.
*      SELECT docnum
*        FROM j_1bnflin
*        INTO TABLE @DATA(lt_lin)
*        WHERE refkey = @lv_refkey.
*      IF sy-subrc IS INITIAL.
*
*        lv_auth_date = ls_hd-dhrecbto(8).
*        lv_auth_time = ls_hd-dhrecbto+8(6).
*        lv_acckey = ls_hd-nfeid.
*
*        CALL FUNCTION 'J_1BNFE_EXIST_CHECK_AND_UPDATE'
*          EXPORTING
*            i_acckey     = lv_acckey
*            i_authcode   = ls_hd-nprot
*            i_auth_date  = lv_auth_date
*            i_auth_time  = lv_auth_time
*            i_xmlgovvers = ls_hd-xmlversion
*          IMPORTING
*            e_xml_header = ls_nfe_header_erp
*            et_xml_item  = lt_nfe_item_erp
*          TABLES
*            et_bapiret2  = et_return.
*
*        DATA(lv_uname) = sy-uname.
*
*        ls_step_result-stepstatus  = '01'.
*        ls_step_result-msgid  =  '/XNFE/APPB2BSTEPS'.
*        ls_step_result-msgno = '001'.
*        ls_step_result-msgv1 =  lv_uname.
*
*        CALL FUNCTION '/XNFE/B2BNFE_SET_STEPRESULT'
*          EXPORTING
*            iv_guid_header = ls_hd-guid_header
*            iv_proc_step   = 'ACCPTNFE'
*            is_step_result = ls_step_result
*                             EXCEPTIONS
*                             nfe_does_not_exist
*                             nfe_locked
*                             procstep_not_allowed
*                             no_proc_allowed
*                             technical_error.
*        IF sy-subrc IS NOT INITIAL.
*         "error
*        ENDIF.
*
*
*        CALL FUNCTION '/XNFE/B2BNFE_SAVE_TO_DB'.
*
*        CALL FUNCTION '/XNFE/COMMIT_WORK'.
*        WAIT UP TO 1 SECONDS.
*        CALL FUNCTION '/XNFE/NFE_PROCFLOW_EXECUTION'
*          EXPORTING
*            iv_guid_header = ls_hd-guid_header
*                             EXCEPTIONS
*                             no_proc_allowed
*                             error_in_process
*                             technical_error
*                             error_reading_nfe
*                             no_logsys.
*
*        IF sy-subrc <> 0.
** Implement suitable error handling here
*        ENDIF.
*
*        EXIT.
*      ENDIF.
*      WAIT UP TO 1 SECONDS.
*    ENDDO.

    lv_guid = ls_hd-guid_header.
    lv_memory_id = |{ 'GV-' }{ is_linha_lote-nnf }|.
    EXPORT lv_guid FROM lv_guid TO DATABASE indx(zm) ID lv_memory_id.
    " Import na include ZMMI_ESCRT_NFE_GRAOVERDE

    CALL FUNCTION 'ZFMMM_GOODSMVT_CREATE'
      STARTING NEW TASK 'MM_RET_ARMAZ_1'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_goodsmvt_header = ls_header
        is_goodsmvt_code   = lc_4
      TABLES
        goodsmvt_item      = lt_gooditems_create
        return             = gt_return.

    WAIT UNTIL gv_wait_async_1 = abap_true.
    FREE gv_wait_async_1.

    IF gs_materialdocumento IS NOT INITIAL.

      DATA(lv_refkey) = gs_materialdocumento && gs_matdocumentyear.

      DO 10 TIMES.
        WAIT UP TO 1 SECONDS.
        SELECT docnum
          FROM j_1bnflin
          INTO TABLE @DATA(lt_lin)
          WHERE refkey = @lv_refkey.
        IF sy-subrc IS INITIAL.
          EXIT.
        ENDIF.
      ENDDO.

      IF lt_lin[] IS NOT INITIAL.

        CALL FUNCTION 'ZFMMM_NFEIN_ACCPTNFE'
          STARTING NEW TASK 'MM_RET_ARMAZ_3'
          EXPORTING
            is_dhrecbto    = ls_hd-dhrecbto
            is_nfeid       = ls_hd-nfeid
            is_nprot       = ls_hd-nprot
            is_xmlversion  = ls_hd-xmlversion
            is_guid_header = ls_hd-guid_header.

        WAIT UNTIL gv_wait_async_3 = abap_true.
        FREE gv_wait_async_3.

      ENDIF.
    ENDIF.

    et_return[] = gt_return[].

  ENDMETHOD.


  METHOD setup_messages.
    CASE p_task.

      WHEN 'MM_RET_ARMAZ_1'.

        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_GN_DELIVERY_CREATE'
         IMPORTING
           es_materialdocument = gs_materialdocumento
           es_matdocumentyear  = gs_matdocumentyear
         TABLES
           return              = gt_return.

        gv_wait_async_1 = abap_true.


      WHEN 'MM_RET_ARMAZ_2'.

        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_GOODSMVT_CREATE'
         IMPORTING
           es_materialdocument = gs_materialdocumento
           es_matdocumentyear  = gs_matdocumentyear
         TABLES
           return              = gt_return.

        gv_wait_async_2 = abap_true.


      WHEN 'MM_RET_ARMAZ_3'.

        gv_wait_async_3 = abap_true.

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
