class ZCLMM_ADD_ZONA_FRANCA definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_ekpo_key,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
      END OF ty_ekpo_key .
  types:
    ty_t_ekpo_key TYPE SORTED TABLE OF ty_ekpo_key
                    WITH UNIQUE KEY table_line .
  types:
    BEGIN OF ty_lin_key,
        refkey TYPE j_1bnflin-refkey,
        refitm TYPE j_1bnflin-refitm,
      END OF ty_lin_key .
  types:
    ty_t_lin_key TYPE SORTED TABLE OF ty_lin_key
                    WITH UNIQUE KEY table_line .

  methods CALCULA_ZF_SAIDA
    importing
      !IS_HEADER type J_1BNFDOC
      !IT_NFLIN type J_1BNFLIN_TAB
      !IT_NFSTX type J_1BNFSTX_TAB .
  methods CALCULA_ZF_ENTRADA_TRANSF
    importing
      !IS_HEADER type J_1BNFDOC
      !IT_NFLIN type J_1BNFLIN_TAB
      !IT_MSEG type TY_T_MSEG .
  methods CALCULA_ZF_ENTRADA_COMPRAS
    importing
      !IT_NFTAX type ANY TABLE optional
    changing
      !CT_NFLIN type ANY TABLE
      !CT_NFTAX type ANY TABLE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_ADD_ZONA_FRANCA IMPLEMENTATION.


  METHOD calcula_zf_entrada_compras.
    CONSTANTS lc_icms_zona_franca TYPE char4 VALUE 'ICZF'.

    DATA(lt_nflin_old) = CORRESPONDING j_1bnflin_tab( ct_nflin ).
    DATA(lt_nflin) = CORRESPONDING j_1bnflin_tab( ct_nflin ).
    DATA(lt_nftax_old) = CORRESPONDING j_1bnfstx_tab( ct_nftax ).
    DATA(lt_nftax) = CORRESPONDING j_1bnfstx_tab( ct_nftax ).

    IF line_exists( lt_nflin[ reftyp = 'BI' ] ).
      RETURN.
    ENDIF.

    IF line_exists( lt_nftax[ taxtyp = 'ICZG' ] ).

      LOOP AT lt_nftax ASSIGNING FIELD-SYMBOL(<fs_nftax>).
        DATA(ls_nflin) = lt_nflin[ itmnum = <fs_nftax>-itmnum ].

        IF <fs_nftax>-excbas IS NOT INITIAL.
          <fs_nftax>-excbas = ls_nflin-netwr.
        ENDIF.

        IF <fs_nftax>-othbas IS NOT INITIAL.
          <fs_nftax>-othbas = ls_nflin-netwr.
        ENDIF.

        IF <fs_nftax>-base IS NOT INITIAL.
          <fs_nftax>-base = ls_nflin-netwr.
        ENDIF.

        IF <fs_nftax>-taxtyp = 'ICM1'.
          IF <fs_nftax>-excbas IS NOT INITIAL.
            <fs_nftax>-base = <fs_nftax>-excbas.
            CLEAR <fs_nftax>-excbas.
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDIF.

    IF lt_nftax <> lt_nftax_old.
      ct_nftax = lt_nftax.
    ENDIF.

    TRY.
        DATA(ls_icms_zona_franca) = lt_nftax[ taxtyp = lc_icms_zona_franca ].

        LOOP AT lt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).
          IF ls_icms_zona_franca-itmnum <> <fs_nflin>-itmnum.
            CHECK line_exists( lt_nftax[ taxtyp = lc_icms_zona_franca itmnum = <fs_nflin>-itmnum ] ).

            ls_icms_zona_franca = lt_nftax[ taxtyp = lc_icms_zona_franca itmnum = <fs_nflin>-itmnum ].
          ENDIF.

          IF <fs_nflin>-vicmsdeson IS INITIAL.
            CONTINUE.
          ENDIF.

          <fs_nflin>-netwr = ls_icms_zona_franca-othbas.
          <fs_nflin>-nfnet = ls_icms_zona_franca-othbas.
          <fs_nflin>-netpr = <fs_nflin>-netwr / <fs_nflin>-menge.
          <fs_nflin>-nfpri = <fs_nflin>-netpr.
        ENDLOOP.

        LOOP AT lt_nftax ASSIGNING <fs_nftax>.
          ls_nflin = lt_nflin[ itmnum = <fs_nftax>-itmnum ].

          IF <fs_nftax>-excbas IS NOT INITIAL.
            <fs_nftax>-excbas = ls_nflin-netwr.
          ENDIF.

          IF <fs_nftax>-othbas IS NOT INITIAL.
            <fs_nftax>-othbas = ls_nflin-netwr.
          ENDIF.

          IF <fs_nftax>-base IS NOT INITIAL.
            <fs_nftax>-base = ls_nflin-netwr.
          ENDIF.

          IF <fs_nftax>-taxtyp = 'ICM1'.
            IF <fs_nftax>-excbas IS NOT INITIAL.
              <fs_nftax>-base = <fs_nftax>-excbas.
              CLEAR <fs_nftax>-excbas.
            ENDIF.
          ENDIF.

        ENDLOOP.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    IF lt_nflin <> lt_nflin_old.
      ct_nflin = CORRESPONDING #( lt_nflin ).
    ENDIF.
  ENDMETHOD.


  METHOD CALCULA_ZF_ENTRADA_TRANSF.

    DATA: lt_item_zf   TYPE j_1bnflin_tab,
          lt_ekpo_key  TYPE ty_t_ekpo_key,
          lt_lin_key   TYPE ty_t_lin_key,

          ls_ekpo_key  TYPE ty_ekpo_key,
          ls_lin_key   TYPE ty_lin_key,

          lv_menge_old TYPE bstmg,
          lv_menge     TYPE bstmg.

    FIELD-SYMBOLS: <fs_t_lin_tab> TYPE j_1bnflin_tab.

