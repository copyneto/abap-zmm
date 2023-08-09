"! <p class="shorttext synchronized">Classe Formulário para Emissão do Pedido de Compras </p>
"! Autor: Anderson Macedo
"! Data: 11/02/2022
class ZCLMM_FORM_PED_COMPRA definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IS_NAST type NAST
      !IV_RETCO type SYST_SUBRC
      !IS_TNAPR type TNAPR .

   "! Chama o processo principal
   "! @parameter rv_retco        |Retorno
  methods EXECUTE
    returning
      value(RV_RETCO) type SYST_SUBRC .
protected section.
private section.

  types:
    BEGIN OF ty_plant,
      supplier       TYPE  char1,
      customer       TYPE  char1,
      plant          TYPE  i_plant-plant,
      addressid      TYPE  i_plant-addressid,
      partner        TYPE  i_plant-plantcustomer,
      partneraddress TYPE  i_customer-addressid,
      name           TYPE  i_customer-customername,
      fullname       TYPE  i_customer-customerfullname,
      cityname       TYPE  i_customer-cityname,
      postalcode     TYPE  i_customer-postalcode,
      streetname     TYPE  i_customer-streetname,
      region         TYPE  i_customer-region,
      country        TYPE  i_customer-country,
      taxnumber1     TYPE  i_customer-taxnumber1,
      taxnumber2     TYPE  i_customer-taxnumber2,
      taxnumber3     TYPE  i_customer-taxnumber3,
      taxnumber4     TYPE  i_customer-taxnumber4,
      taxnumber5     TYPE  i_customer-taxnumber5,
      taxnumber6     TYPE  i_customer-taxnumber6,
      telnumber      TYPE  i_customer-telephonenumber1,
      faxnumber      TYPE  i_customer-faxnumber,
    END OF ty_plant .
  types:
    BEGIN OF ty_supplier,
      supplier   TYPE i_supplier-supplier,
      addressid  TYPE i_supplier-addressid,
      name       TYPE i_supplier-suppliername,
      fullname   TYPE i_supplier-supplierfullname,
      cityname   TYPE i_supplier-cityname,
      postalcode TYPE i_supplier-postalcode,
      streetname TYPE i_supplier-streetname,
      region     TYPE i_supplier-region,
      country    TYPE i_supplier-country,
      taxnumber1 TYPE i_supplier-taxnumber1,
      taxnumber2 TYPE i_supplier-taxnumber2,
      taxnumber3 TYPE i_supplier-taxnumber3,
      taxnumber4 TYPE i_supplier-taxnumber4,
      taxnumber5 TYPE i_supplier-taxnumber5,
      taxnumber6 TYPE i_supplier-taxnumber6,
      telnumber  TYPE i_supplier-phonenumber1,
      faxnumber  TYPE i_supplier-faxnumber,
      district   TYPE lfa1-ort02,
      language   TYPE i_supplier-supplierlanguage,
    END OF ty_supplier .
  types:
    BEGIN OF ty_delivery,
      name1       TYPE i_address-businesspartnername1,
      name2       TYPE i_address-businesspartnername2,
      cityname    TYPE i_address-cityname,
      postalcode  TYPE i_address-postalcode,
      streetname  TYPE i_address-streetname,
      housenumber TYPE i_address-housenumber,
      region      TYPE i_address-region,
      country     TYPE i_address-country,
      telnumber   TYPE i_address-phonenumber,
      faxnumber   TYPE i_address-faxnumber,
      district    TYPE i_address-district,
    END OF ty_delivery .
  types:
    ty_t_plant TYPE TABLE OF ty_plant WITH DEFAULT KEY .

  data GT_PLANT type TY_T_PLANT .
  data GS_NAST type NAST .
  data GS_SUPPLIER type TY_SUPPLIER .
  data GS_DOC type MEEIN_PURCHASE_DOC_PRINT .
  data GS_DELIVERY type TY_DELIVERY .
  data GS_ITEM type EKPO .
  data GS_PLANT type TY_PLANT .
  data GS_EMPRESA type ZSMM_PEDIDO_COMPRA .
  data GS_HEADER type THEAD .
  data GS_TNAPR type TNAPR .
  data GS_COMPOP type SSFCOMPOP .
  data GS_CTRLOP type SSFCTRLOP .
  data GV_ENT_RETCO type SYST_SUBRC .
  data GV_CNPJ_ENTREGA type I_CUSTOMER-TAXNUMBER1 .
  data GV_FUNCTION type RS38L_FNAM .
  data GV_USER_SETTINGS type CHAR1 .
   "! Chama o Form
  methods CALL_FORM .
   "! Busca função do smartform
  methods GET_FUNCTION .
   "! Parâmetros do smartform
  methods SF_PARAMETERS .
   "! Smartform
  methods SMARTFORM .
   "! Busca elemento de texto
   "! parameter cs_header | Cabeçalho
   "! parameter rt_obs    | Texto
  methods GET_TEXT
    changing
      !CS_HEADER type THEAD
    returning
      value(RT_OBS) type TLINE_T .
   "! Monta dados do smartform
  methods BUILD_SF_DATA .
   "! Busca dados da entrega
  methods GET_DELIVERY_DATA .
   "! Busca dados do fornecedor
  methods GET_SUPPLIER_DATA .
   "! Dados do documento
   "! parameter rv_return       | Retorno
  methods DOC_DATA_IS_VALID
    returning
      value(RV_RETURN) type ABAP_BOOL .
   "! Busca dados do documento
  methods GET_DOC_DATA .
   "! Busca dados da filial
  methods GET_PLANT_DATA .
