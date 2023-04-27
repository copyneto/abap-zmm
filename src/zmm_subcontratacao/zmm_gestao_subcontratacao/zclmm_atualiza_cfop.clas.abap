class ZCLMM_ATUALIZA_CFOP definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCLMM_ATUALIZA_CFOP .
  methods UPDATE_CFOP
    returning
      value(RV_CFOP) type /XNFE/CFOP .
  methods SAVE_GUID16
    importing
      !IV_ACCESS type /XNFE/ID .
  methods UPDATE_CFOP_SC
    changing
      !CT_ITEM type /XNFE/ERP_IN_ITEM_T .
  methods UPDATE_CHARG
    importing
      !IV_VGBEL type VGBEL
    changing
      !CT_COMPONENT type LECOMP_CONSUMPTION_T .
  methods SAVE_GUID_HEADER
    importing
      !IV_GUID_HEADER type /XNFE/GUID_16 .
protected section.
private section.

  types:
    BEGIN OF ty_jflin,
      docnum TYPE j_1bdocnum,
      matnr  TYPE matnr,
    END OF ty_jflin .

  class-data GO_INSTANCE type ref to ZCLMM_ATUALIZA_CFOP .
  data GS_MSEG type MSEG .
  data GV_GUID_HEADER type /XNFE/GUID_16 .
  data GV_ACCESS type /XNFE/ID .
ENDCLASS.



CLASS ZCLMM_ATUALIZA_CFOP IMPLEMENTATION.


  METHOD get_instance.

    go_instance = COND #( WHEN go_instance IS NOT INITIAL
                      THEN go_instance
                      ELSE NEW zclmm_atualiza_cfop( ) ).

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD save_guid16.

    gv_access = iv_access.

  ENDMETHOD.


  method SAVE_GUID_HEADER.

    gv_guid_header = iv_guid_header.

  endmethod.


  METHOD update_cfop.

    "Valida se tem chave de acesso
    CHECK gv_access IS NOT INITIAL.

    "Obtem o Guid Header
    SELECT guid_header
     UP TO 1 ROWS
     FROM /xnfe/innfehd
     INTO @DATA(lv_guid_header)
     WHERE nfeid = @gv_access
      .
    ENDSELECT.
    IF  sy-subrc IS INITIAL.

      "Busca CFOP
      SELECT cfop
        UP TO 1 ROWS
        FROM /xnfe/innfeit
        INTO @DATA(lv_cfop)
        WHERE guid_header = @lv_guid_header
        AND   itemtype   = @gc_itemtype.
        .
      ENDSELECT.
      IF sy-subrc IS INITIAL.

        "Altera para CFOP correto
        IF lv_cfop(4) = '6902'.
          lv_cfop = '2902AA'.
        ELSEIF lv_cfop(4) = '5902'.
          lv_cfop = '1902AA'.
        ENDIF.
        CLEAR gv_access.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD update_cfop_sc.

    IF gv_guid_header IS NOT INITIAL.

      "Busca CFOP
      SELECT nitem, ncm, cfop, qcom
        FROM /xnfe/innfeit
        INTO TABLE @DATA(lt_innfeit)
        WHERE guid_header = @gv_guid_header
        AND   itemtype    = @gc_itemtype.
      .
      IF sy-subrc IS INITIAL.

        SORT lt_innfeit BY nitem ncm qcom.

        LOOP AT ct_item ASSIGNING FIELD-SYMBOL(<fs_item>).

          READ TABLE lt_innfeit INTO DATA(ls_innfeit) WITH KEY nitem = <fs_item>-nitem
                                                               ncm   = <fs_item>-ncm
                                                               qcom  = <fs_item>-qtrib
                                                               BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            "Altera para CFOP correto
            IF ls_innfeit-cfop(4) = '6902'.
              <fs_item>-cfop = '2902AA'.
            ELSEIF ls_innfeit-cfop(4) = '5902'.
              <fs_item>-cfop  = '1902AA'.
            ENDIF.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update_charg.

    IF iv_vgbel IS NOT INITIAL AND ct_component[] IS NOT INITIAL.

      SELECT matnr, charg
        FROM lips
        INTO TABLE @DATA(lt_lips)
        FOR ALL ENTRIES IN @ct_component
        WHERE vgbel = @iv_vgbel
          AND matnr = @ct_component-matnr
          AND bwart = '541'
         .

      IF sy-subrc IS INITIAL.

        SORT lt_lips BY matnr.

        LOOP AT ct_component ASSIGNING FIELD-SYMBOL(<fs_component>).

          READ TABLE lt_lips  INTO DATA(ls_lips) WITH KEY matnr = <fs_component>-matnr
                                                  BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            <fs_component>-charg = ls_lips-charg. "Atualiza Lote
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