* ---------------------------------------------------------------------
* Aplica validações
* ---------------------------------------------------------------------
    IF is_header-direct NE '1'. " Entrada
      RETURN.
    ENDIF.

    IF is_header-partyp NE 'B'. " Filial
      RETURN.
    ENDIF.

    IF line_exists( it_nflin[ reftyp = 'BI' ] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------
* Verifica se aplicaremos regra de substuição do NFPRI e NETWR
* ---------------------------------------------------------------------
    LOOP AT it_nflin ASSIGNING FIELD-SYMBOL(<fs_nlin>).

*      " Recupera item da fatura
*      READ TABLE it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) WITH KEY ebeln = <fs_nlin>-xped
*                                                                    ebelp = <fs_nlin>-nitemped.
*      CHECK sy-subrc EQ 0.
*      CHECK <fs_nlin>-itmtyp = '02'.    " Filial
*      CHECK <fs_mseg>-bwart  = '861'.
*      CHECK <fs_nlin>-cfop EQ '215101'
*         OR <fs_nlin>-cfop EQ '215201'.
*
      APPEND <fs_nlin> TO lt_item_zf.

      ls_ekpo_key = VALUE #( ebeln = <fs_nlin>-xped
                             ebelp = <fs_nlin>-nitemped ).
      INSERT ls_ekpo_key INTO TABLE lt_ekpo_key.
    ENDLOOP.

    IF lt_item_zf[] IS INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------
* Recupera nota de origem (NF Saída)
* ---------------------------------------------------------------------
    IF lt_ekpo_key IS NOT INITIAL.

      SELECT mseg~ebeln,
             mseg~ebelp,
             mseg~mblnr,
             mseg~mjahr,
             mseg~zeile,
             mseg~bwart
       FROM mseg
       FOR ALL ENTRIES IN @lt_ekpo_key
       WHERE mseg~ebeln EQ @lt_ekpo_key-ebeln
         AND mseg~ebelp EQ @lt_ekpo_key-ebelp
        INTO TABLE @DATA(lt_mseg).

      IF sy-subrc EQ 0.
        SORT lt_mseg BY ebeln ebelp.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.

    LOOP AT lt_mseg REFERENCE INTO DATA(ls_mseg).
      ls_lin_key-refkey = |{ ls_mseg->mblnr }{ ls_mseg->mjahr }|.
      ls_lin_key-refitm = ls_mseg->zeile.
      INSERT ls_lin_key INTO TABLE lt_lin_key[].
    ENDLOOP.

    IF lt_lin_key IS NOT INITIAL.

      SELECT lin~refkey,
             lin~refitm,
             doc~docnum,
             lin~itmnum,
             lin~xped,
             lin~nitemped,
             lin~netwr,
             lin~nfpri,
             lin~meins,
             doc~regio,
             lin~mwskz
        FROM j_1bnflin AS lin
        INNER JOIN j_1bnfdoc AS doc
          ON doc~docnum = lin~docnum
       FOR ALL ENTRIES IN @lt_lin_key
       WHERE lin~refkey EQ @lt_lin_key-refkey
         AND lin~refitm EQ @lt_lin_key-refitm
         AND doc~direct EQ '2' " Saída
         AND doc~cancel IS INITIAL
        INTO TABLE @DATA(lt_lin).

      IF sy-subrc EQ 0.
        SORT lt_lin BY refkey refitm.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------