ENDCLASS.



CLASS ZCLMM_FORM_PED_COMPRA IMPLEMENTATION.


  METHOD build_sf_data.

    CONSTANTS: lc_ekko TYPE string VALUE 'EKKO',
               lc_f01  TYPE string VALUE 'F01',
               lc_text TYPE string VALUE 'TEXT',
               lc_name TYPE string VALUE 'ZMM_INFO_GERAIS',
               lc_st   TYPE string VALUE 'ST'.

    gs_header = VALUE thead(
        tdobject   = lc_text
        tdname     = lc_name
        tdid       = lc_st
        tdspras    = sy-langu ).

    DATA(lt_info) = get_text( CHANGING cs_header = gs_header ).

    gs_empresa = VALUE zsmm_pedido_compra(

        cabecalho       = VALUE #( name1      = gs_plant-name
                                   name2      = COND #( WHEN strlen( gs_plant-name ) GT 40 THEN gs_plant-name+40 )
                                   city1      = gs_plant-cityname
                                   post_code1 = gs_plant-postalcode
                                   street     = gs_plant-streetname
                                   country    = gs_plant-country
                                   region     = gs_plant-region
                                   tel_number = gs_plant-telnumber
                                   fax_number = gs_plant-faxnumber )

        fornecedor      = VALUE #( name1      = gs_supplier-name
                                   name2      = COND #( WHEN strlen( gs_supplier-name ) GT 40 THEN gs_supplier-name+40 )
                                   city1      = gs_supplier-cityname
                                   city2      = gs_supplier-district
                                   post_code1 = gs_supplier-postalcode
                                   street     = gs_supplier-streetname
                                   country    = gs_supplier-country
                                   region     = gs_supplier-region
                                   tel_number = gs_supplier-telnumber
                                   fax_number = gs_supplier-faxnumber )

        kna1            = VALUE #( stcd1      = gs_plant-taxnumber1
                                   stcd2      = gs_plant-taxnumber2
                                   stcd3      = gs_plant-taxnumber3
                                   stcd4      = gs_plant-taxnumber4
                                   stcd5      = gs_plant-taxnumber5
                                   stcd6      = gs_plant-taxnumber6 )

        entrega         = VALUE #( name1      = gs_delivery-name1
                                   name2      = gs_delivery-name2
                                   city1      = gs_delivery-cityname
                                   city2      = gs_delivery-district
                                   post_code1 = gs_delivery-postalcode
                                   street     = gs_delivery-streetname
                                   house_num1 = gs_delivery-housenumber
                                   country    = gs_delivery-country
                                   region     = gs_delivery-region
                                   tel_number = gs_delivery-telnumber
                                   fax_number = gs_delivery-faxnumber )

        cnpj_entrega    = gv_cnpj_entrega
        cnpj_fornecedor = gs_supplier-taxnumber1
        ie_fornecedor   = gs_supplier-taxnumber3
        inf_gerais      = lt_info
    ).

    SELECT SINGLE city2 FROM adrc
      INTO @gs_empresa-cabecalho-city2
      WHERE addrnumber = @gs_plant-partneraddress.

    gs_header = VALUE thead(
        tdobject   = lc_ekko
        tdname     = gs_doc-xekko-ebeln
        tdid       = lc_f01
        tdspras    = sy-langu
    ).

    gs_empresa-obs = get_text( CHANGING cs_header = gs_header ).

    SORT gs_doc-xtkomv BY kposn kschl.

  ENDMETHOD.


  METHOD call_form.

    DATA(ls_return) = VALUE ssfcrescl( ).

    CALL FUNCTION gv_function
      EXPORTING
        control_parameters = gs_ctrlop
        output_options     = gs_compop
        user_settings      = gv_user_settings
        is_empresa         = gs_empresa
        is_pedido          = gs_doc
      IMPORTING
        job_output_info    = ls_return
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      CLEAR ls_return.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    gs_nast       = is_nast.
    gs_tnapr      = is_tnapr.
    gv_ent_retco  = iv_retco.

  ENDMETHOD.


  METHOD doc_data_is_valid.

    IF gv_ent_retco EQ 0.
      rv_return = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD execute.
    get_doc_data( ).

    IF doc_data_is_valid( ).

      get_plant_data( ).
      get_supplier_data( ).
      get_delivery_data( ).
      build_sf_data( ).
      smartform( ).

    ENDIF.

    rv_retco = gv_ent_retco.

  ENDMETHOD.


  METHOD get_delivery_data.

    IF gs_plant-customer EQ abap_true.
      gv_cnpj_entrega = gs_plant-taxnumber1.
    ENDIF.

    IF gs_item-adrn2 IS NOT INITIAL.

      DATA(lv_addressid) = gs_item-adrn2.

    ELSEIF gs_item-emlif IS NOT INITIAL.

      SELECT SINGLE FROM i_supplier
             FIELDS addressid,
                    taxnumber1
             WHERE supplier EQ @gs_item-emlif
        INTO ( @lv_addressid, @gv_cnpj_entrega ).

    ELSE.

      lv_addressid = gs_plant-addressid.

    ENDIF.

    SELECT SINGLE FROM i_address WITH PRIVILEGED ACCESS
           FIELDS businesspartnername1 AS name1,
                  businesspartnername2 AS name2,
                  cityname             AS cityname,
                  postalcode           AS postalcode,
                  streetname           AS streetname,
                  housenumber          AS housenumber,
                  region               AS region,
                  country              AS country,
                  phonenumber          AS telnumber,
                  faxnumber            AS faxnumber,
                  district             AS district
      WHERE addressid EQ @lv_addressid
      INTO @gs_delivery.

  ENDMETHOD.


  METHOD get_doc_data.

    CONSTANTS: lc_novo      TYPE druvo VALUE '1',
               lc_modificar TYPE druvo VALUE '2'.

    CLEAR gv_ent_retco.

    DATA(lv_druvo) = COND druvo( WHEN gs_nast-aende EQ space THEN lc_novo ELSE lc_modificar ).

    CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
      EXPORTING
        ix_nast   = gs_nast
        ix_screen = gv_ent_retco
      IMPORTING
        ex_retco  = gv_ent_retco
        doc       = gs_doc
      CHANGING
        cx_druvo  = lv_druvo.


    IF gs_doc-xtkomv IS INITIAL.
      SELECT * FROM prcd_elements INTO TABLE @DATA(lt_xkomv) WHERE knumv = @gs_doc-xekko-knumv. "#EC CI_ALL_FIELDS_NEEDED
      gs_doc-xtkomv = CORRESPONDING #( lt_xkomv ).
      LOOP AT gs_doc-xtkomv ASSIGNING FIELD-SYMBOL(<fs_xtkomv>).
        IF <fs_xtkomv>-KRECH = 'A'.
          <fs_xtkomv>-kbetr = <fs_xtkomv>-kbetr * 10.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_function.

