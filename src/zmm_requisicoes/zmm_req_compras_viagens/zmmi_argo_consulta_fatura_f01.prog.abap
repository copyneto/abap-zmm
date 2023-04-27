*----------------------------------------------------------------------*
***INCLUDE ZMMI_ARGO_GERA_FATURA_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_get_parametros
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_parametros.

  SELECT chave3 low high
    INTO CORRESPONDING FIELDS OF TABLE gt_param
    FROM ztca_param_val
    WHERE modulo = 'MM'
      AND chave1 = 'BENNER'
      AND chave2 = 'FATURA'.
  IF sy-subrc IS INITIAL.
    SORT gt_param BY chave3.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_consulta_fatura
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_consulta_fatura .

  DATA: ls_output TYPE zclmm_mt_pedido_compra.

  DATA: lv_dataini TYPE char20,
        lv_datafim TYPE char20.

  PERFORM f_get_data_inicio CHANGING lv_dataini.
  PERFORM f_get_data_fim CHANGING lv_datafim.

  DATA(ls_input) = VALUE zclmm_dt_fatura( tipo_data     = VALUE #( gt_param[ chave3 = 'TIPODATA' ]-low DEFAULT '' )
                                          data_inicial  = lv_dataini
                                          data_final    = lv_datafim
                                          status        = VALUE #( gt_param[ chave3 = 'STATUS' ]-low DEFAULT '' ) ).

  DATA(lo_object) = NEW zclmm_argo_pedido_compra( ).

  DATA(ls_return) = lo_object->busca_fatura( EXPORTING is_input  = ls_input
                                             IMPORTING es_output = ls_output ).

  IF ls_output IS NOT INITIAL.
    lo_object->gera_pedido(
      EXPORTING
        is_input  = ls_output
      IMPORTING
        et_return = DATA(lt_return) ).
  ENDIF.

  WRITE: / , ls_return.

  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
    WRITE: / , <fs_return>-message.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data_inicio
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DATAINI
*&---------------------------------------------------------------------*
FORM f_get_data_inicio  CHANGING cv_dataini TYPE char20.

  DATA: lv_dia  TYPE t5a4a-dlydy,
        lv_data TYPE p0001-begda.

  lv_dia = VALUE #( gt_param[ chave3 = 'DATAINI' ]-low DEFAULT '' ).

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = lv_dia
      months    = '00'
      signum    = '-'
      years     = '00'
    IMPORTING
      calc_date = lv_data.

*  2021-05-11T04:00:00Z

  cv_dataini = lv_data(4) && '-' && lv_data+4(2) && '-' && lv_data+6(2) && 'T00:00:00Z'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data_fim
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DATAFIM
*&---------------------------------------------------------------------*
FORM f_get_data_fim  CHANGING cv_datafim TYPE char20.

  DATA: lv_dia  TYPE t5a4a-dlydy,
        lv_data TYPE p0001-begda.

  lv_dia = VALUE #( gt_param[ chave3 = 'DATAFIM' ]-low DEFAULT '' ).

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = lv_dia
      months    = '00'
      signum    = '+'
      years     = '00'
    IMPORTING
      calc_date = lv_data.

  cv_datafim = lv_data(4) && '-' && lv_data+4(2) && '-' && lv_data+6(2) && 'T00:00:00Z'.

ENDFORM.
