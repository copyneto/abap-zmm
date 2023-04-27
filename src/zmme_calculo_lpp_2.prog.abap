*&---------------------------------------------------------------------*
*& Include ZMME_CALCULO_LPP_2
*& Complemento da Include ZMME_CALCULO_LPP
*&---------------------------------------------------------------------*

IF lt_itens[] IS NOT INITIAL.

  SORT lt_itens BY rblgp.

  LOOP AT x4_rseg ASSIGNING FIELD-SYMBOL(<fs_rseg2>).

    READ TABLE lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens2>)
                                      WITH KEY rblgp = <fs_rseg2>-rblgp
                                      BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      <fs_rseg2>-knttp = <fs_itens2>-knttp.
    ENDIF.
  ENDLOOP.

  FREE: lt_itens[].

ENDIF.
