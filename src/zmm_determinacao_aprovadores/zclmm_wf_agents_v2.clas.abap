"!<p>Essa classe é utilizada para Determinação de responsáveis pelo processamento para documentos de compras
"!<p><strong>Autor:</strong> Bruno Costa - Meta</p>
"!<p><strong>Data:</strong> 11/02/2022</p>
CLASS zclmm_wf_agents_v2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mmpur_workflow_agents_v2 .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCLMM_WF_AGENTS_V2 IMPLEMENTATION.


  METHOD if_mmpur_workflow_agents_v2~get_approvers.


*    IF purchasingdocument EQ '1000000011'.
*
*      DATA: lv_break TYPE c VALUE 'X'.
*      DO.
*        IF lv_break = ''.
*          EXIT.
*        ENDIF.
*      ENDDO.
*
*    ENDIF.

    DATA lv_kostl TYPE kostl.
    DATA lv_previous_approver TYPE if_mmpur_workflow_agents_v2=>bd_mmpur_s_previous_approver.

    SELECT SINGLE accountassignmentcategory, material, plant, storagelocation
             FROM i_purchaserequisition_api01
             INTO @DATA(ls_cds_pr)
            WHERE purchaserequisition     EQ @purchasingdocument
              AND purchaserequisitionitem EQ @purchasingdocumentitem.

    IF sy-subrc EQ 0 AND ls_cds_pr-accountassignmentcategory IS NOT INITIAL
                     AND ls_cds_pr-material                  IS NOT INITIAL.

      SELECT multipleacctassgmtdistrpercent, purreqnnetamount,
             purchasereqnacctassgmtnumber  , costcenter,
             wbselement                    , controllingarea, orderid
      FROM i_purreqnacctassgmt_api01
      INTO TABLE @DATA(lt_cds_pr_acct)
      WHERE purchaserequisition     EQ @purchasingdocument
      AND purchaserequisitionitem EQ @purchasingdocumentitem.

      IF sy-subrc EQ 0.

        SORT lt_cds_pr_acct BY multipleacctassgmtdistrpercent DESCENDING purreqnnetamount DESCENDING purchasereqnacctassgmtnumber ASCENDING.

        READ TABLE lt_cds_pr_acct ASSIGNING FIELD-SYMBOL(<fs_cds_pr_acct>) INDEX 1.

        CASE ls_cds_pr-accountassignmentcategory.
          WHEN 'K'.
            lv_kostl = <fs_cds_pr_acct>-costcenter.
          WHEN 'A' OR 'P'.

            DATA: lv_wbselement TYPE ps_posid.

            CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
              EXPORTING
                input  = <fs_cds_pr_acct>-wbselement
              IMPORTING
                output = lv_wbselement.

            SELECT SINGLE responsiblecostcenter
            FROM c_wbselementbasicinfo
            WHERE wbselement EQ @lv_wbselement
              AND version IS INITIAL
            INTO @lv_kostl.

           IF sy-subrc <> 0.
             SELECT SINGLE responsiblecostcenter
             FROM c_wbselementbasicinfo
             INTO @lv_kostl
             WHERE wbselement EQ @lv_wbselement.
           ENDIF.

          WHEN 'F'.

            SELECT SINGLE responsiblecostcenter
            FROM i_maintenanceorder
            INTO @lv_kostl
            WHERE maintenanceorder EQ @<fs_cds_pr_acct>-orderid.

          WHEN OTHERS.
*            Do Noting...
        ENDCASE.

        CHECK lv_kostl IS NOT INITIAL.

        SELECT SINGLE costctrresponsibleuser
                 FROM i_costcenter
                 INTO @DATA(lv_costctrresponsibleuser)
                WHERE costcenter        EQ @lv_kostl
                  AND controllingarea   EQ @<fs_cds_pr_acct>-controllingarea
                  AND validityenddate   >= @sy-datum
                  AND validitystartdate <= @sy-datum.

        CHECK sy-subrc EQ 0 AND lv_costctrresponsibleuser IS NOT INITIAL.

        lv_previous_approver-businessuser = lv_costctrresponsibleuser.
        "lv_previous_approver-businessuser = 'DMANTEIGA'.
        APPEND lv_previous_approver TO  approverlist.

      ENDIF.
    ELSEIF sy-subrc EQ 0 AND ls_cds_pr-accountassignmentcategory IS INITIAL
                         AND ls_cds_pr-material                  IS NOT INITIAL.

      SELECT SINGLE usnam
      FROM ztmm_wfaprov
      WHERE werks = @ls_cds_pr-plant
      AND   lgort = @ls_cds_pr-storagelocation
      INTO @DATA(lv_usnam).

      IF sy-subrc EQ 0 AND lv_usnam IS NOT INITIAL.
        lv_previous_approver-businessuser = lv_usnam.
        APPEND lv_previous_approver TO  approverlist.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
