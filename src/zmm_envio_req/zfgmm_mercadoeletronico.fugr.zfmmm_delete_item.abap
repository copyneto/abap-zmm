FUNCTION zfmmm_delete_item.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REQUISITION) TYPE  CHAR10
*"  TABLES
*"      IT_ITEM STRUCTURE  MEREQ_ITEM
*"      IT_ITEMX STRUCTURE  MEREQ_ITEMX
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  CALL FUNCTION 'FMFG_MM_REQ_CHANGE'
    EXPORTING
      im_banfn       = iv_requisition
    TABLES
      return         = it_return
      im_mereq_item  = it_item
      im_mereq_itemx = it_itemx.


ENDFUNCTION.
