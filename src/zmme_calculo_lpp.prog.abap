*&---------------------------------------------------------------------*
*& Include ZMME_CALCULO_LPP
*&---------------------------------------------------------------------*
    TYPES: BEGIN OF ty_itens,
             rblgp TYPE rblgp,
             knttp TYPE knttp,
           END OF ty_itens.

    DATA: lt_itens TYPE STANDARD TABLE OF ty_itens.

    DATA: lv_tabix TYPE sy-tabix,
          lv_salva TYPE char1.

    CONSTANTS: lc_modulo TYPE ze_param_modulo VALUE 'MM',
               lc_chave1 TYPE ze_param_chave  VALUE 'LPP',
               lc_chave2 TYPE ze_param_chave  VALUE 'EXC_MTART_TAB'.

    SELECT modulo,
           chave1,
           chave2,
           chave3,
           low
      FROM ztca_param_val
     WHERE modulo = @lc_modulo
       AND chave1 = @lc_chave1
       AND chave2 = @lc_chave2
      INTO TABLE @DATA(lt_param).

    IF sy-subrc IS INITIAL.
      SORT lt_param BY chave3
                       low.
    ENDIF.

    LOOP AT x4_rseg ASSIGNING FIELD-SYMBOL(<fs_rseg>).

      CHECK <fs_rseg>-knttp IS NOT INITIAL.

      READ TABLE lt_param ASSIGNING FIELD-SYMBOL(<fs_param>)
                                        WITH KEY chave3 = <fs_rseg>-mtart
                                                 low    = <fs_rseg>-knttp
                                                 BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lt_itens = VALUE #( BASE lt_itens ( rblgp = <fs_rseg>-rblgp
                                            knttp = <fs_rseg>-knttp ) ).
        CLEAR <fs_rseg>-knttp.
      ENDIF.
    ENDLOOP.
