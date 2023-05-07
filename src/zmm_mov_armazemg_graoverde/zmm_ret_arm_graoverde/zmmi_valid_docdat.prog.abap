*&---------------------------------------------------------------------*
*& Include          ZMMI_VALID_DOCDAT
*&---------------------------------------------------------------------*
  IF wa_nf_doc-docdat IS INITIAL.
    wa_nf_doc-docdat = m_mkpf-bldat.
    CLEAR header_values-dodat.
  ENDIF.