* Atualiza campos do Item da Nota Fiscal com os dados da NF origem
* ---------------------------------------------------------------------
    ASSIGN ('(SAPLJ1BF)WA_NF_LIN[]') TO <fs_t_lin_tab>.

    IF <fs_t_lin_tab> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    LOOP AT <fs_t_lin_tab> ASSIGNING FIELD-SYMBOL(<fs_s_lin_tab>).

      " Recupera os itens validados anteriormente
      READ TABLE lt_item_zf TRANSPORTING NO FIELDS WITH KEY docnum = <fs_s_lin_tab>-docnum
                                                            itmnum = <fs_s_lin_tab>-itmnum
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      ls_ekpo_key = VALUE #( ebeln = <fs_s_lin_tab>-xped
                             ebelp = <fs_s_lin_tab>-nitemped ).

      " Recupera documento de material
      LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_s_mseg>) WHERE ebeln = ls_ekpo_key-ebeln
                                                            AND ebelp = ls_ekpo_key-ebelp.

        ls_lin_key = VALUE #( refkey = |{ <fs_s_mseg>-mblnr }{ <fs_s_mseg>-mjahr }|
                              refitm = <fs_s_mseg>-zeile ).

        " Recupera NF Saída
        READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) WITH KEY refkey = ls_lin_key-refkey
                                                                    refitm = ls_lin_key-refitm
                                                                    BINARY SEARCH.
        IF sy-subrc EQ 0.

          CHECK <fs_lin>-regio  = 'AM'.    " UF Zona Franca
          CHECK <fs_lin>-mwskz  = 'TZ'     " IVA Zona Franca
             OR <fs_lin>-mwskz  = 'TY'.

          <fs_s_lin_tab>-nfpri = <fs_lin>-nfpri.
          <fs_s_lin_tab>-netwr = <fs_lin>-netwr.
          EXIT.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD calcula_zf_saida.

    DATA: lt_item_zf   TYPE j_1bnflin_tab,
          lv_menge_old TYPE bstmg,
          lv_menge     TYPE bstmg,
          lv_nftot     TYPE j_1bnftot.

    FIELD-SYMBOLS: <fs_t_lin_tab> TYPE j_1bnflin_tab,
                   <fs_1bnfdoc>   TYPE j_1bnfdoc.

