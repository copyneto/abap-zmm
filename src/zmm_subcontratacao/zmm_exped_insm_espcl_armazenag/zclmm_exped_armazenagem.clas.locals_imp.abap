CLASS lcl_armazenagem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ armazenagem RESULT result.

    METHODS expedicao FOR MODIFY
      IMPORTING keys FOR ACTION armazenagem~expedicao.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR armazenagem RESULT result.

ENDCLASS.

CLASS lcl_armazenagem IMPLEMENTATION.

  METHOD read.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD expedicao.

    CONSTANTS: lc_sem_frete TYPE inco1 VALUE 'SFR'.

    DATA: lt_keys TYPE STANDARD TABLE OF zsmm_armaz_key.

    DATA(lo_object) = NEW zclmm_exped_espc_armazgm( ).

    DATA(ls_keys) = keys[ 1 ].

    DATA(ls_xml_trasnp) = VALUE zsmm_subc_xml_transp(
*      transptdr  = ls_keys-%param-transptdr
*      incoterms1 = ls_keys-%param-incoterms1
*      incoterms2 = ls_keys-%param-incoterms2
*      traid      = ls_keys-%param-traid
      incoterms1 = lc_sem_frete
      incoterms2 = lc_sem_frete
      txsdc      = ls_keys-%param-txsdc ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      lt_keys = VALUE #( BASE lt_keys ( docnum = <fs_keys>-docnum
                                                itmnum = <fs_keys>-itmnum
                                                LinAuxDocnum = <fs_keys>-LinAuxDocnum
                                                LinAuxItmnum = <fs_keys>-LinAuxItmnum
                                                ekpoEbeln = <fs_keys>-ekpoEbeln
                                                ekpoEbelp = <fs_keys>-ekpoEbelp
                                                ActiveDocnum = <fs_keys>-ActiveDocnum
                                                ActiveTabdocnum = <fs_keys>-ActiveTabdocnum
                                                XNFEAuxguidHeader = <fs_keys>-XNFEAuxguidHeader
                                                XNFEguid = <fs_keys>-XNFEguid
                                                Vbeln = <fs_keys>-Vbeln
                                                Mblnr = <fs_keys>-Mblnr
                                                MsegMjahr = <fs_keys>-MsegMjahr
                                                MsegZeile = <fs_keys>-MsegZeile
                                                Concatmblnr = <fs_keys>-Concatmblnr
                                                Concatmjahr = <fs_keys>-Concatmjahr
                                                Concatzeile = <fs_keys>-Concatzeile
                                                FltrLindocnum = <fs_keys>-FltrLindocnum
                                                FltrLinitmnum = <fs_keys>-FltrLinitmnum
                                                DocDocnum = <fs_keys>-DocDocnum
                                                ActiveAuDocnum = <fs_keys>-ActiveAuDocnum
                                                FltLinDocnum = <fs_keys>-FltLinDocnum
                                                FltLinItmnum = <fs_keys>-FltLinItmnum
                                                Lfa1AuxLifnr = <fs_keys>-Lfa1AuxLifnr
                                                lfa1lifnr = <fs_keys>-lfa1lifnr
                                                Kna1AuxKunnr = <fs_keys>-Kna1AuxKunnr
                                                ekkoEbeln = <fs_keys>-ekkoEbeln
                                                maktMatnr = <fs_keys>-maktMatnr
                                                maktSpras = <fs_keys>-maktSpras
                                                BSDICAauart = <fs_keys>-BSDICAauart
                                                BSDICApstyv = <fs_keys>-BSDICApstyv
                                                URLDocnum = <fs_keys>-URLDocnum
                                                URLItmnum = <fs_keys>-URLItmnum
                                                T001wshwerks = <fs_keys>-T001wshwerks ) ).

    ENDLOOP.

    lo_object->expedicao( EXPORTING is_xml_trasnp = ls_xml_trasnp
                                    it_keys       = lt_keys
                          IMPORTING et_return     = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

      APPEND VALUE #(             docnum = ls_keys-docnum
                                                itmnum = ls_keys-itmnum
                                                LinAuxDocnum =  ls_keys-LinAuxDocnum
                                                LinAuxItmnum =  ls_keys-LinAuxItmnum
                                                ekpoEbeln =  ls_keys-ekpoEbeln
                                                ekpoEbelp =  ls_keys-ekpoEbelp
                                                ActiveDocnum =  ls_keys-ActiveDocnum
                                                ActiveTabdocnum =  ls_keys-ActiveTabdocnum
                                                XNFEAuxguidHeader =  ls_keys-XNFEAuxguidHeader
                                                XNFEguid =  ls_keys-XNFEguid
                                                Vbeln =  ls_keys-Vbeln
                                                Mblnr =  ls_keys-Mblnr
                                                MsegMjahr =  ls_keys-MsegMjahr
                                                MsegZeile =  ls_keys-MsegZeile
                                                Concatmblnr =  ls_keys-Concatmblnr
                                                Concatmjahr =  ls_keys-Concatmjahr
                                                Concatzeile =  ls_keys-Concatzeile
                                                FltrLindocnum =  ls_keys-FltrLindocnum
                                                FltrLinitmnum =  ls_keys-FltrLinitmnum
                                                DocDocnum =  ls_keys-DocDocnum
                                                ActiveAuDocnum =  ls_keys-ActiveAuDocnum
                                                FltLinDocnum =  ls_keys-FltLinDocnum
                                                FltLinItmnum =  ls_keys-FltLinItmnum
                                                Lfa1AuxLifnr =  ls_keys-Lfa1AuxLifnr
                                                lfa1lifnr =  ls_keys-lfa1lifnr
                                                Kna1AuxKunnr =  ls_keys-Kna1AuxKunnr
                                                ekkoEbeln =  ls_keys-ekkoEbeln
                                                maktMatnr =  ls_keys-maktMatnr
                                                maktSpras =  ls_keys-maktSpras
                                                BSDICAauart =  ls_keys-BSDICAauart
                                                BSDICApstyv =  ls_keys-BSDICApstyv
                                                URLDocnum =  ls_keys-URLDocnum
                                                URLItmnum =  ls_keys-URLItmnum
                      %msg  = new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4
                                           severity =  CONV #( <fs_return>-type ) ) ) TO reported-armazenagem.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    IF keys[] IS NOT INITIAL.

      SELECT                              Docnum,
                                                Itmnum,
                                                LinAuxDocnum,
                                                LinAuxItmnum,
                                                ekpoEbeln,
                                                ekpoEbelp,
                                                ActiveDocnum,
                                                ActiveTabdocnum,
                                                XNFEAuxguidHeader,
                                                XNFEguid,
                                                Vbeln,
                                                Mblnr,
                                                MsegMjahr,
                                                MsegZeile,
                                                Concatmblnr,
                                                Concatmjahr ,
                                                Concatzeile,
                                                FltrLindocnum,
                                                FltrLinitmnum,
                                                DocDocnum,
                                                ActiveAuDocnum,
                                                FltLinDocnum,
                                                FltLinItmnum,
                                                Lfa1AuxLifnr,
                                                lfa1lifnr,
                                                Kna1AuxKunnr,
                                                ekkoEbeln,
                                                maktMatnr,
                                                maktSpras,
                                                BSDICAauart,
                                                BSDICApstyv,
                                                URLDocnum,
                                                URLItmnum,
                                                T001wshwerks,
                                                Status
        FROM zi_mm_exped_armazenagem
         FOR ALL ENTRIES IN @keys
       WHERE Docnum = @keys-Docnum
         AND Itmnum = @keys-Itmnum
         AND LinAuxDocnum = @keys-LinAuxDocnum
        AND LinAuxItmnum = @keys-LinAuxItmnum
        AND ekpoEbeln = @keys-ekpoEbeln
        AND ekpoEbelp = @keys-ekpoEbelp
        AND ActiveDocnum = @keys-ActiveDocnum
        AND ActiveTabdocnum = @keys-ActiveTabdocnum
        AND XNFEAuxguidHeader = @keys-XNFEAuxguidHeader
        AND XNFEguid = @keys-XNFEguid
        AND Vbeln = @keys-Vbeln
        AND Mblnr = @keys-Mblnr
        AND MsegMjahr = @keys-MsegMjahr
        AND MsegZeile = @keys-MsegZeile
        AND Concatmblnr = @keys-Concatmblnr
        AND Concatmjahr = @keys-Concatmjahr
        AND Concatzeile = @keys-Concatzeile
        AND FltrLindocnum = @keys-FltrLindocnum
        AND FltrLinitmnum = @keys-FltrLinitmnum
        AND DocDocnum = @keys-DocDocnum
        AND ActiveAuDocnum = @keys-ActiveAuDocnum
        AND FltLinDocnum = @keys-FltLinDocnum
        AND FltLinItmnum = @keys-FltLinItmnum
        AND Lfa1AuxLifnr = @keys-Lfa1AuxLifnr
        AND lfa1lifnr = @keys-lfa1lifnr
        AND Kna1AuxKunnr = @keys-Kna1AuxKunnr
        AND ekkoEbeln = @keys-ekkoEbeln
        AND maktMatnr = @keys-maktMatnr
        AND maktSpras = @keys-maktSpras
        AND BSDICAauart = @keys-BSDICAauart
        AND BSDICApstyv = @keys-BSDICApstyv
        AND URLDocnum = @keys-URLDocnum
        AND URLItmnum = @keys-URLItmnum
        AND T001wshwerks = @keys-T001wshwerks
        INTO TABLE @DATA(lt_relat).

      IF sy-subrc IS INITIAL.
        SORT lt_relat BY                 docnum
                                                    itmnum
                                                    LinAuxDocnum
                                                    LinAuxItmnum
                                                    ekpoEbeln
                                                    ekpoEbelp
                                                    ActiveDocnum
                                                    ActiveTabdocnum
                                                    XNFEAuxguidHeader
                                                    XNFEguid
                                                    Vbeln
                                                    Mblnr
                                                    MsegMjahr
                                                    MsegZeile
                                                    Concatmblnr
                                                    Concatmjahr
                                                    Concatzeile
                                                    FltrLindocnum
                                                    FltrLinitmnum
                                                    DocDocnum
                                                    ActiveAuDocnum
                                                    FltLinDocnum
                                                    FltLinItmnum
                                                    Lfa1AuxLifnr
                                                    lfa1lifnr
                                                    Kna1AuxKunnr
                                                    ekkoEbeln
                                                    maktMatnr
                                                    maktSpras
                                                    BSDICAauart
                                                    BSDICApstyv
                                                    URLDocnum
                                                    URLItmnum
                                                    T001wshwerks .

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

          READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>) WITH KEY docnum = <fs_keys>-docnum
                                                                            itmnum = <fs_keys>-itmnum
                                                                            LinAuxDocnum = <fs_keys>-LinAuxDocnum
                                                                            LinAuxItmnum = <fs_keys>-LinAuxItmnum
                                                                            ekpoEbeln = <fs_keys>-ekpoEbeln
                                                                            ekpoEbelp = <fs_keys>-ekpoEbelp
                                                                            ActiveDocnum = <fs_keys>-ActiveDocnum
                                                                            ActiveTabdocnum = <fs_keys>-ActiveTabdocnum
                                                                            XNFEAuxguidHeader = <fs_keys>-XNFEAuxguidHeader
                                                                            XNFEguid = <fs_keys>-XNFEguid
                                                                            Vbeln = <fs_keys>-Vbeln
                                                                            Mblnr = <fs_keys>-Mblnr
                                                                            MsegMjahr = <fs_keys>-MsegMjahr
                                                                            MsegZeile = <fs_keys>-MsegZeile
                                                                            Concatmblnr = <fs_keys>-Concatmblnr
                                                                            Concatmjahr = <fs_keys>-Concatmjahr
                                                                            Concatzeile = <fs_keys>-Concatzeile
                                                                            FltrLindocnum = <fs_keys>-FltrLindocnum
                                                                            FltrLinitmnum = <fs_keys>-FltrLinitmnum
                                                                            DocDocnum = <fs_keys>-DocDocnum
                                                                            ActiveAuDocnum = <fs_keys>-ActiveAuDocnum
                                                                            FltLinDocnum = <fs_keys>-FltLinDocnum
                                                                            FltLinItmnum = <fs_keys>-FltLinItmnum
                                                                            Lfa1AuxLifnr = <fs_keys>-Lfa1AuxLifnr
                                                                            lfa1lifnr = <fs_keys>-lfa1lifnr
                                                                            Kna1AuxKunnr = <fs_keys>-Kna1AuxKunnr
                                                                            ekkoEbeln = <fs_keys>-ekkoEbeln
                                                                            maktMatnr = <fs_keys>-maktMatnr
                                                                            maktSpras = <fs_keys>-maktSpras
                                                                            BSDICAauart = <fs_keys>-BSDICAauart
                                                                            BSDICApstyv = <fs_keys>-BSDICApstyv
                                                                            URLDocnum = <fs_keys>-URLDocnum
                                                                            URLItmnum = <fs_keys>-URLItmnum
                                                                            T001wshwerks = <fs_keys>-T001wshwerks
                                                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_relat>-status = 'Pendente'.
              result = VALUE #( BASE result (
                                                Docnum = <fs_keys>-Docnum
                                                Itmnum = <fs_keys>-Itmnum
                                                LinAuxDocnum = <fs_keys>-LinAuxDocnum
                                                LinAuxItmnum = <fs_keys>-LinAuxItmnum
                                                ekpoEbeln = <fs_keys>-EkpoEbeln
                                                ekpoEbelp = <fs_keys>-EkpoEbelp
                                                ActiveDocnum = <fs_keys>-ActiveDocnum
                                                ActiveTabdocnum = <fs_keys>-ActiveTabdocnum
                                                XNFEAuxguidHeader = <fs_keys>-XNFEAuxguidHeader
                                                XNFEguid = <fs_keys>-XNFEguid
                                                Vbeln = <fs_keys>-Vbeln
                                                Mblnr = <fs_keys>-Mblnr
                                                MsegMjahr = <fs_keys>-MsegMjahr
                                                MsegZeile = <fs_keys>-MsegZeile
                                                Concatmblnr = <fs_keys>-Concatmblnr
                                                Concatmjahr = <fs_keys>-Concatmjahr
                                                Concatzeile = <fs_keys>-Concatzeile
                                                FltrLindocnum = <fs_keys>-FltrLindocnum
                                                FltrLinitmnum = <fs_keys>-FltrLinitmnum
                                                DocDocnum = <fs_keys>-DocDocnum
                                                ActiveAuDocnum = <fs_keys>-ActiveAuDocnum
                                                FltLinDocnum = <fs_keys>-FltLinDocnum
                                                FltLinItmnum = <fs_keys>-FltLinItmnum
                                                Lfa1AuxLifnr = <fs_keys>-Lfa1AuxLifnr
                                                lfa1lifnr = <fs_keys>-lfa1lifnr
                                                Kna1AuxKunnr = <fs_keys>-Kna1AuxKunnr
                                                ekkoEbeln = <fs_keys>-ekkoEbeln
                                                maktMatnr = <fs_keys>-maktMatnr
                                                maktSpras = <fs_keys>-maktSpras
                                                BSDICAauart = <fs_keys>-BSDICAauart
                                                BSDICApstyv = <fs_keys>-BSDICApstyv
                                                URLDocnum = <fs_keys>-URLDocnum
                                                URLItmnum = <fs_keys>-URLItmnum
                                                T001wshwerks = <fs_keys>-T001wshwerks
                                              %action-Expedicao = if_abap_behv=>fc-o-enabled ) ).
            ELSE.
              result = VALUE #( BASE result (
                                                Docnum = <fs_keys>-Docnum
                                                Itmnum = <fs_keys>-Itmnum
                                                LinAuxDocnum = <fs_keys>-LinAuxDocnum
                                                LinAuxItmnum = <fs_keys>-LinAuxItmnum
                                                ekpoEbeln = <fs_keys>-ekpoEbeln
                                                ekpoEbelp = <fs_keys>-ekpoEbelp
                                                ActiveDocnum = <fs_keys>-ActiveDocnum
                                                ActiveTabdocnum = <fs_keys>-ActiveTabdocnum
                                                XNFEAuxguidHeader = <fs_keys>-XNFEAuxguidHeader
                                                XNFEguid = <fs_keys>-XNFEguid
                                                Vbeln = <fs_keys>-Vbeln
                                                Mblnr = <fs_keys>-Mblnr
                                                MsegMjahr = <fs_keys>-MsegMjahr
                                                MsegZeile = <fs_keys>-MsegZeile
                                                Concatmblnr = <fs_keys>-Concatmblnr
                                                Concatmjahr = <fs_keys>-Concatmjahr
                                                Concatzeile = <fs_keys>-Concatzeile
                                                FltrLindocnum = <fs_keys>-FltrLindocnum
                                                FltrLinitmnum = <fs_keys>-FltrLinitmnum
                                                DocDocnum = <fs_keys>-DocDocnum
                                                ActiveAuDocnum = <fs_keys>-ActiveAuDocnum
                                                FltLinDocnum = <fs_keys>-FltLinDocnum
                                                FltLinItmnum = <fs_keys>-FltLinItmnum
                                                Lfa1AuxLifnr = <fs_keys>-Lfa1AuxLifnr
                                                lfa1lifnr = <fs_keys>-lfa1lifnr
                                                Kna1AuxKunnr = <fs_keys>-Kna1AuxKunnr
                                                ekkoEbeln = <fs_keys>-ekkoEbeln
                                                maktMatnr = <fs_keys>-maktMatnr
                                                maktSpras = <fs_keys>-maktSpras
                                                BSDICAauart = <fs_keys>-BSDICAauart
                                                BSDICApstyv = <fs_keys>-BSDICApstyv
                                                URLDocnum = <fs_keys>-URLDocnum
                                                URLItmnum = <fs_keys>-URLItmnum
                                                T001wshwerks = <fs_keys>-T001wshwerks
                                              %action-Expedicao = if_abap_behv=>fc-o-disabled ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_exped_armazenagem DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_exped_armazenagem IMPLEMENTATION.

  METHOD check_before_save.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD finalize.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
