"! <p>Classe para Fórmulas VOFM
"! <br>
"! <br>Autor: Jefferson Fujii
"! <br>Data: 14/02/2022
"!
CLASS zclmm_formulas_vofm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <strong>Fórmula Base da Condição 964</strong>
    "! @parameter is_komp | Determinação de preço item de comunicação
    "! @parameter it_komv | Registro de condição de comunicação p/determinação de preço
    "! @parameter cs_xkomv | Estrutura-KOMV plus índice
    METHODS base_condicao_964
      IMPORTING
        !is_komp   TYPE komp
        !it_komv   TYPE tax_xkomv_tab
      CHANGING
        !cs_xkomv  TYPE komv_index
        !cs_xkwert TYPE kwert .

    "! <strong>Fórmula Valor da Condição 909</strong>
    "! @parameter it_komv | Registro de condição de comunicação p/determinação de preço
    "! @parameter is_comm_head | Determinação de preço - cabeçalho comunicação
    "! @parameter is_comm_item | Determinação de preço item de comunicação
    "! @parameter cv_xkwert | Valor condição
    "! @parameter cs_xkomv | Estrutura-KOMV plus índice
    "! @parameter ct_xkomv | Tabela KOMV plus índice
    METHODS valor_condicao_909
      IMPORTING
        !it_komv      TYPE komv_tab
        !is_comm_head TYPE komk
        !is_comm_item TYPE komp
      CHANGING
        !cs_komp      TYPE komp
        !cv_xkwert    TYPE kwert
        !cs_xkomv     TYPE komv_index
        !ct_xkomv     TYPE tax_xkomv_tab .

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_t683s,
        stunr TYPE stunr,
        zaehk TYPE dzaehk,
        kschl TYPE kschl,
        stunb TYPE stunb,
        stun2 TYPE stun2,
        kstat TYPE kstat,
      END OF ty_t683s .
    TYPES:
      ty_t683s_tab TYPE TABLE OF ty_t683s .

    CONSTANTS:
      "! Módulo
      gc_modulo TYPE ze_param_modulo VALUE 'MM',
      "! Chave 1
      gc_chave1 TYPE ze_param_chave VALUE 'PRICING_MM',
      "! Chave 2
      gc_chave2 TYPE ze_param_chave VALUE 'BSART',
      "! Chave 3
      gc_chave3 TYPE ze_param_chave_3 VALUE 'FORM_909'.

    "! Aplicação (TX-Impostos)
    CONSTANTS gc_tx TYPE kappl VALUE 'TX' ##NO_TEXT.
    CONSTANTS:
      "! Tipos de condição
      BEGIN OF gc_cond,
        "! Tipo de condição BCO1
        bco1 TYPE kscha VALUE 'BCO1',
        "! Tipo de condição BCO2
        bco2 TYPE kscha VALUE 'BCO2',
        "! Tipo de condição BIC0
        bic0 TYPE kscha VALUE 'BIC0',
        "! Tipo de condição BIC1
        bic1 TYPE kscha VALUE 'BIC1',
        "! Tipo de condição BIP0
        bip0 TYPE kscha VALUE 'BIP0',
        "! Tipo de condição BPI1
        bpi1 TYPE kscha VALUE 'BPI1',
        "! Tipo de condição BX10
        bx10 TYPE kscha VALUE 'BX10',
        "! Tipo de condição BX11
        bx11 TYPE kscha VALUE 'BX11',
        "! Tipo de condição BX12
        bx12 TYPE kscha VALUE 'BX12',
        "! Tipo de condição BX16
        bx16 TYPE kscha VALUE 'BX16',
        "! Tipo de condição ICM0
        icm0 TYPE kscha VALUE 'ICM0',
        "! Tipo de condição ICM1
        icm1 TYPE kscha VALUE 'ICM1',
        "! Tipo de condição ZCM1
        zcm1 TYPE kscha VALUE 'ZCM1',
        "! Tipo de condição IC1C
        ic1c TYPE kscha VALUE 'IC1C',
        "! Tipo de condição ZICD
        zicd TYPE kscha VALUE 'ZICD',
        "! Tipo de condição ICZG
        iczg TYPE kscha VALUE 'ICZG', "Desonerado
        "! Tipo de condição ICM2
        icm2 TYPE kscha VALUE 'ICM2',
        "! Tipo de condição ICOA
        icoa TYPE kscha VALUE 'ICOA',
        "! Tipo de condição ICOF
        icof TYPE kscha VALUE 'ICOF',
        "! Tipo de condição ICON
        icon TYPE kscha VALUE 'ICON',
        "! Tipo de condição ICOS
        icos TYPE kscha VALUE 'ICOS',
        "! Tipo de condição ICOU
        icou TYPE kscha VALUE 'ICOU',
        "! Tipo de condição ICOV
        icov TYPE kscha VALUE 'ICOV',
        "! Tipo de condição IPI1
        ipi1 TYPE kscha VALUE 'IPI1',
        "! Tipo de condição IPI2
        ipi2 TYPE kscha VALUE 'IPI2',
        "! Tipo de condição IPIS
        ipis TYPE kscha VALUE 'IPIS',
        "! Tipo de condição IPSA
        ipsa TYPE kscha VALUE 'IPSA',
        "! Tipo de condição IPSN
        ipsn TYPE kscha VALUE 'IPSN',
        "! Tipo de condição IPSS
        ipss TYPE kscha VALUE 'IPSS',
        "! Tipo de condição IPSU
        ipsu TYPE kscha VALUE 'IPSU',
        "! Tipo de condição IPSV
        ipsv TYPE kscha VALUE 'IPSV',
        "! Tipo de condição PBXX
        pbxx TYPE kscha VALUE 'PBXX',
        "! Tipo de condição PMP0
        pmp0 TYPE kscha VALUE 'PMP0',
        "! Tipo de condição YCM1
        ycm1 TYPE kscha VALUE 'YCM1',
        "! Tipo de condição YCM2
        ycm2 TYPE kscha VALUE 'YCM2',
        "! Tipo de condição ZBC1
        zbc1 TYPE kscha VALUE 'ZBC1',
        "! Tipo de condição ZBC2
        zbc2 TYPE kscha VALUE 'ZBC2',
        "! Tipo de condição ZBI1
        zbi1 TYPE kscha VALUE 'ZBI1',
        "! Tipo de condição ZBIC
        zbic TYPE kscha VALUE 'ZBIC',
        "! Tipo de condição ZCOF
        zcof TYPE kscha VALUE 'ZCOF',
        "! Tipo de condição ZICM
        zicm TYPE kscha VALUE 'ZICM',
        "! Tipo de condição ZZIP
        zipi TYPE kscha VALUE 'ZZIP',
        "! Tipo de condição ZPBB
        zpbb TYPE kscha VALUE 'ZPBB',
        "! Tipo de condição ZPIS
        zpis TYPE kscha VALUE 'ZPIS',
      END OF gc_cond .
    DATA gt_t683s TYPE ty_t683s_tab .
    DATA gs_komp TYPE komp .
    DATA gs_xkomv TYPE komv_index .
    DATA gt_xkomv TYPE tax_xkomv_tab .
