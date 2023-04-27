class ZCLMM_CHANGE_TAXL definition
  public
  final
  create public .

public section.

  types:
    TY_TXLAWS TYPE STANDARD TABLE OF j_1btxlaws .

  methods CHANGE_TAXL
    importing
      !IS_LAWS type J_1BTXLAWS
    exporting
      !ET_LAWS type TY_TXLAWS .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CHANGE_TAXL IMPLEMENTATION.


  METHOD change_taxl.

    CONSTANTS: lc_zdf   TYPE bsart VALUE 'ZDF',
               lc_bwart TYPE bwart VALUE '862'.

    FIELD-SYMBOLS <fs_mseg> TYPE mseg.
    ASSIGN ('(SAPLJ1BF)WA_XMSEG') TO <fs_mseg>.

    IF <fs_mseg> IS ASSIGNED.

      SELECT SINGLE vgbel, bwart, j_1btaxlw1, j_1btaxlw2, j_1btaxlw3, j_1btaxlw4, j_1btaxlw5
      INTO @DATA(ls_lips)
      FROM lips
      WHERE vbeln = @<fs_mseg>-vbeln_im
      AND posnr = @<fs_mseg>-vbelp_im.

      IF sy-subrc IS INITIAL.

        SELECT SINGLE bsart
        INTO @DATA(lv_bsart)
        FROM ekko
        WHERE ebeln = @ls_lips-vgbel.

        IF lv_bsart = lc_zdf AND
          is_laws IS NOT INITIAL AND
          ls_lips-bwart = lc_bwart.

          DATA(ls_laws) = is_laws.

          ls_laws-icmslaw = ls_lips-j_1btaxlw1.
          ls_laws-ipilaw  = ls_lips-j_1btaxlw2.
          ls_laws-coflaw  = ls_lips-j_1btaxlw4.
          ls_laws-pislaw  = ls_lips-j_1btaxlw5.

          APPEND ls_laws TO et_laws.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
