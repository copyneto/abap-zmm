*&---------------------------------------------------------------------*
*& Include          ZMMI_EXPED_INSUMOS
*&---------------------------------------------------------------------*
*
FIELD-SYMBOLS:
<fs_armaz_key> type zsmm_armaz_key.

ASSIGN ('(SAPLZFGMM_PICKING)GS_ARMAZ_KEY') to <fs_armaz_key>.

IF <fs_armaz_key> is ASSIGNED.

*  SELECT SINGLE nfnett FROM j_1bnflin
*    WHERE docnum EQ @<fs_armaz_key>-docnum
*      AND itmnum EQ @<fs_armaz_key>-itmnum
*    INTO @DATA(lv_nfnett).
*
*  IF sy-subrc EQ 0.
*    mseg-dmbtr = lv_nfnett.
*  ENDIF.

ENDIF.