ENDCLASS.



CLASS zclmm_formulas_vofm IMPLEMENTATION.

  METHOD base_condicao_964.

    IF it_komv IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lt_komv) = it_komv.
    SORT lt_komv BY kschl kposn.

    CASE cs_xkomv-kschl.
      WHEN gc_cond-zicm.

        READ TABLE lt_komv INTO DATA(ls_bx10)
          WITH KEY kschl = gc_cond-bx10
                   kposn = is_komp-kposn BINARY SEARCH.

        READ TABLE lt_komv INTO DATA(ls_bx11)
          WITH KEY kschl = gc_cond-bx11
                   kposn = is_komp-kposn BINARY SEARCH.

        READ TABLE lt_komv INTO DATA(ls_bx12)
          WITH KEY kschl = gc_cond-bx12
                   kposn = is_komp-kposn BINARY SEARCH.

        READ TABLE lt_komv INTO DATA(ls_bx16)
          WITH KEY kschl = gc_cond-bx16
                   kposn = is_komp-kposn BINARY SEARCH.

        IF ls_bx16-kwert IS NOT INITIAL.
          IF ls_bx11-kwert IS INITIAL.
            ls_bx11-kwert = ls_bx10-kwert.
          ENDIF.
          IF ls_bx11-kwert IS INITIAL.
            ls_bx11-kwert = ls_bx12-kwert.
          ENDIF.
          cs_xkwert = ls_bx11-kwert * ( ls_bx16-kwert / 1000 ).
          IF cs_xkwert GT 0.
            MULTIPLY cs_xkwert BY -1.
          ENDIF.
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD valor_condicao_909.

    DATA lr_bsart TYPE RANGE OF bsart.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = gc_modulo
                                         iv_chave1 = gc_chave1
                                         iv_chave2 = gc_chave2
                                         iv_chave3 = gc_chave3
                               IMPORTING et_range  = lr_bsart ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    DATA(lt_komv) = it_komv.
    SORT lt_komv BY kposn kschl.

    SORT ct_xkomv BY kposn kschl.
    READ TABLE ct_xkomv ASSIGNING FIELD-SYMBOL(<fs_xkomv>)
      WITH KEY kposn = cs_komp-kposn
               kschl = cs_xkomv-kschl BINARY SEARCH.
    IF sy-subrc NE 0.
      UNASSIGN <fs_xkomv>.
    ENDIF.

    CASE cs_xkomv-kschl.
      WHEN space. " Valor Líquido
        cs_komp-netwr = cs_xkomv-kwert.

      WHEN gc_cond-zipi. "IPI
        SELECT SINGLE COUNT( * ) FROM a003 BYPASSING BUFFER
          WHERE kappl EQ @gc_tx
            AND kschl IN (@gc_cond-ipi1,@gc_cond-ipi2)
            AND aland EQ @is_comm_head-aland
            AND mwskz EQ @is_comm_item-mwskz.

        IF sy-subrc = 0.
          READ TABLE lt_komv INTO DATA(ls_komv) WITH KEY kposn = cs_komp-kposn
                                                         kschl = gc_cond-bip0 BINARY SEARCH.
          IF sy-subrc NE 0 .
            CLEAR: cv_xkwert, cs_xkomv-kwert.
            CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
              <fs_xkomv>-kawrt = cs_xkomv-kawrt.
            ENDIF.
          ELSE.
            cs_xkomv-kbetr = ls_komv-kbetr.
            cv_xkwert      = ( cs_komp-kzwi6 * cs_xkomv-kbetr ) / 1000.
            cs_xkomv-kwert = ( cs_komp-kzwi6 * cs_xkomv-kbetr ) / 1000.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            ENDIF.
          ENDIF.
        ENDIF.


      WHEN gc_cond-zicm OR gc_cond-zbic OR gc_cond-zbi1. "ICMS / Base ICMS
        SELECT SINGLE COUNT( * ) FROM a003 BYPASSING BUFFER
          WHERE kappl = @gc_tx
            AND kschl = @gc_cond-icm0
            AND aland = @is_comm_head-aland
            AND mwskz = @is_comm_item-mwskz.

        IF sy-subrc NE 0.
          SELECT SINGLE * FROM a003 INTO @DATA(ls_a003)
            WHERE kappl = @gc_tx
              AND kschl IN (@gc_cond-zicd,@gc_cond-zcm1,@gc_cond-icm1,@gc_cond-icm2,@gc_cond-ycm1,@gc_cond-ycm2,@gc_cond-iczg, @gc_cond-ic1c)
              AND aland = @is_comm_head-aland
              AND mwskz = @is_comm_item-mwskz.

          IF sy-subrc = 0.
            CASE cs_xkomv-kschl.
              WHEN gc_cond-zicm. "ICMS**********************************************************
                READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                         kschl = gc_cond-bic0 BINARY SEARCH.
                IF sy-subrc NE 0 .
                  CLEAR: cv_xkwert, cs_xkomv-kwert.
                  CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
                  IF <fs_xkomv> IS ASSIGNED.
                    <fs_xkomv>-kbetr = cs_xkomv-kbetr.
                    <fs_xkomv>-kawrt = cs_xkomv-kawrt.
                  ENDIF.

                ELSE.
                  cs_xkomv-kbetr = ls_komv-kbetr.