* ---------------------------------------------------------------------
* Aplica validações
* ---------------------------------------------------------------------
    IF is_header-direct NE '2'. " Saída
      RETURN.
    ENDIF.

    IF is_header-partyp NE 'B'. " Filial
      RETURN.
    ENDIF.

    IF is_header-regio NE 'AM'. " UF Zona Franca
      RETURN.
    ENDIF.

    IF line_exists( it_nflin[ reftyp = 'BI' ] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------
* Verifica se aplicaremos regra de substuição do NFPRI e NETWR
* ---------------------------------------------------------------------
    LOOP AT it_nflin ASSIGNING FIELD-SYMBOL(<fs_nlin>).
      CHECK <fs_nlin>-itmtyp = '02'.    " Filial
      CHECK <fs_nlin>-mwskz  = 'TZ'     " IVA Zona Franca
         OR <fs_nlin>-mwskz  = 'TY'.
      APPEND <fs_nlin> TO lt_item_zf.
    ENDLOOP.

    IF lt_item_zf[] IS INITIAL.
      RETURN.
    ENDIF.

    SORT lt_item_zf BY docnum itmnum.

    SELECT matnr,
           bwkey,
           bwtar,
           lppid,
           lppnet,
           lppbrt,
           docref
      FROM j_1blpp
       FOR ALL ENTRIES IN @lt_item_zf
     WHERE matnr = @lt_item_zf-matnr
       AND bwkey = @lt_item_zf-bwkey
       AND bwtar = @lt_item_zf-bwtar
      INTO TABLE @DATA(lt_lpp).

    IF sy-subrc IS INITIAL.

      SORT lt_lpp BY matnr
                     bwkey
                     bwtar.

      DATA(lt_lpp_aux) = lt_lpp[].

      SORT lt_lpp_aux BY docref
                         matnr
                         bwtar.

      DELETE ADJACENT DUPLICATES FROM lt_lpp_aux COMPARING docref
                                                           matnr
                                                           bwtar.

      SELECT docnum,
             itmnum,
             matnr,
             bwtar,
             nfpri,
             menge,
             meins
        FROM j_1bnflin
         FOR ALL ENTRIES IN @lt_lpp_aux
       WHERE docnum = @lt_lpp_aux-docref
         AND matnr  = @lt_lpp_aux-matnr
         AND bwtar  = @lt_lpp_aux-bwtar
        INTO TABLE @DATA(lt_lin).

      IF sy-subrc IS INITIAL.
        SORT lt_lin BY docnum
                       matnr
                       bwtar.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------
* Atualiza campos do Item da Nota Fiscal
* ---------------------------------------------------------------------
    ASSIGN ('(SAPLJ1BF)WA_NF_LIN[]') TO <fs_t_lin_tab>.

    IF <fs_t_lin_tab> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    LOOP AT <fs_t_lin_tab> ASSIGNING FIELD-SYMBOL(<fs_s_lin_tab>).

      " Recupera os itens validados anteriormente
      READ TABLE lt_item_zf TRANSPORTING NO FIELDS WITH KEY docnum = <fs_s_lin_tab>-docnum
                                                            itmnum = <fs_s_lin_tab>-itmnum
                                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Recupera dados LPP
      READ TABLE lt_lpp ASSIGNING FIELD-SYMBOL(<fs_lpp>) WITH KEY matnr = <fs_s_lin_tab>-matnr
                                                                  bwkey = <fs_s_lin_tab>-bwkey
                                                                  bwtar = <fs_s_lin_tab>-bwtar
                                                                  BINARY SEARCH.
      IF sy-subrc NE 0.

        " Para cenários não LPP, buscar o valor da condição específico de Zona Franca (cenário com desonerado)
        READ TABLE it_nfstx ASSIGNING FIELD-SYMBOL(<fs_nfstx>) WITH KEY docnum = <fs_s_lin_tab>-docnum
                                                                        itmnum = <fs_s_lin_tab>-itmnum
                                                                        taxtyp = 'ICZF'.

        IF sy-subrc EQ 0.
          IF <fs_nfstx>-othbas IS NOT INITIAL.
            <fs_s_lin_tab>-netwr = <fs_nfstx>-othbas.
            <fs_s_lin_tab>-nfpri = <fs_nfstx>-othbas / <fs_s_lin_tab>-menge.
          ELSE.
            <fs_s_lin_tab>-netwr = <fs_nfstx>-excbas.
            <fs_s_lin_tab>-nfpri = <fs_nfstx>-excbas / <fs_s_lin_tab>-menge.
          ENDIF.
        ENDIF.

        lv_nftot = lv_nftot + <fs_s_lin_tab>-netwr.

        CONTINUE.
      ENDIF.

      " Recupera item referente ao LPP
      READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>)
                                      WITH KEY docnum = <fs_lpp>-docref
                                               matnr  = <fs_lpp>-matnr
                                               bwtar  = <fs_lpp>-bwtar
                                               BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Aplica conversão na unidade de medida
      IF <fs_s_lin_tab>-meins NE <fs_lin>-meins.

        lv_menge_old = 1.

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = <fs_lin>-matnr
            i_in_me              = <fs_lin>-meins
            i_out_me             = <fs_s_lin_tab>-meins
            i_menge              = lv_menge_old
          IMPORTING
            e_menge              = lv_menge
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

        IF sy-subrc <> 0.
          lv_menge = 1.
        ENDIF.
      ELSE.
        lv_menge = 1.
      ENDIF.

      <fs_s_lin_tab>-nfpri = ( <fs_lin>-nfpri / lv_menge ).
      <fs_s_lin_tab>-netwr = ( <fs_s_lin_tab>-menge * <fs_lin>-nfpri ) / lv_menge.

      lv_nftot = lv_nftot + <fs_s_lin_tab>-netwr.

    ENDLOOP.

    IF lv_nftot IS NOT INITIAL.
      ASSIGN ('(SAPLJ1BF)WA_NF_DOC') TO <fs_1bnfdoc>.
      <fs_1bnfdoc>-nftot = lv_nftot.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
