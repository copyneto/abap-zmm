*&---------------------------------------------------------------------*
*& Include          ZMMI_ENVIO_E1MARA1
*&---------------------------------------------------------------------*
CONSTANTS: lc_segnam_mara_new TYPE edilsegtyp   VALUE 'ZSMM_E1MARA1',
           lc_segment_name    TYPE edidd-segnam VALUE 'E1MARA1'.

DATA: lv_prdha TYPE char18.

IF segment_name = lc_segment_name.

  SELECT SINGLE a~prdha,
                b~vtext
    FROM mara AS a
    INNER JOIN  t179t AS b
    ON a~prdha = b~prodh
    INTO @DATA(ls_mara)
    WHERE a~matnr_external EQ @f_mara-matnr_external
      AND b~spras EQ @sy-langu.


  IF sy-subrc IS INITIAL.

    APPEND INITIAL LINE TO idoc_data ASSIGNING FIELD-SYMBOL(<fs_idoc_data>).
    <fs_idoc_data>-segnam = lc_segnam_mara_new.
*    <fs_idoc_data>-sdata = ls_mara-prdha && ls_mara-vtext.
    CONCATENATE ls_mara-prdha ls_mara-vtext INTO <fs_idoc_data>-sdata RESPECTING BLANKS.

  ENDIF.

ENDIF.
