CLASS lhc_aprovadores DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateinfo FOR VALIDATE ON SAVE
      IMPORTING keys FOR aprovadores~validateInfo.

    METHODS validateexists FOR VALIDATE ON SAVE
      IMPORTING keys FOR aprovadores~validateexists.


ENDCLASS.

CLASS lhc_aprovadores IMPLEMENTATION.

  METHOD validateinfo.

    READ ENTITIES OF ZI_MM_WFAPROV
    ENTITY Aprovadores
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_dados).

    CHECK lt_dados[] IS NOT INITIAL.

    READ TABLE lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>) INDEX 1.

    IF <fs_dados>-Werks IS INITIAL OR
        <fs_dados>-Lgort IS INITIAL OR
        <fs_dados>-Usnam IS INITIAL.

        APPEND VALUE #( %tky = <fs_dados>-%tky ) TO failed-aprovadores.
        APPEND VALUE #( %tky = <fs_dados>-%tky
                        %msg = new_message( id     = 'ZMM_WFAPROV'
                                            number = '001'
                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-aprovadores.
    ENDIF.


  ENDMETHOD.

  METHOD validateexists.

    READ ENTITIES OF ZI_MM_WFAPROV
    ENTITY Aprovadores
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_dados).

    CHECK lt_dados[] IS NOT INITIAL.

    READ TABLE lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>) INDEX 1.

    SELECT SINGLE * FROM ztmm_wfaprov
    WHERE werks = @<fs_dados>-Werks
    AND   lgort = @<fs_dados>-Lgort
    AND   usnam = @<fs_dados>-Usnam
    AND   guid <> @<fs_dados>-Guid
    INTO @DATA(ls_exists).

    IF ls_exists IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_dados>-%tky ) TO failed-aprovadores.
        APPEND VALUE #( %tky = <fs_dados>-%tky
                        %msg = new_message( id     = 'ZMM_WFAPROV'
                                            number = '000'
                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-aprovadores.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