*    gs_tnapr-sform = 'ZSFMM_PEDIDO_COMPRA_V3'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = gs_tnapr-sform
      IMPORTING
        fm_name            = gv_function
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD get_plant_data.

    READ TABLE gs_doc-xekpo ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX 1.
    IF sy-subrc = 0.

      SELECT FROM i_plant AS _plant
             FIELDS ' '                         AS supplier,
                    'X'                         AS customer,
                    plant                       AS plant,
                    addressid                   AS addressid,
                    plantcustomer               AS partner,
                    \_customer-addressid        AS partneraddress,
                    \_customer-customername     AS name,
                    \_customer-customerfullname AS fullname,
                    \_customer-cityname         AS cityname,
                    \_customer-postalcode       AS postalcode,
                    \_customer-streetname       AS streetname,
                    \_customer-region           AS region,
                    \_customer-country          AS country,
                    \_customer-taxnumber1       AS taxnumber1,
                    \_customer-taxnumber2       AS taxnumber2,
                    \_customer-taxnumber3       AS taxnumber3,
                    \_customer-taxnumber4       AS taxnumber4,
                    \_customer-taxnumber5       AS taxnumber5,
                    \_customer-taxnumber6       AS taxnumber6,
                    \_customer-telephonenumber1 AS telnumber,
                    \_customer-faxnumber        AS faxnumber
             WHERE plant EQ @<fs_item>-werks
      UNION
        SELECT FROM i_plant
               FIELDS 'X'                          AS supplier,
                      ' '                          AS customer,
                      plant                        AS plant,
                      addressid                    AS addressid,
                      plantsupplier                AS partner,
                      \_supplier-addressid         AS partneraddress,
                      \_supplier-suppliername      AS name,
                      \_supplier-supplierfullname  AS fullname,
                      \_supplier-cityname          AS cityname,
                      \_supplier-postalcode        AS postalcode,
                      \_supplier-streetname        AS streetname,
                      \_supplier-region            AS region,
                      \_supplier-country           AS country,
                      \_supplier-taxnumber1        AS taxnumber1,
                      \_supplier-taxnumber2        AS taxnumber2,
                      \_supplier-taxnumber3        AS taxnumber3,
                      \_supplier-taxnumber4        AS taxnumber4,
                      \_supplier-taxnumber5        AS taxnumber5,
                      \_supplier-taxnumber6        AS taxnumber6,
                      \_supplier-phonenumber1      AS telnumber,
                      \_supplier-faxnumber         AS faxnumber
               WHERE plant EQ @<fs_item>-werks
      ORDER BY supplier
      INTO TABLE @gt_plant.

      MOVE-CORRESPONDING <fs_item> TO gs_item.

    ENDIF.

  ENDMETHOD.


  METHOD get_supplier_data.

    READ TABLE gt_plant ASSIGNING FIELD-SYMBOL(<fs_plant>) INDEX 1.

    IF sy-subrc = 0.

      SELECT SINGLE FROM i_supplier
             INNER JOIN lfa1 ON lfa1~lifnr EQ i_supplier~supplier
             FIELDS supplier          AS supplier,
                    addressid         AS addressid,
                    suppliername      AS name,
                    supplierfullname  AS fullname,
                    cityname          AS cityname,
                    postalcode        AS postalcode,
                    streetname        AS streetname,
                    region            AS region,
                    country           AS country,
                    taxnumber1        AS taxnumber1,
                    taxnumber2        AS taxnumber2,
                    taxnumber3        AS taxnumber3,
                    taxnumber4        AS taxnumber4,
                    taxnumber5        AS taxnumber5,
                    taxnumber6        AS taxnumber6,
                    phonenumber1      AS telnumber,
                    faxnumber         AS faxnumber,
                    ort02             AS district,
                    supplierlanguage  AS language
             WHERE supplier EQ @gs_doc-xekko-lifnr
             INTO @gs_supplier.

      gs_plant = <fs_plant>.

    ENDIF.

  ENDMETHOD.


  METHOD get_text.

    DATA: lt_obs      TYPE tline_t,
          lt_text     TYPE STANDARD TABLE OF string,
          lt_out_text TYPE STANDARD TABLE OF string.

    DATA: ls_obs TYPE tline.

    DATA: lv_text TYPE string.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = cs_header-tdid
        language                = cs_header-tdspras
        name                    = cs_header-tdname
        object                  = cs_header-tdobject
      IMPORTING
        header                  = cs_header
      TABLES
        lines                   = lt_obs
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.
      FREE rt_obs.
    ELSE.

      FREE: lt_text[].

      LOOP AT lt_obs ASSIGNING FIELD-SYMBOL(<fs_obs>).

        IF <fs_obs>-tdformat EQ '*'.

          IF lt_text[] IS NOT INITIAL.

            FREE: lt_out_text[].
            CALL FUNCTION 'ZFMCA_TABLE_FIXEDLENGTH'
              EXPORTING
                iv_tablelength = 132
              TABLES
                it_input       = lt_text
                et_output      = lt_out_text
              EXCEPTIONS
                no_data_found  = 1
                OTHERS         = 2.

            IF sy-subrc IS INITIAL.

              LOOP AT lt_out_text ASSIGNING FIELD-SYMBOL(<fs_out_text>).

                IF sy-tabix EQ 1.
                  ls_obs-tdformat = '*'.
                ELSE.
                  ls_obs-tdformat = ''.
                ENDIF.

                ls_obs-tdline = <fs_out_text>.
                APPEND ls_obs TO rt_obs.
                CLEAR ls_obs.

              ENDLOOP.
            ENDIF.

            FREE: lt_text[],
                  lt_out_text[].

            APPEND <fs_obs>-tdline TO lt_text.

          ELSE.

            APPEND <fs_obs>-tdline TO lt_text.

          ENDIF.
        ELSE.

          APPEND <fs_obs>-tdline TO lt_text.

        ENDIF.

      ENDLOOP.

      IF lt_text[] IS NOT INITIAL.

        FREE: lt_out_text[].
        CALL FUNCTION 'ZFMCA_TABLE_FIXEDLENGTH'
          EXPORTING
            iv_tablelength = 132
          TABLES
            it_input       = lt_text
            et_output      = lt_out_text
          EXCEPTIONS
            no_data_found  = 1
            OTHERS         = 2.

        IF sy-subrc IS INITIAL.

          LOOP AT lt_out_text ASSIGNING <fs_out_text>.

            IF sy-tabix EQ 1.
              ls_obs-tdformat = '*'.
            ELSE.
              ls_obs-tdformat = ''.
            ENDIF.

            ls_obs-tdline = <fs_out_text>.
            APPEND ls_obs TO rt_obs.
            CLEAR ls_obs.

          ENDLOOP.

          FREE: lt_text[].

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD sf_parameters.

    CONSTANTS: lc_pdf  TYPE string VALUE 'PDF'.

    gs_compop = VALUE ssfcompop( tdimmed = gs_nast-dimme
                                 tddest  = gs_nast-ldest ).

    gs_ctrlop = VALUE ssfctrlop( langu     = gs_supplier-language
                                 no_dialog = abap_true
                                 preview   = COND #( WHEN sy-ucomm EQ 'VIEW' OR sy-ucomm EQ 'PREVOUTPUT' OR sy-xcode EQ '9ANZ' THEN abap_true )
                                 getotf    = COND #( WHEN sy-ucomm EQ lc_pdf OR
                                                            ( gs_nast-kschl EQ 'ZNEU' AND gs_nast-nacha EQ '5' AND sy-xcode NE '9ANZ' ) OR
                                                            ( gs_nast-kschl EQ 'ZNEU' AND gs_nast-nacha EQ '5' AND gs_nast-vsztp EQ '4' ) THEN abap_true ) ).

    gv_user_settings = COND char1( WHEN gs_ctrlop-preview EQ abap_true AND sy-tcode IS NOT INITIAL
                                   THEN abap_true ELSE abap_false ).

  ENDMETHOD.


  METHOD smartform.

    get_function( ).
    sf_parameters( ).
    call_form( ).

  ENDMETHOD.
ENDCLASS.
