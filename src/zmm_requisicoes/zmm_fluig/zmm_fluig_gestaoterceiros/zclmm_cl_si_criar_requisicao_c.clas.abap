class ZCLMM_CL_SI_CRIAR_REQUISICAO_C definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_CRIAR_REQUISICAO_C .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_CRIAR_REQUISICAO_C IMPLEMENTATION.


  METHOD zclmm_ii_si_criar_requisicao_c~si_criar_requisicao_compras.

    DATA: ls_header  TYPE bapimereqheader,
          ls_headerx TYPE bapimereqheaderx.

    DATA: lt_item    TYPE STANDARD TABLE OF bapimereqitemimp,
          lt_account TYPE STANDARD TABLE OF bapimereqaccount,
          lt_text    TYPE STANDARD TABLE OF bapimereqheadtext,
          lt_return  TYPE STANDARD TABLE OF bapiret2.

    DATA: lv_doc_ret       TYPE banfn.

    CONSTANTS: lc_type       TYPE string VALUE 'NB',
               lc_trackingno TYPE string VALUE 'BAIXA COMP',
               lc_quantity   TYPE string VALUE '1',
               lc_text_form  TYPE string VALUE 'B01'.

    ls_header-pr_type   = lc_type.
    ls_headerx-pr_type  = abap_true.

    LOOP AT input-mt_requisicao_compra-pritem ASSIGNING FIELD-SYMBOL(<fs_item>).

      lt_item = VALUE #( BASE lt_item (
          preq_item   = ( sy-tabix * 10 )
          preq_name   = <fs_item>-preq_name
          material    = <fs_item>-material
          plant       = <fs_item>-plant
          trackingno  = lc_trackingno
          quantity    = lc_quantity
          preq_date   = sy-datum
          deliv_date  = sy-datum
          preq_price  = <fs_item>-preq_price
          acctasscat  = <fs_item>-acctasscat
         ) ).

    ENDLOOP.

    LOOP AT input-mt_requisicao_compra-praccount ASSIGNING FIELD-SYMBOL(<fs_account>).

      lt_account = VALUE #( BASE lt_account (
         preq_item   = ( sy-tabix * 10 )
         gl_account  = <fs_account>-gl_account
         costcenter  = <fs_account>-costcenter
         orderid     = <fs_account>-orderid
         wbs_element = <fs_account>-wbs_element
      ) ).

    ENDLOOP.

    lt_text = VALUE #( BASE lt_text (
        text_form = lc_text_form
        text_line = input-mt_requisicao_compra-text_line
     ) ).

    CALL FUNCTION 'BAPI_PR_CREATE'
      EXPORTING
        prheader      = ls_header
        prheaderx     = ls_headerx
      IMPORTING
        number        = lv_doc_ret
      TABLES
        return        = lt_return
        pritem        = lt_item
        praccount     = lt_account
        prheadertext  = lt_text
      EXCEPTIONS
        error_message = 1
        OTHERS        = 2.

    IF sy-subrc NE 0.

      DATA(lv_motivo) = VALUE #( lt_return[ 1 ]-message OPTIONAL ).

**     enviar retorno de erro

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      INSERT INTO ztmm_fluig_rc VALUES @( VALUE #(
        banfn = lv_doc_ret
        idsol = input-mt_requisicao_compra-idsol
      ) ).

**     enviar retorno de sucesso

    ENDIF.

  ENDMETHOD.
ENDCLASS.
