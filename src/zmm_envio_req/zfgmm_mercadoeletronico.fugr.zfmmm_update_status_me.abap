FUNCTION zfmmm_update_status_me.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      IT_REQ STRUCTURE  ZSMM_REQ
*"----------------------------------------------------------------------
  " Esse processo foi desenvolvido porque quando é aprovado o item da requisição via workflow a
  " sessão fica presa por alguns segundos, dependendo da quantidade de itens aprovados naquele momento,
  " com isso não é possivel fazer nenhum atualização na tabela EBAN

  CONSTANTS gc_m TYPE c VALUE 'M' ##NO_TEXT.

  DATA: lt_xeban TYPE STANDARD TABLE OF ueban,
        lt_yeban TYPE STANDARD TABLE OF ueban,
        lt_xebkn TYPE STANDARD TABLE OF uebkn,
        lt_yebkn TYPE STANDARD TABLE OF uebkn.

  IF it_req[] IS NOT INITIAL.

    SELECT a~* FROM eban AS a
    INNER JOIN mara AS b
    ON a~matnr = b~matnr
    FOR ALL ENTRIES IN @it_req
    WHERE banfn = @it_req-banfn
      AND bnfpo = @it_req-bnfpo
      AND zz1_statu <> 'C'
      AND loekz = ''
      INTO CORRESPONDING FIELDS OF TABLE @lt_xeban.

    IF sy-subrc EQ 0.

      SELECT a~* FROM eban AS a
      INNER JOIN ztmm_envio_req AS b
        ON  a~banfn = b~doc_sap
        AND a~bnfpo = b~doc_item
      FOR ALL ENTRIES IN @it_req
      WHERE b~doc_sap = @it_req-banfn
        AND b~data_i IS NOT INITIAL
        APPENDING CORRESPONDING FIELDS OF TABLE @lt_xeban.

      DELETE ADJACENT DUPLICATES FROM lt_xeban COMPARING banfn bnfpo.

      lt_yeban = lt_xeban.

      LOOP AT lt_xeban ASSIGNING FIELD-SYMBOL(<fs_eban>).
        <fs_eban>-zz1_statu = gc_m .
        <fs_eban>-kz        = 'U'.
      ENDLOOP.

      DO 500 TIMES.

        CALL FUNCTION 'ME_UPDATE_REQUISITION'
          TABLES
            xeban = lt_xeban
            xebkn = lt_xebkn
            yeban = lt_yeban
            yebkn = lt_yebkn.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        WAIT UP TO 1 SECONDS.

        SELECT COUNT( * ) FROM eban
        FOR ALL ENTRIES IN @it_req
        WHERE banfn     = @it_req-banfn
          AND bnfpo     = @it_req-bnfpo
          AND zz1_statu = @gc_m
        INTO @DATA(lv_qtd).

        IF lv_qtd EQ lines( it_req ).
          EXIT.
        ENDIF.

      ENDDO.

    ENDIF.

  ENDIF.


ENDFUNCTION.
