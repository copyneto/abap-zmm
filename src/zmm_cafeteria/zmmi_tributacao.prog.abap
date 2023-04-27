*&---------------------------------------------------------------------*
*& Include zmmi_tributacao
*&---------------------------------------------------------------------*

CONSTANTS: lc_segnam_tribu TYPE edilsegtyp       VALUE 'ZMM_TRIBUTACAO',
           lc_e1marmm      TYPE edidd-segnam     VALUE 'E1MARMM',
           lc_e1marcm      TYPE edidd-segnam     VALUE 'E1MARCM',
           lc_mm           TYPE ze_param_modulo  VALUE 'MM'.

DATA: lv_resul TYPE char2.

IF segment_name = lc_E1MARMM.

  TRY.

      DATA(lv_matnr) = VALUE char18( idoc_data[ segnam = 'E1MARA1' ]-sdata(8)  OPTIONAL ).

      UNPACK lv_matnr TO lv_matnr.

      IF lv_matnr IS NOT INITIAL.

        SELECT SINGLE a~mtart, a~matkl, b~werks FROM mara AS a
        INNER JOIN marc AS b
        ON a~matnr = b~matnr
        WHERE a~matnr = @lv_matnr
        INTO @DATA(ls_result).

        IF ls_result IS NOT INITIAL.

          NEW zclca_tabela_parametros( )->m_get_single(
            EXPORTING
              iv_modulo = lc_mm
              iv_chave1 = CONV #( ls_result-werks ) " WERKS
              iv_chave2 = CONV #( ls_result-mtart ) " MTART
              iv_chave3 = CONV #( ls_result-matkl ) " MATKL
            IMPORTING
              ev_param  = lv_resul ).

        ENDIF.
      ENDIF.

    CATCH zcxca_tabela_parametros.
      "handle exception
  ENDTRY.


  IF lv_resul IS NOT INITIAL.

    APPEND INITIAL LINE TO idoc_data ASSIGNING FIELD-SYMBOL(<fs_idoc_data_new>).
    <fs_idoc_data_new>-segnam = lc_segnam_tribu.
    <fs_idoc_data_new>-sdata  = lv_resul.

  ENDIF.

ENDIF.
