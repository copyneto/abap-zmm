class ZCLMM_LIBPG_GRVDE_BLOCK definition
  public
  inheriting from ZCLMM_LIBPG_GRVDE_OP
  final
  create public .

public section.

    "!Constructor
  methods CONSTRUCTOR .
  methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .

  methods ZIFMM_LIB_PGTO_GRAOVERDE~EXECUTAR
    redefinition .
protected section.

  data GT_ACCCHG type FDM_T_ACCCHG .
  data GS_RETURN type BAPIRET2 .
  data GV_SUBRC type SY-SUBRC .
  PRIVATE SECTION.

    CONSTANTS gc_fdname TYPE fieldname VALUE 'ZLSPR'.

ENDCLASS.



CLASS ZCLMM_LIBPG_GRVDE_BLOCK IMPLEMENTATION.


  METHOD zifmm_lib_pgto_graoverde~executar.

    EXPORT abap_true FROM abap_true TO MEMORY ID 'ZRET_BLOQ'.

    data(ls_prop) = value #( me->gt_properties[ 1 ] OPTIONAL ).

    CALL FUNCTION 'ZFMTM_GKO_DOCUMENT_CHANGE'
      STARTING NEW TASK 'TM_DOCUMENT_CHANGE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_obzei    = '000'
        iv_buzei    = ls_prop-item
        iv_lock     = abap_true
        iv_bukrs    = ls_prop-empresa
        iv_belnr    = ls_prop-numdocumento
        iv_gjahr    = ls_prop-ano
        iv_upd_fqm  = abap_true
        it_accchg   = me->gt_accchg.

    WAIT UNTIL gv_wait = abap_true.

    APPEND gs_return TO me->gt_return.

    IF NOT line_exists( me->gt_return[ type = 'E ' ] ).
      CLEAR: me->gt_return.
      me->gt_return[] = VALUE #( BASE me->gt_return ( type = 'S' id = 'ZMM_LIB_PGTO_GV' number = '007' ) ).
      me->gt_return[] = VALUE #( BASE me->gt_return ( type = 'S' id = 'ZMM_LIB_PGTO_GV' number = '008' message_v1 = ls_prop-numdocumento message_v2 = ls_prop-empresa message_v3 = ls_prop-ano ) ).
    ELSE.
      me->gt_return[] = VALUE #( BASE me->gt_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '009' ) ).
    ENDIF.

    super->zifmm_lib_pgto_graoverde~executar( ).

  ENDMETHOD.


  METHOD constructor.

    super->constructor( ).

    me->gt_accchg = VALUE #( ( fdname = me->gc_fdname oldval = space newval = space ) ).

  ENDMETHOD.


  method SETUP_MESSAGES.

    CASE p_task.
      WHEN 'TM_DOCUMENT_CHANGE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_DOCUMENT_CHANGE'
         IMPORTING
           ev_subrc  = gv_subrc
           es_return = gs_return.

        gv_wait = abap_true.

      WHEN OTHERS.
    ENDCASE.

  endmethod.
ENDCLASS.
