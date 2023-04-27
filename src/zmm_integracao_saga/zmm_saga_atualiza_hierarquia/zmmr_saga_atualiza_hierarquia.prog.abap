*&---------------------------------------------------------------------*
*& Report ZMMR_SAGA_ATUALIZA_HIERARQUIA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_saga_atualiza_hierarquia.

TABLES: t179.
*********************************************************************
* TELA DE SELEÇÃO                                                   *
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
   s_prodh FOR t179-prodh.

SELECTION-SCREEN END OF BLOCK b1.

*TYPES ty_ersda_type TYPE RANGE OF ersda.

**********************************************************************
* EVENTOS                                                            *
**********************************************************************
INITIALIZATION.
  DATA gs_output TYPE zclmm_mt_envia_grupo_mercadori.

START-OF-SELECTION.

  SELECT *
    FROM zi_mm_hierarquia_material
   WHERE Hierarquia IN @s_prodh[]
    INTO TABLE @DATA(gt_hierarquias).

  LOOP AT gt_hierarquias INTO DATA(gs_hierarquias).

    TRY.
        DATA(go_object) = NEW zclmm_co_si_grupo_mercadoria_o( ).

        gs_output-mt_envia_grupo_mercadoria-prodh   = gs_hierarquias-Hierarquia.
        gs_output-mt_envia_grupo_mercadoria-z_prdha = gs_hierarquias-Hierarquia.
        gs_output-mt_envia_grupo_mercadoria-vtext_1 = gs_hierarquias-Descricao.
        gs_output-mt_envia_grupo_mercadoria-vtext_2 = gs_hierarquias-Descricao.

        go_object->si_grupo_mercadoria_out( output = gs_output ).

        COMMIT WORK AND WAIT.
        WAIT UP TO 3 SECONDS.

      CATCH cx_ai_system_fault. " Application Integration: Technical Error.
    ENDTRY.

  ENDLOOP.
