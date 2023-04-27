"Name: \FU:J_1B_NF_CFOP_1_DETERMINATION\SE:BEGIN\EI
ENHANCEMENT 0 ZMMEI0021.
*Determinação CFOP - MM

* Determinação para compra de insumos com triangulação
FIELD-SYMBOLS <fs_ekpo> LIKE ekpo.

ASSIGN ('(SAPLJ1BI)EKPO') TO <fs_ekpo>.
IF <fs_ekpo> IS ASSIGNED.
  IF cfop_parameters-direct = '1' AND "Entrada
     cfop_parameters-itmtyp = '01' AND "Item normal
     <fs_ekpo>-serru EQ 'X'. "Tipo de Subcontração "X - Subcontratação 3C (Remessa) - Triangulação

    select sign, opt, low, high
      from ZTCA_PARAM_VAL
      where MODULO = 'MM'
        and CHAVE1 = 'MATUSE_SUB_TRIANG'
        and chave2 = 'MATUSE'
      into TABLE @data(lt_range_MATUSE).

      if lt_range_MATUSE is not INITIAL.
        if cfop_parameters-matuse in lt_range_MATUSE.

           cfop_parameters-itmtyp = 'X1'. "Item normal (por triangulação)
*      CLEAR: cfop_parameters-spcsto,
*             cfop_parameters-indus3.
        ENDIF.
      ENDIF.
  ENDIF.
ENDIF.

* Determinação para entrada de industrialização e retorno de insumos sem passagem pela empresa
FIELD-SYMBOLS: <fs_header> LIKE j_1bnfdoc,
               <fs_ekko>   LIKE ekko,
               <fs_doc> LIKE j_1bnfdoc,
               <fs_mkpf> LIKE mkpf.

ASSIGN ('(SAPLMBWL)MKPF') TO <fs_mkpf>.
ASSIGN ('(SAPLJ1BF)WA_NF_DOC') TO <fs_doc>.

ASSIGN ('(SAPLJ1BI)EKKO') TO <fs_ekko>.
ASSIGN ('(SAPLJ1BI)NFHEADER') TO <fs_header>.

IF <fs_header> IS ASSIGNED.
  IF cfop_parameters-direct = '1' AND "Entrada
     ( cfop_parameters-itmtyp = '31' OR "Item de fatura subcontratação
       cfop_parameters-itmtyp = '32' OR "Componente de subcontratação item de transporte
       cfop_parameters-itmtyp = '33' ). "Item simbólico de transporte subcontratação
    IF <fs_ekko> IS ASSIGNED AND <fs_ekko>-lifnr IS NOT INITIAL.
      SELECT SINGLE * INTO @DATA(ls_lfa1)
      FROM lfa1 WHERE lifnr = @<fs_ekko>-lifnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * INTO @DATA(ls_innfehdfrom)
        FROM /xnfe/innfehd WHERE cnpj_emit = @ls_lfa1-stcd1 AND
                                 nnf = @<fs_header>-nfenum.
      ENDIF.
    ELSE.
      IF <fs_mkpf> IS ASSIGNED AND <fs_doc>-cgc IS NOT INITIAL.
        SELECT SINGLE * INTO ls_innfehdfrom
        FROM /xnfe/innfehd WHERE cnpj_emit = <fs_doc>-cgc AND
                                 nnf = <fs_mkpf>-xblnr(9).
      ENDIF.
    ENDIF.
        IF ls_innfehdfrom IS NOT INITIAL.
"Separando os itens no cenário de Subcontratação
          IF cfop_parameters-itmtyp = '33'.
          SELECT SINGLE * INTO @DATA(ls_innfeit_sc)
          FROM /xnfe/innfeit WHERE guid_header = @ls_innfehdfrom-guid_header
                             AND   itemtype    = 'SRE'.

            IF sy-subrc IS INITIAL.
            "Altera para CFOP correto
            IF ls_innfeit_sc-cfop(4) = '6902'.
              cfop = '2902AA'.
            ELSEIF ls_innfeit_sc-cfop(4) = '5902'.
              cfop = '1902AA'.
            ENDIF.
             RETURN.
            ENDIF.

           ELSE.
            SELECT SINGLE * INTO @DATA(ls_innfeit)
            FROM /xnfe/innfeit WHERE guid_header = @ls_innfehdfrom-guid_header.
             IF ls_innfeit-cfop = '5925' OR ls_innfeit-cfop = '6925' OR
             ls_innfeit-cfop = '5124' OR ls_innfeit-cfop = '6124' OR
             ls_innfeit-cfop = '5125' OR ls_innfeit-cfop = '6125' OR
             ls_innfeit-cfop = '5902' OR ls_innfeit-cfop = '6902' OR
             ls_innfeit-cfop = '5903' OR ls_innfeit-cfop = '6903' OR
             ls_innfeit-cfop = '5906' OR ls_innfeit-cfop = '6906' OR
             ls_innfeit-cfop = '5907' OR ls_innfeit-cfop = '6907'.
              IF ls_innfeit-cfop(1) = '5'.
                cfop = ls_innfeit-cfop.
                cfop(1) = '1'.
                cfop+4(2) = 'AA'.
                RETURN.
              ELSE.
                cfop = ls_innfeit-cfop.
                cfop(1) = '2'.
                cfop+4(2) = 'AA'.
                RETURN.
              ENDIF.
            ENDIF.
          ENDIF.
         ENDIF.
      ENDIF.
    ENDIF.
ENDENHANCEMENT.
