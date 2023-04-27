*&---------------------------------------------------------------------*
*& Include ZMMI_ICMS_PAUTA_GRAO_VERDE
*&---------------------------------------------------------------------*

  CONSTANTS: lc_bx10  TYPE komv_index-kschl VALUE 'BX10',
             lc_bx13  TYPE komv_index-kschl VALUE 'BX13',
             lc_bic0  TYPE komv_index-kschl VALUE 'BIC0',
             lc_znlc  TYPE likp-lfart       VALUE 'ZNLC',
             lc_abrvw TYPE lips-abrvw       VALUE '2',
             lc_spart TYPE mara-spart       VALUE '05',
             lc_kschl TYPE a603-kschl       VALUE 'ZVPC'.

  TYPES:
    BEGIN OF ty_rem,
      matnr  TYPE mara-matnr,
      meins  TYPE lips-meins,
      kcmeng TYPE ekpo-menge,
    END OF ty_rem,

    BEGIN OF ty_a603,
      knumh TYPE konp-knumh,
      kmein TYPE konp-kmein,
      kbetr TYPE konp-kbetr,
    END OF ty_a603.

  DATA: lv_menge TYPE bstmg,
        lv_posnr TYPE lips-posnr,
        ls_rem TYPE ty_rem,
        ls_a603 TYPE ty_a603,
        ls_bx10 TYPE komv_index,
        ls_bic0 TYPE komv_index.


  IF xkomv-kschl = lc_bx10 OR xkomv-kschl = lc_bx13.

    CLEAR: lv_posnr.
    lv_posnr = komp-evrtp.

    SELECT SINGLE _mara~matnr _lips~meins _lips~kcmeng
    FROM ekbe AS _ekbe
    JOIN likp AS _likp ON _ekbe~belnr = _likp~vbeln
    JOIN lips AS _lips ON _likp~vbeln = _lips~vbeln AND _lips~posnr = lv_posnr
    JOIN mara AS _mara ON _lips~matnr = _mara~matnr
    INTO ls_rem
    WHERE _ekbe~ebeln = komp-evrtn
    AND _ekbe~ebelp = komp-evrtp
    AND _likp~lfart = lc_znlc
    AND _lips~abrvw = lc_abrvw
    AND _mara~spart  = lc_spart.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE _konp~knumh _konp~kmein _konp~kbetr
      FROM a603 AS _a603
      JOIN konp AS _konp ON _a603~knumh = _konp~knumh
      INTO ls_a603
      WHERE _a603~matnr = ls_rem-matnr
      AND _a603~kschl = lc_kschl
      AND ( _a603~datab <= sy-datum AND _a603~datbi >= sy-datum )
      AND _a603~vkaus = lc_abrvw.

      IF sy-subrc IS INITIAL AND
        xkomv-kschl = lc_bx10 AND
        ls_rem IS NOT INITIAL AND
        ls_a603-kmein NE ls_rem-meins.

        CLEAR: lv_menge.

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = ls_rem-matnr
            i_in_me              = ls_rem-meins
            i_out_me             = ls_a603-kmein
            i_menge              = ls_rem-kcmeng
          IMPORTING
            e_menge              = lv_menge
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

        xkwert = ( ( ls_a603-kbetr * lv_menge ) / 1000 ).
        xkomv-kwert = xkwert.

      ELSEIF sy-subrc IS INITIAL AND
        xkomv-kschl = lc_bx13 AND
        ls_rem IS NOT INITIAL.

        READ TABLE xkomv INTO ls_bx10 WITH KEY kposn = komp-kposn
                                                kschl = lc_bx10.

        READ TABLE xkomv INTO ls_bic0 WITH KEY kposn = komp-kposn
                                                kschl = lc_bic0.

        xkwert = ( ls_bx10-kwert * ls_bic0-kwert ) / 1000.
        xkomv-kwert = xkwert.

      ENDIF.

    ENDIF.

  ENDIF.
