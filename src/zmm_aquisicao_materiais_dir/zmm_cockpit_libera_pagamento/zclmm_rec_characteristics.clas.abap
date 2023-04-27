CLASS zclmm_rec_characteristics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_rec_characteristics IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_characteristics_receb_v2 WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    DATA(lt_allocvaluesnum)  = VALUE tt_bapi1003_alloc_values_num( ).
    DATA(lt_allocvalueschar) = VALUE tt_bapi1003_alloc_values_char( ).
    DATA(lt_allocvaluescurr) = VALUE tt_bapi1003_alloc_values_curr( ).
    DATA(lt_return)          = VALUE bapiret2_tab( ).

    IF lt_original_data[] IS NOT INITIAL.

        SELECT
            _ped~PurchaseOrder,
            _ped~PurchaseOrderItem,
            _ped~QuantidadeKg,
            _ped~QuantidadeSacas,
            _ped~QuantidadeBag,
            _ped~Peneira10,
            _ped~Peneira11,
            _ped~Peneira12,
            _ped~Peneira13,
            _ped~Peneira14,
            _ped~Peneira15,
            _ped~Peneira16,
            _ped~Peneira17,
            _ped~Peneira18,
            _ped~Peneira19,
            _ped~Mk10,
            _ped~Fundo,
            _ped~Catacao,
            _ped~Umidade,
            _ped~Defeito,
            _ped~Impureza,
            _ped~Verde,
            _ped~PretoArdido,
            _ped~Brocado,
            _ped~Densidade
        FROM zi_mm_characteristics_ped as _ped
        FOR ALL ENTRIES IN @lt_original_data
        WHERE _ped~PurchaseOrder = @lt_original_data-PurchaseOrder AND
              _ped~PurchaseOrderItem = @lt_original_data-PurchaseOrderItem
        INTO TABLE @DATA(lt_pedidos).

        IF lt_pedidos[] IS NOT INITIAL.
            SORT lt_pedidos BY PurchaseOrder PurchaseOrderItem.
        ENDIF.


        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>) WHERE Material IS NOT INITIAL AND Charg IS NOT INITIAL.

            DATA(lv_object) = CONV objnum( |{ <fs_data>-Material }{ <fs_data>-Charg }| ).

            READ TABLE lt_pedidos ASSIGNING FIELD-SYMBOL(<fs_pedido>) WITH KEY PurchaseOrder = <fs_data>-PurchaseOrder PurchaseOrderItem = <fs_data>-PurchaseOrderItem BINARY SEARCH.

            IF <fs_pedido> IS NOT ASSIGNED.
                APPEND INITIAL LINE TO lt_pedidos ASSIGNING <fs_pedido>.
            ENDIF.


            CLEAR: lt_allocvaluesnum, lt_allocvalueschar, lt_allocvaluescurr, lt_return.


            CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
              EXPORTING
                objectkey           = lv_object
                objecttable         = 'MCH1'
                classnum            = 'YGV_CAFE_CRU'
                classtype           = '023'
                keydate             = sy-datum
                unvaluated_chars    = abap_true
              TABLES
                allocvaluesnum      = lt_allocvaluesnum
                allocvalueschar     = lt_allocvalueschar
                allocvaluescurr     = lt_allocvaluescurr
                return              = lt_return.

            LOOP AT lt_allocvaluesnum ASSIGNING FIELD-SYMBOL(<fs_allocvaluesnum>) WHERE value_from > 0.
              CASE <fs_allocvaluesnum>-charact.
                WHEN 'YGV_QTD_KG'.
                  <fs_data>-QuantidadeKg = <fs_allocvaluesnum>-value_from.
                WHEN 'YGV_QTD_SACAS'.
                  <fs_data>-QuantidadeSacas = <fs_allocvaluesnum>-value_from.
                WHEN 'YGV_QTD_BAG'.
                  <fs_data>-QuantidadeBag = <fs_allocvaluesnum>-value_from.
                WHEN 'YGV_P10'.
                  <fs_data>-Peneira10 = <fs_allocvaluesnum>-value_from.

                  IF <fs_data>-Peneira10 <> <fs_pedido>-Peneira10.
                    <fs_data>-Peneira10Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P11'.
                  <fs_data>-Peneira11 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira11 <> <fs_pedido>-Peneira11.
                    <fs_data>-Peneira11Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P12'.
                  <fs_data>-Peneira12 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira12 <> <fs_pedido>-Peneira12.
                    <fs_data>-Peneira12Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P13'.
                  <fs_data>-Peneira13 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira13 <> <fs_pedido>-Peneira13.
                    <fs_data>-Peneira13Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P14'.
                  <fs_data>-Peneira14 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira14 <> <fs_pedido>-Peneira14.
                    <fs_data>-Peneira14Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P15'.
                  <fs_data>-Peneira15 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira15 <> <fs_pedido>-Peneira15.
                    <fs_data>-Peneira15Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P16'.
                  <fs_data>-Peneira16 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira16 <> <fs_pedido>-Peneira16.
                    <fs_data>-Peneira16Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P17'.
                  <fs_data>-Peneira17 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira17 <> <fs_pedido>-Peneira17.
                    <fs_data>-Peneira17Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P18'.
                  <fs_data>-Peneira18 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira18 <> <fs_pedido>-Peneira18.
                    <fs_data>-Peneira18Criticality = 1.
                  ENDIF.

                WHEN 'YGV_P19'.
                  <fs_data>-Peneira19 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Peneira19 <> <fs_pedido>-Peneira19.
                    <fs_data>-Peneira19Criticality = 1.
                  ENDIF.

                WHEN 'YGV_DEFEITO'.
                  <fs_data>-Defeito = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Defeito <> <fs_pedido>-Defeito.
                    <fs_data>-DefeitoCriticality = <fs_allocvaluesnum>-value_from.
                  ENDIF.

                WHEN 'YGV_IMPUREZAS'.
                  <fs_data>-Impureza = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Impureza <> <fs_pedido>-Impureza.
                    <fs_data>-ImpurezaCriticality = 1.
                  ENDIF.

                WHEN 'YGV_FUNDO'.
                  <fs_data>-Fundo = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Fundo <> <fs_pedido>-Fundo.
                    <fs_data>-FundoCriticality = 1.
                  ENDIF.

                WHEN 'YGV_VERDE'.
                  <fs_data>-Verde = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Verde <> <fs_pedido>-Verde.
                    <fs_data>-VerdeCriticality = 1.
                  ENDIF.

                WHEN 'YGV_PRETO-ARDIDO'.
                  <fs_data>-PretoArdido = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-PretoArdido <> <fs_pedido>-PretoArdido.
                    <fs_data>-PretoArdidoCriticality = 1.
                  ENDIF.

                WHEN 'YGV_CATACAO'.
                  <fs_data>-Catacao = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Catacao <> <fs_pedido>-Catacao.
                    <fs_data>-CatacaoCriticality = 1.
                  ENDIF.

                WHEN 'YGV_UMIDADE'.
                  <fs_data>-Umidade = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Umidade <> <fs_pedido>-Umidade.
                    <fs_data>-UmidadeCriticality = 1.
                  ENDIF.

                WHEN 'YGV_MK10'.
                  <fs_data>-Mk10 = <fs_allocvaluesnum>-value_from.
                  IF <fs_data>-Mk10 <> <fs_pedido>-Mk10.
                    <fs_data>-Mk10Criticality = 1.
                  ENDIF.

                WHEN 'YGV_BROCADOS'.
                  <fs_data>-Brocado = <fs_allocvaluesnum>-value_from.
                 IF <fs_data>-Brocado <> <fs_pedido>-Brocado.
                    <fs_data>-BrocadoCriticality = 1.
                  ENDIF.

                WHEN OTHERS.
                  CONTINUE.
              ENDCASE.
            ENDLOOP.

        ENDLOOP.

    ENDIF.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
