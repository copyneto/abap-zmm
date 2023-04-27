*&---------------------------------------------------------------------*
*& Report zmmr_cancelar_item_req
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_cancelar_item_req.

DATA(lo_process) = NEW zclmm_cancelar_item_req( ).

DATA(lt_return)  = lo_process->execute( ).

LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<gfs_return>).

    WRITE: | { <gfs_return>-type } - { <gfs_return>-message } |.

ENDLOOP.
