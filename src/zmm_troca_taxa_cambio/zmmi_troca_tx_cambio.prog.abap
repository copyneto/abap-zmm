***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Alteração na taxa de cambio                            *
*** AUTOR:     Marcos Rubik    - META                                 *
*** FUNCIONAL: Alcides Silva   - META                                 *
*** DATA :     17.01.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
***            |                    |                                 *
***********************************************************************
*&--------------------------------------------------------------------*
*& ZMMI_TROCA_TX_CAMBIO
*&--------------------------------------------------------------------*
CONSTANTS: lc_modulo_tx TYPE ztca_param_mod-modulo VALUE 'MM',
           lc_chave1_tx TYPE ztca_param_par-chave1 VALUE 'MRM_HEADER_CHECK',
           lc_chave2_tx TYPE ztca_param_par-chave2 VALUE 'MIRO',
           lc_i_blart   TYPE ztca_param_par-chave3 VALUE 'I_BLART',
           lc_nftype    TYPE ztca_param_par-chave3 VALUE 'BNFTYPE'.

DATA: lr_blart     TYPE RANGE OF rbkp_v-blart,
      lr_nftype_tx TYPE RANGE OF rbkp_v-j_1bnftype,
      ls_rbkpv     TYPE mrm_rbkpv,
      lv_ukurs     TYPE tcurr-ukurs,
      lv_wrbtr     TYPE drseg-wrbtr,
      lt_ydrseg    TYPE TABLE OF mmcr_drseg.

FIELD-SYMBOLS: <fs_rbkpv>  TYPE any,
               <fs_tdrseg> TYPE ANY TABLE.

DATA(lo_parametros_tx) = NEW zclca_tabela_parametros( ).

TRY.
    lo_parametros_tx->m_get_range(
      EXPORTING
        iv_modulo = lc_modulo_tx
        iv_chave1 = lc_chave1_tx
        iv_chave2 = lc_chave2_tx
        iv_chave3 = lc_i_blart
      IMPORTING
        et_range  = lr_blart ).
  CATCH zcxca_tabela_parametros.
ENDTRY.

TRY.
    lo_parametros_tx->m_get_range(
      EXPORTING
        iv_modulo = lc_modulo_tx
        iv_chave1 = lc_chave1_tx
        iv_chave2 = lc_chave2_tx
        iv_chave3 = lc_nftype
      IMPORTING
        et_range  = lr_nftype_tx ).
  CATCH zcxca_tabela_parametros.
ENDTRY.

ASSIGN ('(SAPLMR1M)YDRSEG[]') TO <fs_tdrseg>.
IF <fs_tdrseg> IS ASSIGNED.
  lt_ydrseg[] = <fs_tdrseg>.
ENDIF.

IF  lt_ydrseg[] IS NOT INITIAL
AND lr_blart[]  IS NOT INITIAL
AND i_rbkpv-blart  NOT IN lr_blart
AND i_rbkpv-j_1bnftype IN lr_nftype_tx.

  SELECT ebeln,
         knumv,
         bedat,
         waers
    FROM ekko
    INTO TABLE @DATA(lt_ekko)
    FOR ALL ENTRIES IN @lt_ydrseg
    WHERE ebeln EQ @lt_ydrseg-ebeln.
  IF sy-subrc EQ 0.
    SORT lt_ekko BY ebeln.
*    SELECT knumv,
*           kposn,
*           stunr,
*           zaehk,
*           kschl,
*           waers,
*           kpein,
*           kkurs
*      FROM konv
*      INTO TABLE @DATA(lt_konv)
*     FOR ALL ENTRIES IN @lt_ekko
*     WHERE knumv = @lt_ekko-knumv
*       AND kschl IN @lr_kschl.
*    IF sy-subrc EQ 0.
*      SORT lt_konv BY knumv kposn.
*    ENDIF.
  ENDIF.

  LOOP AT lt_ydrseg ASSIGNING FIELD-SYMBOL(<fs_ydrseg_key>)
    GROUP BY ( ebeln = <fs_ydrseg_key>-ebeln )
    ASSIGNING FIELD-SYMBOL(<fs_ydrseg_group>).

    READ TABLE lt_ekko INTO DATA(ls_ekko)
      WITH KEY ebeln = <fs_ydrseg_group>-ebeln BINARY SEARCH.
    CHECK sy-subrc EQ 0.

    DATA(lt_komv) = get_komv( ls_ekko-knumv ).

    LOOP AT GROUP <fs_ydrseg_group> ASSIGNING FIELD-SYMBOL(<fs_ydrseg>).

      READ TABLE lt_komv INTO DATA(ls_komv)
        WITH KEY knumv = ls_ekko-knumv
                 kposn = <fs_ydrseg>-ebelp BINARY SEARCH.
      CHECK sy-subrc EQ 0.

      IF  ls_ekko-waers EQ 'BRL'
      AND ls_komv-waers NE 'BRL'.

        DATA(lv_dia_anterior) = CONV datum( i_rbkpv-bldat - 1 ).

        CALL FUNCTION 'READ_EXCHANGE_RATE'
          EXPORTING
            date             = lv_dia_anterior
            foreign_currency = ls_komv-waers
            local_currency   = ls_ekko-waers
          IMPORTING
            exchange_rate    = lv_ukurs
          EXCEPTIONS
            no_rate_found    = 1
            no_factors_found = 2
            no_spread_found  = 3
            derived_2_times  = 4
            overflow         = 5
            zero_rate        = 6
            OTHERS           = 7.

        IF sy-subrc EQ 0.
          lv_wrbtr = ( ( ( <fs_ydrseg>-netpr / ls_komv-kpein ) / ls_komv-kkurs  ) * lv_ukurs ) * <fs_ydrseg>-menge.
*          lv_wrbtr = ( ( <fs_ydrseg>-netpr / ls_komv-kpein ) / lv_ukurs ) * <fs_ydrseg>-menge.
          <fs_ydrseg>-wrbtr = lv_wrbtr.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDLOOP.

  <fs_tdrseg> = lt_ydrseg[].


  IF  lt_ydrseg[]    IS NOT INITIAL
  AND lr_nftype_tx[] IS NOT INITIAL.

    SELECT  mblnr,
            mjahr,
            budat
      FROM mkpf
      INTO TABLE @DATA(lt_mkpf)
     FOR ALL ENTRIES IN @lt_ydrseg
     WHERE mblnr = @lt_ydrseg-lfbnr
       AND mjahr = @lt_ydrseg-lfgja.
    IF sy-subrc EQ 0.
      SORT lt_mkpf BY mblnr mjahr.
    ENDIF.

    LOOP AT lt_ydrseg ASSIGNING <fs_ydrseg>.
      READ TABLE lt_mkpf
            INTO DATA(ls_mkpf)
        WITH KEY mblnr = <fs_ydrseg>-lfbnr
                 mjahr = <fs_ydrseg>-lfgja
        BINARY SEARCH.
      IF sy-subrc EQ 0.
        <fs_ydrseg>-budat = ls_mkpf-budat.
      ENDIF.
    ENDLOOP.

    <fs_tdrseg> = lt_ydrseg[].

    PERFORM nettosumme_bilden IN PROGRAM saplmr1m
                              USING space.
  ENDIF.

ENDIF.
