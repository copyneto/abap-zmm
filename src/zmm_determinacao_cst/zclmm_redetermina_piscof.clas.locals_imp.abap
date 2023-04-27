CLASS lcl_PISCOFINS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR piscofins~validateFields.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR piscofins RESULT result.

ENDCLASS.

CLASS lcl_PISCOFINS IMPLEMENTATION.


  METHOD validateFields.

    DATA: lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Recupera linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_redetermina_piscof IN LOCAL MODE
        ENTITY piscofins
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_piscofins).

    DATA(lo_piscofins) = NEW zclmm_redetermina_piscof_event( ).

* ---------------------------------------------------------------------------
* Valida campos
* ---------------------------------------------------------------------------
    LOOP AT lt_piscofins REFERENCE INTO DATA(ls_piscofins).

      lo_piscofins->valida_piscofins( EXPORTING is_piscofins = CORRESPONDING #( ls_piscofins->* )
                                      IMPORTING et_return    = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
    ENDLOOP.

* ---------------------------------------------------------------------------
* Monta mensagens de retorno
* ---------------------------------------------------------------------------
    lo_piscofins->reported( EXPORTING it_return   = lt_return_all
                            IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD get_authorizations.

    DATA(lv_update) = COND #( WHEN requested_authorizations-%update EQ if_abap_behv=>mk-on
                               AND zclmm_redetermina_piscof_event=>update( iv_table = 'ZTMM_RED_PISCOF' ) EQ abap_true
                              THEN if_abap_behv=>auth-allowed
                              ELSE if_abap_behv=>auth-unauthorized ).

    DATA(lv_delete) = COND #( WHEN requested_authorizations-%delete EQ if_abap_behv=>mk-on
                               AND zclmm_redetermina_piscof_event=>delete( iv_table = 'ZTMM_RED_PISCOF' ) EQ abap_true
                              THEN if_abap_behv=>auth-allowed
                              ELSE if_abap_behv=>auth-unauthorized ).

    result = VALUE #( BASE result FOR ls_keys IN keys ( %tky    = ls_keys-%tky
                                                        %update = lv_update
                                                        %delete = lv_delete ) ).

  ENDMETHOD.

ENDCLASS.
