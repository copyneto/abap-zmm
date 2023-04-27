CLASS zcl_im_mm_imobilizado DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_mb_document_badi .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im_mm_imobilizado IMPLEMENTATION.


  METHOD if_ex_mb_document_badi~mb_document_before_update.

    CHECK xmseg[] IS NOT INITIAL.

    READ TABLE xmseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) INDEX 1.
    IF sy-subrc IS INITIAL.

      IF <fs_mseg>-smbln IS NOT INITIAL.

        " Movimento de Entrada
        SELECT *
          FROM ztmm_mov_cntrl
         WHERE mblnr_ent = @<fs_mseg>-smbln
           AND mjahr_ent = @<fs_mseg>-sjahr
          INTO @DATA(ls_mov)
          UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc IS INITIAL.
          IF ls_mov-etapa EQ '6'.

            ls_mov-etapa = '5'.
            ls_mov-mblnr_est_ent = <fs_mseg>-mblnr.
            ls_mov-mjahr_est_ent = <fs_mseg>-mjahr.
            ls_mov-bldat_est_ent = <fs_mseg>-budat_mkpf.
            CLEAR: ls_mov-mblnr_ent,
                   ls_mov-mjahr_ent,
                   ls_mov-mblpo_ent.

            MODIFY ztmm_mov_cntrl FROM ls_mov.

          ENDIF.
        ENDIF.

        " Movimento de Saída
        SELECT *
          FROM ztmm_mov_cntrl
         WHERE mblnr_sai = @<fs_mseg>-smbln
           AND mjahr     = @<fs_mseg>-sjahr
          INTO @ls_mov
          UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc IS INITIAL.
          IF ls_mov-etapa EQ '1'.

            ls_mov-etapa         = '0'.
            ls_mov-mblnr_est     = <fs_mseg>-mblnr.
            ls_mov-mjahr_est     = <fs_mseg>-mjahr.
            CLEAR: ls_mov-mblnr_sai,
                   ls_mov-mjahr,
                   ls_mov-mblpo.

            MODIFY ztmm_mov_cntrl FROM ls_mov.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    INCLUDE zmmi_gerar_nf IF FOUND.

  ENDMETHOD.


  METHOD if_ex_mb_document_badi~mb_document_update.
    RETURN.
  ENDMETHOD.
ENDCLASS.
