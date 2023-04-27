*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTMM_ARGO_OP_PAR'.

CONSTANTS:
  BEGIN OF gc_msg_general,
    id     TYPE bapiret2-id VALUE 'ZMM_ARGO_COMPRAS',
    number TYPE bapiret2-number VALUE '000',
  END OF gc_msg_general,

  BEGIN OF gc_msg_dateInvalid,
    id     TYPE bapiret2-id VALUE 'ZMM_ARGO_COMPRAS',
    number TYPE bapiret2-number VALUE '001',
  END OF gc_msg_dateInvalid.