*                  cs_xkomv-kwert = ( ( cs_komp-kzwi4 * cs_xkomv-kbetr ) / 1000 ) * -1.
                  cs_xkomv-kwert = ( ( cs_komp-kzwi4 * cs_xkomv-kbetr ) / 1000 ).
                  cv_xkwert = cs_xkomv-kwert.
                  IF <fs_xkomv> IS ASSIGNED.
                    <fs_xkomv>-kbetr = cs_xkomv-kbetr.
                  ENDIF.

                ENDIF.

              WHEN gc_cond-zbic. "Base -> Mat. use = 0, 1****************************************
                IF cs_komp-mtuse = 0 OR cs_komp-mtuse = 1.
                  READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                           kschl = gc_cond-bic1 BINARY SEARCH.
                  IF sy-subrc NE 0 .
                    CLEAR cv_xkwert.
                    CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
                    IF <fs_xkomv> IS ASSIGNED.
                      <fs_xkomv>-kbetr = cs_xkomv-kbetr.
                      <fs_xkomv>-kawrt = cs_xkomv-kawrt.
                    ENDIF.

                  ELSE.
                    IF is_comm_head-bsart IN lr_bsart AND
                       ls_komv-kbetr > 0.
                      MULTIPLY ls_komv-kbetr BY -1.
                    ENDIF.
                    cs_xkomv-kbetr = ls_komv-kbetr.
                    cv_xkwert      = ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000.
                    cs_xkomv-kwert = ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000.
                    IF <fs_xkomv> IS ASSIGNED.
                      <fs_xkomv>-kbetr = cs_xkomv-kbetr.
                    ENDIF.

                  ENDIF.
                ENDIF.

              WHEN gc_cond-zbi1. "Base -> Mat. use = 2, 3*****************************************
                IF cs_komp-mtuse = 2 OR   cs_komp-mtuse = 3.
                  READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                           kschl = gc_cond-bic1 BINARY SEARCH.
                  IF sy-subrc NE 0 .
                    CLEAR cv_xkwert.
                    CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
                    IF <fs_xkomv> IS ASSIGNED.
                      <fs_xkomv>-kbetr = cs_xkomv-kbetr.
                      <fs_xkomv>-kawrt = cs_xkomv-kawrt.
                    ENDIF.

                  ELSE.
                    IF is_comm_head-bsart IN lr_bsart AND
                       ls_komv-kbetr > 0.
                      MULTIPLY ls_komv-kbetr BY -1.
                    ENDIF.
                    cs_xkomv-kbetr = ls_komv-kbetr.
                    cv_xkwert      = ( cs_komp-kzwi5 * cs_xkomv-kbetr ) / 1000.
                    cs_xkomv-kwert = ( cs_komp-kzwi5 * cs_xkomv-kbetr ) / 1000.
                    IF <fs_xkomv> IS ASSIGNED.
                      <fs_xkomv>-kbetr = cs_xkomv-kbetr.
                    ENDIF.

                  ENDIF.
                ENDIF.
            ENDCASE.
          ELSE.
            CLEAR cv_xkwert.
            CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
              <fs_xkomv>-kawrt = cs_xkomv-kawrt.
            ENDIF.


          ENDIF.
        ELSE.
          CLEAR cv_xkwert.
          CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
          IF <fs_xkomv> IS ASSIGNED.
            <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            <fs_xkomv>-kawrt = cs_xkomv-kawrt.
          ENDIF.

        ENDIF.

      WHEN gc_cond-zpis. "Pis *********************************************************************
        SELECT SINGLE COUNT( * ) FROM a003 BYPASSING BUFFER
          WHERE kappl = @gc_tx
            AND kschl IN (@gc_cond-ipis,@gc_cond-ipsa,@gc_cond-ipss,@gc_cond-ipsu,@gc_cond-ipsv,@gc_cond-ipsn)
            AND aland = @is_comm_head-aland
            AND mwskz = @is_comm_item-mwskz.

        IF sy-subrc = 0.
          READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                   kschl = gc_cond-bpi1 BINARY SEARCH.
          IF sy-subrc NE 0 .
            CLEAR cv_xkwert.
            CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
              <fs_xkomv>-kawrt = cs_xkomv-kawrt.
            ENDIF.

          ELSE.
            CLEAR cv_xkwert.
            cs_xkomv-kbetr = ls_komv-kbetr.
            IF cs_komp-mtuse = 2 OR   cs_komp-mtuse = 3.
              cv_xkwert      = ( ( cs_komp-kzwi5 * cs_xkomv-kbetr ) / 1000 ) * -1.
              cs_xkomv-kwert = ( ( cs_komp-kzwi5 * cs_xkomv-kbetr ) / 1000 ) * -1.
            ELSE.
              cv_xkwert      = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
              cs_xkomv-kwert = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
            ENDIF.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            ENDIF.

          ENDIF.

        ELSE.
          CLEAR cv_xkwert.
          CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
          cv_xkwert      = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
          cs_xkomv-kwert = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
          IF <fs_xkomv> IS ASSIGNED.
            <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            <fs_xkomv>-kawrt = cs_xkomv-kawrt.
          ENDIF.

        ENDIF.

      WHEN gc_cond-zcof. "Cofins***********************************************************
        SELECT SINGLE COUNT( * ) FROM a003 BYPASSING BUFFER
          WHERE kappl = @gc_tx
            AND kschl IN (@gc_cond-icoa,@gc_cond-icof,@gc_cond-icos,@gc_cond-icou,@gc_cond-icov,@gc_cond-icon)
            AND aland = @is_comm_head-aland
            AND mwskz = @is_comm_item-mwskz. "cs_komp-mwskz."is_comm_item-mwskz.

        IF sy-subrc = 0.
          READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                   kschl = gc_cond-bco1 BINARY SEARCH.
          IF sy-subrc NE 0 .
            CLEAR cv_xkwert.
            CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
              <fs_xkomv>-kawrt = cs_xkomv-kawrt.
            ENDIF.

          ELSE.
            cs_xkomv-kbetr = ls_komv-kbetr.
            IF cs_komp-mtuse = 2 OR   cs_komp-mtuse = 3.
              cv_xkwert      = ( ( cs_komp-kzwi5 * cs_xkomv-kbetr ) / 1000 ) * -1.
              cs_xkomv-kwert = ( ( cs_komp-kzwi5 * cs_xkomv-kbetr ) / 1000 ) * -1.
            ELSE.
              cv_xkwert      = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
              cs_xkomv-kwert = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
            ENDIF.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            ENDIF.

          ENDIF.

        ELSE.
          CLEAR cv_xkwert.
          CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
          cv_xkwert      = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
          cs_xkomv-kwert = ( ( cs_komp-kzwi2 * cs_xkomv-kbetr ) / 1000 ) * -1.
          IF <fs_xkomv> IS ASSIGNED.
            <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            <fs_xkomv>-kawrt = cs_xkomv-kawrt.
          ENDIF.

        ENDIF.

      WHEN gc_cond-zbc1. "Base PIS/COFINS Revenda/Indust -> Mat. use = 0, 1
        IF cs_komp-mtuse = 0
        OR cs_komp-mtuse = 1.
          READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                   kschl = gc_cond-bco2 BINARY SEARCH.
          IF sy-subrc NE 0 .
            CLEAR cv_xkwert.
            CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
              <fs_xkomv>-kawrt = cs_xkomv-kawrt.
            ENDIF.

          ELSE.
            cs_xkomv-kbetr = ls_komv-kbetr.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            ENDIF.

          ENDIF.
        ENDIF.

      WHEN gc_cond-zbc2. "Base PIS/COFINS Consumo/Imobilizado -> Mat. use = 2, 3
        IF cs_komp-mtuse = 2
        OR cs_komp-mtuse = 3.
          READ TABLE lt_komv INTO ls_komv WITH KEY kposn = cs_komp-kposn
                                                   kschl = gc_cond-bco2 BINARY SEARCH.
          IF sy-subrc NE 0 .
            CLEAR cv_xkwert.
            CLEAR: cs_xkomv-kbetr, cs_xkomv-kawrt.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
              <fs_xkomv>-kawrt = cs_xkomv-kawrt.
            ENDIF.

          ELSE.
            cs_xkomv-kbetr = ls_komv-kbetr.
            IF <fs_xkomv> IS ASSIGNED.
              <fs_xkomv>-kbetr = cs_xkomv-kbetr.
            ENDIF.

          ENDIF.
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
