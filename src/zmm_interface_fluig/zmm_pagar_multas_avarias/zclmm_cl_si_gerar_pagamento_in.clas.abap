CLASS zclmm_cl_si_gerar_pagamento_in DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclmm_ii_si_gerar_pagamento_in .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ZCLMM_CL_SI_GERAR_PAGAMENTO_IN IMPLEMENTATION.


  METHOD zclmm_ii_si_gerar_pagamento_in~si_gerar_pagamento_inb.
    TRY.

        NEW zclmm_pagar_multas_avarias( )->get_data(
            EXPORTING
                is_input = input
            IMPORTING
             es_output = output
        ).

      CATCH cx_ai_system_fault INTO DATA(lo_erro).

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
