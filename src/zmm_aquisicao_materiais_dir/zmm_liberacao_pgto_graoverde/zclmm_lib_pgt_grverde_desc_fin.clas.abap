CLASS zclmm_lib_pgt_grverde_desc_fin DEFINITION
  PUBLIC
  INHERITING FROM zclmm_libpg_grvde_disc
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zifmm_lib_pgto_graoverde_desc~build REDEFINITION .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:

      BEGIN OF gc_item,
        pmnt_block TYPE acpi_zlspr VALUE 'C',
        item_text  TYPE sgtxt VALUE 'DESCONTO NF',
      END OF gc_item,

      BEGIN OF gc_document,
        header_txt_fin TYPE bktxt VALUE 'DESCONTO FINANCEIRO',
        header_txt_com TYPE bktxt VALUE 'DESCONTO COMERCIAL',
        xref1_hd   TYPE xref1_hd VALUE 'DESCONTO-LIB-GV',
      END OF gc_document.
ENDCLASS.



CLASS ZCLMM_LIB_PGT_GRVERDE_DESC_FIN IMPLEMENTATION.


  METHOD zifmm_lib_pgto_graoverde_desc~build.

    super->zifmm_lib_pgto_graoverde_desc~build( iv_tipo = iv_tipo ).

    LOOP AT me->gt_properties ASSIGNING FIELD-SYMBOL(<fs_properties>).

* Cabeçalho
      gs_documentheader = VALUE #( pstng_date = sy-datum
                                     doc_date = sy-datum
                                     username = sy-uname
                                    fisc_year = substring( val = sy-datum len = 4 )
                                   fis_period = substring( val = sy-datum len = 2 off = 4 )
                                     doc_type = VALUE #( gt_tipodoc_rng[ 1 ]-low OPTIONAL )
                                    comp_code = <fs_properties>-Empresa
                                   "ref_doc_no = <fs_properties>-DocReferencia
                                   ref_doc_no = me->gv_nfenum
                                   header_txt = COND #( WHEN iv_tipo = 'F' THEN gc_document-header_txt_fin ELSE gc_document-header_txt_com )
                                     obj_type = 'BKPFF' ).

      CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
        IMPORTING
          own_logical_system = gs_documentheader-obj_sys.


      DO.

        CASE sy-index.
          WHEN 1.

            " Item 1
            gt_acctpayable = VALUE #( BASE gt_acctpayable ( itemno_acc = sy-index
                                                             comp_code = <fs_properties>-empresa
                                                             vendor_no = <fs_properties>-Fornecedor
                                                            pmnt_block = gc_item-pmnt_block
                                                            bline_date = <fs_properties>-dtvencimentoliquido
                                                         businessplace = <fs_properties>-LocalNegocio
*                                                             bus_area = s_fin_group-BusinessArea
*                                                           profit_ctr = s_fin_group-profitcenter
                                                             paymt_ref = <fs_properties>-numdocumento
                                                    part_businessplace = <fs_properties>-ano
                                                            ppa_ex_ind = <fs_properties>-item
                                                             item_text = |{ me->gc_item-item_text }-{ me->gv_nfenum }| ) ).

            gt_currencyamount = VALUE #( BASE gt_currencyamount ( itemno_acc = sy-index currency = <fs_properties>-moeda amt_doccur = abs( VALUE #( me->gt_descontos[ 1 ]-amount DEFAULT 0 ) ) ) ).

            gt_extension = VALUE #( BASE gt_extension ( structure = 'XREF1_HD' valuepart1 = sy-index valuepart2 = gc_document-xref1_hd ) ).

            gt_extension = VALUE #( BASE gt_extension ( structure = 'XREF2_HD' valuepart1 = sy-index valuepart2 = <fs_properties>-numdocumentoref ) ).

            gt_extension = VALUE #( BASE gt_extension ( structure = 'REBZG'    valuepart1 = sy-index valuepart2 = <fs_properties>-numdocumento ) ).

            gt_extension = VALUE #( BASE gt_extension ( structure = 'REBZJ'    valuepart1 = sy-index valuepart2 = <fs_properties>-ano ) ).

            gt_extension = VALUE #( BASE gt_extension ( structure = 'REBZZ'    valuepart1 = sy-index valuepart2 = <fs_properties>-item ) ).

          WHEN 2.

            " Item 2
            gt_accountgl = VALUE #( BASE gt_accountgl ( itemno_acc = sy-index
                                                         comp_code = <fs_properties>-empresa
                                                        gl_account = gt_gl_acct_rng[ 1 ]-low
                                                         item_text = |{ gc_item-item_text }-{ me->gv_nfenum }|
                                                          bus_area = gs_fin_group-BusinessArea
                                                        profit_ctr = gs_fin_group-ProfitCenter
                                                        costcenter = gs_fin_group-CostCenter
                                                           segment = gs_fin_group-Segment  ) ).

            gt_currencyamount = VALUE #( BASE gt_currencyamount ( itemno_acc = sy-index currency = <fs_properties>-moeda amt_doccur = abs( VALUE #( me->gt_descontos[ 1 ]-amount DEFAULT 0 ) ) * ( -1 ) ) ).

            gt_extension = VALUE #( BASE gt_extension ( structure = 'BUPLA' valuepart1 = sy-index valuepart2 = <fs_properties>-LocalNegocio ) ).

          WHEN OTHERS.
            EXIT.
        ENDCASE.

      ENDDO.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
