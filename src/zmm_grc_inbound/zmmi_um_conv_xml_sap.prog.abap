*&---------------------------------------------------------------------*
*& Include zmmi_um_conv_xml_sap
*&---------------------------------------------------------------------*

DATA: lv_lifnr           TYPE ekko-lifnr,
      lv_matnr           TYPE ekpo-matnr,
      lv_meins           TYPE ztmm_fiscal_inb-um_out,
      lv_bprme           TYPE ekpo-bprme,
      lt_ztmm_fiscal_inb TYPE TABLE OF ztmm_fiscal_inb,
      lt_marm            TYPE TABLE OF marm.

DATA(lv_mseh3) = i_mseh3.

TRANSLATE lv_mseh3 TO UPPER CASE.

" Seleciona o fornecedor do pedido de compra
IF i_lifnr IS INITIAL.
  SELECT SINGLE lifnr
    INTO lv_lifnr
    FROM ekko
    WHERE ebeln = i_ebeln.
ELSE.
  lv_lifnr = i_lifnr.
ENDIF.

" Seleciona o material e UM do pedido de compra
IF i_matnr IS INITIAL.
  SELECT SINGLE matnr meins bprme
   INTO ( lv_matnr, lv_meins, lv_bprme )
   FROM ekpo
   WHERE ebeln = i_ebeln AND
         ebelp = i_ebelp.
ELSE.
  lv_matnr = i_matnr.
ENDIF.

* Qdo houver UM de preço diferente da UM do pedido, considerar a UM de preço
IF lv_bprme IS NOT INITIAL AND
  lv_meins NE lv_bprme.
  lv_meins = lv_bprme.
ENDIF.

" Seleciona a unidade de medida SAP pelo fornecedor e material


IF lv_meins = lv_mseh3.
  c_erfme = lv_meins.
ELSE.
  DATA(lv_um_in) = CONV j_1bnfe_utrib( lv_mseh3 && '%' ).

  SELECT um_out UP TO 1 ROWS
   INTO @DATA(lv_um_out)
   FROM ztmm_fiscal_inb
   WHERE lifnr  EQ @lv_lifnr
     AND matnr  EQ @lv_matnr
     AND um_in  LIKE @lv_um_in.
  ENDSELECT.
  IF sy-subrc EQ 0.
    c_erfme = lv_um_out.
  ELSE.
    " Seleciona a unidade de medida SAP pelo fornecedor
    SELECT um_out UP TO 1 ROWS
     INTO @lv_um_out
     FROM ztmm_fiscal_inb
     WHERE lifnr  EQ @lv_lifnr
       AND matnr  EQ @space
       AND um_in  LIKE @lv_um_in.
    ENDSELECT.
    IF sy-subrc EQ 0.
      c_erfme = lv_um_out.
    ELSE.
      " Seleciona a unidade de medida SAP por regra geral
      SELECT um_out "#EC CI_EMPTY_SELECT
        INTO @lv_um_out
        FROM ztmm_fiscal_inb
        WHERE lifnr  EQ @space
          AND matnr  EQ @space
          AND um_in  LIKE @lv_um_in.
      ENDSELECT.
      IF sy-subrc EQ 0.
        c_erfme = lv_um_out.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

" Prepara UM para encontrar ISO code
IF c_erfme IS NOT INITIAL.
  CALL FUNCTION 'UNIT_OF_MEASURE_SAP_TO_ISO'
    EXPORTING
      sap_code    = c_erfme
    IMPORTING
      iso_code    = c_erfme_iso
    EXCEPTIONS
      not_found   = 1
      no_iso_code = 2
      OTHERS      = 3.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
  ENDIF.
ENDIF.
