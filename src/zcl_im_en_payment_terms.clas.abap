class ZCL_IM_EN_PAYMENT_TERMS definition
  public
  final
  create public .

public section.

  interfaces IF_EX_MRM_PAYMENT_TERMS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_EN_PAYMENT_TERMS IMPLEMENTATION.


  METHOD if_ex_mrm_payment_terms~payment_terms_set.

    DATA: lv_exist      TYPE c,
          lv_lifn2_ekpa TYPE ekpa-lifn2,
          lv_ekorg      TYPE ekko-ekorg,
          lv_lifre      TYPE ekko-lifre,
          lv_ztag1      TYPE t052-ztag1.

    CONSTANTS lc_rs TYPE c LENGTH 2 VALUE 'RS'.
*------- save input data ------------------------------------------*
    MOVE: i_rbkpv-zfbdt TO e_zfbdt,
          i_rbkpv-zbd1t TO e_zbd1t,
          i_rbkpv-zbd1p TO e_zbd1p,
          i_rbkpv-zbd2t TO e_zbd2t,
          i_rbkpv-zbd2p TO e_zbd2p,
          i_rbkpv-zbd3t TO e_zbd3t,
          i_rbkpv-zlspr TO e_zlspr.

    " Fazer a verificação baseado na operação 1 (Fatura) ou 3 (Débito posterior) que está no form VORGANG do programa LMR1MF5G
    IF ( i_rbkpv-xrech      = 'X' AND
         i_rbkpv-tbtkz      = space AND
         i_rbkpv-xrechl     = 'S' AND
         i_rbkpv-xrechr     = 'H' )
       OR
       ( i_rbkpv-xrech      = 'X' AND
         i_rbkpv-tbtkz      = 'X' AND
         i_rbkpv-xrechl     = 'S' AND
         i_rbkpv-xrechr     = 'H' ).

      DATA: lv_zterm_for TYPE dzterm,
            lv_lifnr     TYPE lifnr,
            lv_zterm_ord TYPE dzterm,
            ls_drseg_ord LIKE LINE OF ti_drseg.

      CONSTANTS: lc_zterm(21) TYPE c VALUE '(SAPLMRMC)RBKPV-ZTERM'.
      FIELD-SYMBOLS: <fs_zterm>   TYPE any,
                     <fs_vorgang> TYPE any,
                     <fs_ztagg>   TYPE any,
                     <fs_lifre>   TYPE any.

      READ TABLE ti_drseg INDEX 1 INTO ls_drseg_ord.

      CLEAR:lv_exist,lv_lifn2_ekpa,lv_ekorg.

      SELECT SINGLE lifnr zterm ekorg  INTO ( lv_lifnr, lv_zterm_ord, lv_ekorg ) FROM ekko WHERE ebeln = ls_drseg_ord-ebeln.

      IF sy-subrc IS INITIAL.
        CLEAR lv_exist.
        SELECT SINGLE  lifn2 INTO (lv_lifn2_ekpa) FROM ekpa WHERE ebeln = ls_drseg_ord-ebeln AND ekorg =  lv_ekorg AND parvw = lc_rs.
        IF sy-subrc IS INITIAL.
          lv_exist = abap_true.
        ELSE.
          CLEAR sy-subrc.
        ENDIF.
      ENDIF.

      IF sy-subrc = 0.

        IF i_rbkpv-lifnr <> lv_lifnr.

          SELECT SINGLE zterm INTO lv_zterm_for FROM lfb1 WHERE lifnr = i_rbkpv-lifnr AND bukrs = i_rbkpv-bukrs.

          IF sy-subrc = 0.

            ASSIGN (lc_zterm) TO <fs_zterm>.              "#EC CI_SUBRC.

            IF <fs_zterm> IS ASSIGNED.

              IF lv_exist EQ abap_true AND lv_lifn2_ekpa <> lv_lifnr.
                <fs_zterm> = lv_zterm_ord.
              ELSE.
                <fs_zterm> = lv_zterm_for.
              ENDIF.

              cl_mrm_communication=>mv_zterm_badi_upd = 'X'.

            ENDIF.

          ENDIF.

        ELSE.

          " Vai ocorreer apenas quando for o mesmo fornecedor do pedido, mas já houve modificação
          ASSIGN (lc_zterm) TO <fs_zterm>.                "#EC CI_SUBRC.
          IF <fs_zterm> IS ASSIGNED.
            <fs_zterm> = lv_zterm_ord.
          ENDIF.

        ENDIF.

        " Se houve mudança de Condição de Pagamento (ZTERM) atualizar prazos
        IF <fs_zterm> IS ASSIGNED.
          DATA: ls_sklin TYPE sklin.
          CALL FUNCTION 'FI_CHANGE_PAYMENT_CONDITIONS'
            EXPORTING
              i_bldat             = i_rbkpv-bldat
              i_newzterm          = <fs_zterm>
              i_newzfbdt          = i_rbkpv-zfbdt
              i_newsklin          = ls_sklin
              i_oldzterm          = space
              i_oldzfbdt          = i_rbkpv-zfbdt
              i_oldsklin          = ls_sklin
            IMPORTING
              e_sklin             = ls_sklin
              e_zfbdt             = e_zfbdt
            EXCEPTIONS
              terms_incorrect     = 1
              terms_not_found     = 2
              wrong_zfbdt         = 3
              day_limit_not_found = 4
              OTHERS              = 5.
          IF sy-subrc = 0.
            " Atribuição equivalente a existente no standard: form PAYMENT_COND_SET ( programa LFDCBFP0 )
            e_zbd1t = ls_sklin-ztag1.
            e_zbd2t = ls_sklin-ztag2.
            e_zbd3t = ls_sklin-ztag3.
            e_zbd1p = ls_sklin-zprz1.
            e_zbd2p = ls_sklin-zprz2.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

    ASSIGN ('(SAPLMR1M)RM08M-VORGANG') TO <fs_vorgang>.

    IF  <fs_vorgang> IS ASSIGNED AND  <fs_vorgang> = '3'.

      READ TABLE ti_drseg INDEX 1 INTO ls_drseg_ord.

      ASSIGN ('(SAPLFDCB)INVFO-LIFRE') TO <fs_lifre>.

      IF <fs_lifre> IS ASSIGNED.

        ASSIGN ('(SAPLMRMC)RBKPV-ZTERM') TO <fs_zterm>.

        IF <fs_zterm> IS ASSIGNED.
          SELECT SINGLE zterm
               FROM vf_kred
               INTO <fs_zterm>
               WHERE lifnr = <fs_lifre>.

          SELECT SINGLE  ztag1
             FROM t052
             INTO lv_ztag1
             WHERE zterm = <fs_zterm>.

          e_zbd1t = lv_ztag1.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
