"!<p>Essa classe é utilizada para atualizar o numero de serie do equipamento
"!<p><strong>Autor:</strong> Lyon Freitas - Meta</p>
"!<p><strong>Data:</strong> 04/04/2022</p>
CLASS zclmm_num_serie_eqmt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    "! Metodo para atualizar o numero de serie do equipamento
    METHODS att_num_serie_eqmt.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_num_serie_eqmt IMPLEMENTATION.


  METHOD att_num_serie_eqmt.

    CONSTANTS: lc_modulo TYPE ze_param_modulo  VALUE 'MM',
               lc_chave1 TYPE ze_param_chave   VALUE 'NUM_SERIE_EQMT',
               lc_chave2 TYPE ze_param_chave   VALUE 'MODIFY',
               lc_bwart  TYPE ze_param_chave_3 VALUE 'BWART'.

    DATA: ls_nrlevel  TYPE equnr.

    DATA: ls_mensagem    TYPE string.

    DATA: ls_equipament    TYPE bapi_equi-equipment,
          ls_equi_master   TYPE bapi_equi,
          ls_equi_master_x TYPE bapi_equi_x,
          ls_equi_ret1     TYPE bapireturn.

    DATA: lr_bwart TYPE RANGE OF ser03-bwart.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " INSERT - JWSILVA - 21.07.2023

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = lc_modulo      " CHANGE - JWSILVA - 21.07.2023
                                         iv_chave1 = lc_chave1
                                         iv_chave2 = lc_chave2
                                         iv_chave3 = lc_bwart
                               IMPORTING et_range  = lr_bwart ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    IF lr_bwart IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lv_date) = sy-datum.
    lv_date = lv_date - 365.

    SELECT equi~equnr, ser03~obknr, ser03~lieferant
        FROM ser03
        INNER JOIN objk ON objk~obknr EQ ser03~obknr
        INNER JOIN equi ON equi~equnr EQ objk~equnr AND equi~sernr EQ objk~sernr
    WHERE ser03~bwart     IN @lr_bwart "('Y61', 'Y62', 'Y63', 'Y64')
      AND ser03~lieferant NE ' '
      AND equi~equnr NE @space
      AND equi~eqtyp = 'B'
      AND equi~elief = ' '
      AND ser03~datum GT @lv_date
    ORDER BY ser03~datum DESCENDING, ser03~uzeit DESCENDING
    INTO TABLE @DATA(lt_ser03)
    UP TO 500 ROWS.


    LOOP AT lt_ser03 ASSIGNING FIELD-SYMBOL(<fs_ser03>).

      ls_equipament = <fs_ser03>-equnr.
      ls_equi_master-vendor = <fs_ser03>-lieferant.
      ls_equi_master_x-vendor = abap_true.

      CLEAR ls_equi_ret1.
      CALL FUNCTION 'BAPI_EQMT_MODIFY'
        EXPORTING
          equipment    = <fs_ser03>-equnr
          equimaster   = ls_equi_master
          equimaster_x = ls_equi_master_x
        IMPORTING
          return       = ls_equi_ret1.

      IF ls_equi_ret1 IS NOT INITIAL AND  ls_equi_ret1-type = 'E'.
        CONCATENATE ls_equipament ls_equi_ret1-message_v1
                                  ls_equi_ret1-message_v2
                                  ls_equi_ret1-message_v3
                                  ls_equi_ret1-message_v4
                                  INTO ls_mensagem.
        WRITE ls_mensagem.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
