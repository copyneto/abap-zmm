***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Ajuste de item do Depósito Fechado                     *
*** AUTOR    : Alysson Anjos – Meta                                   *
*** FUNCIONAL: Marina Quintanilha – Meta                              *
*** DATA     :  27.03.2023                                            *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
***      |       |                                                    *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMMI_ITEM_DEP_FECHADO
*&---------------------------------------------------------------------*

DATA lt_nf_lin     TYPE j_1bnflin_tab.
DATA lt_nf_lin_aux TYPE j_1bnflin_tab.
DATA lr_purch_order TYPE RANGE OF ebeln.
DATA lr_xped        TYPE RANGE OF j_1b_purch_order_ext.
DATA lv_othbas     TYPE j_1bnetval.

FIELD-SYMBOLS: <fs_t_nf_lin> TYPE j_1bnflin_tab.
FIELD-SYMBOLS: <fs_t_nf_stx> TYPE j_1bnfstx_tab.

CONSTANTS: lc_zcom TYPE mara-mtart VALUE 'ZCOM'.

ASSIGN ('(SAPLJ1BF)WA_NF_LIN[]') TO <fs_t_nf_lin>.
ASSIGN ('(SAPLJ1BF)WA_NF_STX[]') TO <fs_t_nf_stx>.
IF sy-subrc IS INITIAL.

  lt_nf_lin = <fs_t_nf_lin>.

  SORT lt_nf_lin BY matnr
                    bwkey.
  DELETE ADJACENT DUPLICATES FROM lt_nf_lin COMPARING matnr
                                                      bwkey.

  IF lt_nf_lin[] IS NOT INITIAL.

    SELECT a~matnr,
           a~bwkey,
           a~verpr,
           b~mtart
      FROM mbew AS a
     INNER JOIN mara AS b
             ON a~matnr = b~matnr
       FOR ALL ENTRIES IN @lt_nf_lin
     WHERE a~matnr = @lt_nf_lin-matnr
       AND a~bwkey = @lt_nf_lin-bwkey
      INTO TABLE @DATA(lt_mbew).

    IF sy-subrc IS INITIAL.

      lt_nf_lin_aux = <fs_t_nf_lin>.
      DELETE lt_nf_lin_aux WHERE xped IS INITIAL.
      SORT lt_nf_lin_aux BY xped.
      DELETE ADJACENT DUPLICATES FROM lt_nf_lin_aux COMPARING xped.


      IF lt_nf_lin_aux[] IS NOT INITIAL.

        lr_purch_order = VALUE #( FOR wa_lin_aux IN lt_nf_lin_aux
                   option = 'EQ' sign = 'I'
                   ( low = wa_lin_aux-xped ) ).

        IF lr_purch_order[] IS NOT INITIAL.

          SELECT purchase_order
        FROM ztmm_his_dep_fec
        INTO TABLE @DATA(lt_dep_fec)
            WHERE purchase_order IN @lr_purch_order
            .
          IF sy-subrc IS NOT INITIAL.
            RETURN.
          ELSE.

            lr_xped = VALUE #( FOR wa_dep_fec IN lt_dep_fec
                              option = 'EQ' sign = 'I'
                            ( low = wa_dep_fec-purchase_order ) ).

          ENDIF.
        ENDIF.
      ENDIF.

      SORT lt_mbew BY matnr
                      bwkey.

      LOOP AT <fs_t_nf_lin> ASSIGNING FIELD-SYMBOL(<fs_nf_lin>).

        READ TABLE lt_mbew ASSIGNING FIELD-SYMBOL(<fs_mbew>)
                                         WITH KEY matnr = <fs_nf_lin>-matnr
                                                  bwkey = <fs_nf_lin>-bwkey
                                                  BINARY SEARCH.
        IF sy-subrc IS INITIAL
       AND <fs_mbew>-mtart EQ lc_zcom
       AND <fs_nf_lin>-xped IN lr_xped
       AND <fs_nf_lin>-xped IS NOT INITIAL.

          <fs_nf_lin>-netpr  = <fs_mbew>-verpr.
          <fs_nf_lin>-netwr  = <fs_mbew>-verpr * <fs_nf_lin>-menge.
          <fs_nf_lin>-nfpri  = <fs_mbew>-verpr.
          <fs_nf_lin>-nfnet  = <fs_mbew>-verpr * <fs_nf_lin>-menge.
          <fs_nf_lin>-netwrt = <fs_mbew>-verpr * <fs_nf_lin>-menge.
          <fs_nf_lin>-nfnett = <fs_mbew>-verpr * <fs_nf_lin>-menge.

          lv_othbas = <fs_mbew>-verpr * <fs_nf_lin>-menge.

          DATA(lv_valida) = abap_true.

        ENDIF.
      ENDLOOP.

      IF lv_valida IS NOT INITIAL.
        LOOP AT <fs_t_nf_stx> ASSIGNING FIELD-SYMBOL(<fs_nf_stx>).
          <fs_nf_stx>-othbas = lv_othbas.
          CLEAR <fs_nf_stx>-excbas.
        ENDLOOP.
        CLEAR lv_valida.
      ENDIF.

    ENDIF.
  ENDIF.
ENDIF.
