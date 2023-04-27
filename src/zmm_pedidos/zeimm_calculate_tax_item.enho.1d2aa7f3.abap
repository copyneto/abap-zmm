"Name: \FU:CALCULATE_TAX_ITEM\SE:END\EI
ENHANCEMENT 0 ZEIMM_CALCULATE_TAX_ITEM.
  CHECK sy-tcode = 'ME21N'
     OR sy-tcode = 'ME22N'
     OR sy-tcode = 'ME23N'
     OR sy-tcode = 'ME29N'.

  ASSIGN ('(SAPLMEPO)GF_TAX_COND_CHANGED') TO FIELD-SYMBOL(<fs_tax_cond_changed>).
  IF <fs_tax_cond_changed> IS ASSIGNED.
    <fs_tax_cond_changed> = abap_true.
  ENDIF.
ENDENHANCEMENT.
