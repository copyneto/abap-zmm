"!<p>Classe processar inventário</p>
"!<p><strong>Autor:</strong>Marcos Rubik</p>
"!<p><strong>Data:</strong> 20 de Dezembro de 2021</p>
class ZCLMM_INTERFACE_INVENTARIO definition
  public
  create public .

public section.

  "! Método chamar processamento dos dados inventário
  "! @parameter is_input  | Dados entrada interface
  methods PROCESSA_INTERFACE_INVENTARIO
    importing
      !IS_INPUT type ZCLMM_MT_INVENTARIO_FISICO
    raising
      ZCLMM_CX_INTERF_INVENTARIO .
protected section.
private section.

  "! Método formatar campos de entrada da interface
  "! @parameter is_input  | Dados entrada interface
  "! @parameter ct_file   | Tabela saido dos dados
  methods FORMATA_CAMPOS_INTERFACE
    importing
      !IS_INPUT type ZCLMM_MT_INVENTARIO_FISICO
    changing
      !CT_FILE type ZCTGMM_INVENTORY_FILE .
ENDCLASS.



CLASS ZCLMM_INTERFACE_INVENTARIO IMPLEMENTATION.


  METHOD formata_campos_interface.

    DATA: lv_batch TYPE batch.

    LOOP AT is_input-mt_inventario_fisico-dados[] ASSIGNING FIELD-SYMBOL(<fs_dados>).

      READ TABLE <fs_dados>-caracteristicas ASSIGNING FIELD-SYMBOL(<fs_dados_2>) INDEX 1.

      IF <fs_dados_2> IS ASSIGNED.

        IF <fs_dados_2>-batch IS INITIAL.

          READ TABLE <fs_dados>-caracteristicas ASSIGNING FIELD-SYMBOL(<fs_dados_3>) INDEX 2.

          IF <fs_dados_3> IS ASSIGNED.

            lv_batch = <fs_dados_3>-batch.

          ENDIF.

        ELSE.

          lv_batch = <fs_dados_2>-batch.

        ENDIF.

      ENDIF.

      DATA(ls_file) = VALUE zsmm_inventory_file( plant           = <fs_dados>-plant
                                                 datesel         = <fs_dados>-date
                                                 storagelocation = <fs_dados>-stge_loc
                                                 material        = |{ <fs_dados>-material WIDTH = 18 ALIGN = RIGHT PAD = '0' }|
                                                 batch           = lv_batch-charg
                                                 quantitycount   = <fs_dados>-entry_qnt
                                                 unit            = <fs_dados>-entry_uom ).

      APPEND ls_file TO ct_file.

      CLEAR: lv_batch.

    ENDLOOP.

  ENDMETHOD.


  METHOD processa_interface_inventario.
    DATA: lt_file     TYPE zctgmm_inventory_file.

    me->formata_campos_interface( EXPORTING is_input = is_input
                                  CHANGING  ct_file  = lt_file ).

    DATA(lo_inventario) = NEW zclmm_inventario( ).

    lo_inventario->process_file( EXPORTING it_file   = lt_file[]
                                 IMPORTING es_header = DATA(ls_header)
                                           et_item   = DATA(lt_item)
                                           et_return = DATA(lt_return) ).
    SORT lt_return BY type.
    READ TABLE lt_return
      WITH KEY type = 'E'
      TRANSPORTING NO FIELDS
      BINARY SEARCH.
    IF sy-subrc EQ 0.
      RAISE EXCEPTION TYPE zclmm_cx_interf_inventario
        EXPORTING
          textid          = zclmm_cx_interf_inventario=>gc_erro_proc_inventario
          it_bapiret2_tab = lt_return.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
