CLASS zclmm_emitir_nri DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_data TYPE STANDARD TABLE OF zi_mm_02_nri_item WITH EMPTY KEY.

    METHODS:
      execute
        IMPORTING
          it_data     TYPE zctgmm_monitor_ent
          iv_imprimir TYPE abap_bool DEFAULT abap_false
        EXPORTING
          ev_erro     TYPE string
          ev_pdf      TYPE xstring.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS : gc_adobename  TYPE fpname      VALUE 'ZAFMM_NRI',
                gc_parametro  TYPE rs38l_par_  VALUE 'ZNRI'.

    DATA: gt_data     TYPE zctgmm_monitor_ent,
          gt_return   TYPE bapiret2_t,
          gv_imprimir TYPE c.

    DATA:
      "!Instância do form Adobe
      go_form TYPE REF TO zclca_adobeform.


    METHODS emitir
      EXPORTING
        ev_pdf TYPE xstring  .

ENDCLASS.



CLASS zclmm_emitir_nri IMPLEMENTATION.


  METHOD execute.

    gt_data     = it_data.
    gv_imprimir = iv_imprimir.

    me->emitir(  IMPORTING ev_pdf = ev_pdf  ).

  ENDMETHOD.


  METHOD emitir.

    DATA: ls_dados_form TYPE zclca_adobeform=>ty_params.

    TRY.

        go_form = NEW zclca_adobeform( iv_formname = gc_adobename ).

        "Preparar interface com o formulário Adobe
        ls_dados_form-parametro = gc_parametro.

        ls_dados_form-valor = REF #( gt_data ).
        go_form->setup_data( is_data = ls_dados_form ).

        IF gv_imprimir = abap_true.

          go_form->show_dialog( iv_print_dialog = abap_true ).
          go_form->print( ).

        ELSE.
          go_form->get_pdf( IMPORTING ev_pdf = ev_pdf ).
        ENDIF.


      CATCH zcxca_adobe_error.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
