CLASS zcl_im_mmei0023 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_le_shp_delivery_proc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_IM_MMEI0023 IMPLEMENTATION.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_header.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_item.

* Consistência para não alterar qtdes. de remessa criada pelo Cockpit de Subcontratação
    IF cs_likp-lfart EQ 'LB' AND "Remessa para Subcontratação
       cs_likp-berot   = 'SUBCONTR.'. "Processo do Cockpit

      IF cs_lips-bwart EQ '941' OR cs_lips-bwart EQ '541' OR "Subcontratação
         cs_lips-bwart EQ 'Y41' OR  "Armazenagem
         cs_lips-bwart EQ 'Y51' OR  "Grão Verde
         cs_lips-bwart EQ 'Z41' . "S/ NF

        READ TABLE it_xlips INTO DATA(ls_lips) WITH KEY vbeln = cs_lips-vbeln
                                                        posnr = cs_lips-posnr.
        IF sy-subrc EQ 0.
          IF cs_lipsd-pikmg <> ls_lips-lfimg OR
             cs_lips-lfimg <> ls_lips-lfimg.
            MESSAGE w000(zmm) WITH 'Qtdes.não podem ser alteradas'
                                   '(Cokckipt de Subcontração)'.
          ENDIF.
          cs_lipsd-pikmg = ls_lips-lfimg.
          cs_lips-lfimg = ls_lips-lfimg.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_fcode_attributes.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_field_attributes.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~check_item_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_deletion.
*Deletar tabela de histórico do Cokpit Subcontratação - Expedição Insumos
    IF is_likp-lfart EQ 'LB'. "Subcobtratação
      SELECT SINGLE * FROM ztmm_sbct_pickin
      INTO @DATA(ls_sbct_pickin)
      WHERE vbeln = @is_likp-vbeln.
      IF sy-subrc EQ 0.
        DELETE FROM ztmm_sbct_pickin WHERE vbeln = is_likp-vbeln.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_final_check.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~document_number_publish.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_header.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~initialize_delivery.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~item_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~publish_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~read_delivery.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_before_output.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_document.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_document_prepare.

    DATA: ls_xlips LIKE LINE OF ct_xlips,
          lv_pstyp TYPE ekpo-pstyp,
          ls_ekpa  TYPE ekpa,
          ls_xvbpa LIKE LINE OF ct_xvbpa,
          lv_tabix LIKE sy-tabix.

    ASSIGN ('(SAPLZFGMM_GN_DELIVERY_CREATE)gv_txsdc') TO FIELD-SYMBOL(<fs_txsdc>).
    ASSIGN ('(SAPLZFGMM_GN_DELIVERY_CREATE)Gv_J_1BTAXLW1') TO FIELD-SYMBOL(<fs_J_1BTAXLW1>).

    LOOP AT ct_xlips INTO ls_xlips.

      SELECT SINGLE pstyp INTO lv_pstyp
      FROM ekpo
      WHERE ebeln = ls_xlips-vgbel AND
            ebelp = ls_xlips-vgpos.
* Para Inbound Delivery de Transferência entre Plantas, o movimento deve ser 861.
      IF lv_pstyp = '7' AND ls_xlips-pstyv = 'ELN'. "Inbound de Transferência entre Plantas (SPED message)
        ls_xlips-bwart = '861'.
*        ls_xlips-j_1btxsdc = '**'. "Iva SD p/ TRANSFER
        MODIFY ct_xlips FROM ls_xlips.
      ENDIF.

* Comentado por Willian Hazor a pedido do Alcides para que seja utilizada o configuração standar para determinação - 23.06.2022
* Para subcontratação o IVA deve ser 'SB'.
*      IF ls_xlips-bwart EQ '941' OR
*         ls_xlips-bwart EQ '541' OR
*         ls_xlips-bwart EQ 'Y51' OR
*         ls_xlips-bwart EQ 'Y41'.
*        ls_xlips-j_1btxsdc = 'SB'.
*        MODIFY ct_xlips FROM ls_xlips.
*      ENDIF.

*      IF ls_xlips-bwart EQ '541'.
*        ls_xlips-j_1btxsdc = 'Z1'.
*        MODIFY ct_xlips FROM ls_xlips.
*      ENDIF.
* Comentado por Willian Hazor a pedido do Alcides para que seja utilizada o configuração standar para determinação.

      IF <fs_txsdc> IS ASSIGNED.
        IF <fs_txsdc> IS NOT INITIAL.
          ls_xlips-j_1btxsdc = <fs_txsdc>.
          ls_xlips-j_1btaxlw1 = <fs_J_1BTAXLW1>.
          MODIFY ct_xlips FROM ls_xlips.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
