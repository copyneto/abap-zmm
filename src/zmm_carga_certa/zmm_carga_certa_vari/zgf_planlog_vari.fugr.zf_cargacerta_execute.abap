FUNCTION zf_cargacerta_execute.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REPORT) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_VARI) TYPE  CHAR30 OPTIONAL
*"  EXPORTING
*"     VALUE(ES_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI
*"     VALUE(ES_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: ls_planlog_vari TYPE ztplanlog_Vari,
        ls_ref          TYPE REF TO data.


  CONSTANTS: lc_mb52 TYPE sy-cprog VALUE 'RM07MLBS'.


  FIELD-SYMBOLS <fs_deriva>    TYPE STANDARD TABLE.

  SELECT SINGLE *
    FROM ztplanlog_Vari
    INTO ls_Planlog_Vari
    WHERE report = IV_report
    AND   vari = IV_vari.
  IF sy-subrc <> 0.
    SELECT *
    FROM varid
    INTO TABLE @DATA(lt_varid_mb52)
    WHERE report = @lc_mb52
    AND variant = @IV_vari.
    IF sy-subrc EQ 0.
      LOOP AT lt_varid_mb52 INTO DATA(ls_varid_mb52).
        ls_planlog_vari-vari = ls_varid_mb52-variant.
        ls_planlog_vari-report = 'MB52'.
      ENDLOOP.
    ENDIF.

  ENDIF.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING ls_planlog_vari TO es_planlog_vari.
    SUBMIT zmmsd_planlog AND RETURN
    WITH p_tran = IV_report
    WITH p_vari = IV_vari.

*-- RECUPERANDO DA MEMÓRIA O RESULTADO DO ALV.
    TRY.
        cl_salv_bs_runtime_info=>get_data_ref(
          IMPORTING r_data = ls_ref ).

        ASSIGN ls_ref->* TO <fs_deriva>.
      CATCH cx_salv_bs_sc_runtime_info.
        es_return-type = 'E'.
        es_return-message = 'Dados não encontrados!'.
    ENDTRY.


    DATA: lv_sucesso TYPE c.

    IMPORT lv_sucesso = lv_sucesso FROM MEMORY ID 'CARGA_CERTA'.
    IF lv_sucesso IS NOT INITIAL.
      es_return-type = 'S'.
      es_return-message = 'Carga realizada com sucesso!'.
    ELSE.
      es_return-type = 'E'.
      es_return-message = 'Dados não encontrados!'.
    ENDIF.


  ELSE.
    es_return-type = 'E'.
    es_return-message = 'Variante não existe!'.
  ENDIF.

ENDFUNCTION.
