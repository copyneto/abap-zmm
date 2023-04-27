*&---------------------------------------------------------------------*
*& Include          ZMMI_IMOBILIZADO_INFCPL
*&---------------------------------------------------------------------*

IF cs_header-infcpl IS INITIAL AND it_nfftx[] IS NOT INITIAL.
  LOOP AT it_nfftx[] ASSIGNING FIELD-SYMBOL(<fs_nfftx>).
    IF sy-tabix EQ 1.
      cs_header-infcpl = <fs_nfftx>-message.
    ELSE.
      cs_header-infcpl =  |{ cs_header-infcpl } { '-' } { <fs_nfftx>-message }|.
    ENDIF.

  ENDLOOP.

ENDIF.
