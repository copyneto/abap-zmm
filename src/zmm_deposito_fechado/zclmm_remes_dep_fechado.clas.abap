class ZCLMM_REMES_DEP_FECHADO definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_DELIVERY_PROC .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_REMES_DEP_FECHADO IMPLEMENTATION.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_fcode_attributes.
    RETURN.
  ENDMETHOD.


  method IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_FIELD_ATTRIBUTES.
    RETURN.
  endmethod.


  method IF_EX_LE_SHP_DELIVERY_PROC~CHECK_ITEM_DELETION.
    RETURN.
  endmethod.


  METHOD if_ex_le_shp_delivery_proc~delivery_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_final_check.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~document_number_publish.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_header.

    DATA: lv_guid TYPE sysuuid_x16.

    IMPORT lv_guid TO lv_guid FROM MEMORY ID 'MM_REMESTRP'.
    " IMPORT da classe ZCLMM_ADM_EMISSAO_NF_EVENTS~CREATE_OUT_DELIVERY

    IF lv_guid IS NOT INITIAL.

      SELECT guid,
             shipping_type,
             freight_mode,
             equipment,
             shipping_conditions
        FROM ztmm_his_dep_fec
       WHERE guid = @lv_guid
        INTO @DATA(ls_hist)
        UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.

        cs_likp-vsart = ls_hist-shipping_type.
        cs_likp-inco1 = ls_hist-freight_mode.
        cs_likp-inco2 = ls_hist-freight_mode.
        cs_likp-traid = ls_hist-equipment.
        cs_likp-vsbed = ls_hist-shipping_conditions.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_item.
    RETURN.
  ENDMETHOD.


  method IF_EX_LE_SHP_DELIVERY_PROC~INITIALIZE_DELIVERY.
    RETURN.
  endmethod.


  METHOD if_ex_le_shp_delivery_proc~item_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~publish_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~read_delivery.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_before_output.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_document.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_document_prepare.

    DATA: lv_guid TYPE sysuuid_x16.

    IMPORT lv_guid TO lv_guid FROM MEMORY ID 'MM_REMESTRP'.
    " IMPORT da classe ZCLMM_ADM_EMISSAO_NF_EVENTS~CREATE_OUT_DELIVERY

    IF lv_guid IS NOT INITIAL.

      SELECT guid,
             carrier,
             driver
        FROM ztmm_his_dep_fec
       WHERE guid = @lv_guid
        INTO @DATA(ls_hist)
        UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.

        READ TABLE ct_xvbpa ASSIGNING FIELD-SYMBOL(<fs_xvbpa>) INDEX 1.
        IF sy-subrc IS INITIAL.
          DATA(ls_xvbpa) = <fs_xvbpa>.
        ELSE.
          ls_xvbpa-mandt = sy-mandt.
          ls_xvbpa-vbeln = '$       1'.
        ENDIF.

        SELECT SINGLE lifnr,
                      land1,
                      adrnr
          FROM lfa1
         WHERE lifnr = @ls_hist-carrier
          INTO @DATA(ls_lfa1).

        IF sy-subrc IS INITIAL.
          ct_xvbpa = VALUE #( BASE ct_xvbpa ( mandt = ls_xvbpa-mandt
                                              vbeln = ls_xvbpa-vbeln
                                              posnr = ls_xvbpa-posnr
                                              parvw = 'SC'
                                              lifnr = ls_lfa1-lifnr
                                              adrnr = ls_lfa1-adrnr
                                              land1 = ls_lfa1-land1
                                              updkz = 'I' ) ).
        ENDIF.

        SELECT partner,
               idnumber
          FROM but0id
         WHERE partner = @ls_hist-driver
           AND type    = 'HCM001'
          INTO @DATA(lt_but0id)
          UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc IS INITIAL.
          ct_xvbpa = VALUE #( BASE ct_xvbpa ( mandt = ls_xvbpa-mandt
                                              vbeln = ls_xvbpa-vbeln
                                              posnr = ls_xvbpa-posnr
                                              parvw = 'YM'
                                              pernr = lt_but0id-idnumber
                                              updkz = 'I' ) ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
