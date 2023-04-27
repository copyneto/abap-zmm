class ZCLMM_DETERM_APROVADOR definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_MMPUR_WORKFLOW_AGENTS_V2 .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_DETERM_APROVADOR IMPLEMENTATION.


  METHOD if_mmpur_workflow_agents_v2~get_approvers.

    SELECT p~purchasecontract,
           p~purchaserequisition,
           p~purchaserequisitionitem,
           m~costcenter,
           i~accountassignmentcategory,
           m~WBSElementInternalID,
           m~OrderID
      FROM i_serviceentrysheetitemapi01 AS i
     INNER JOIN i_serviceentrysheetapi01 AS h
        ON i~serviceentrysheet = h~serviceentrysheet
     INNER JOIN i_serviceentrysheetacctassgmt AS m
        ON i~serviceentrysheet = m~serviceentrysheet
       AND i~serviceentrysheetitem = m~serviceentrysheetitem
     INNER JOIN i_purchaseorderitemapi01 AS p
        ON i~purchaseorder = p~purchaseorder
       AND i~purchaseorderitem = p~purchaseorderitem
     WHERE i~serviceentrysheet = @purchasingdocument
     ORDER BY i~serviceentrysheetitem ASCENDING, m~multipleacctassgmtdistrpercent DESCENDING, m~netamount DESCENDING, m~accountassignment ASCENDING
      INTO TABLE @DATA(lt_sheet)
     UP TO 1 ROWS.

*    DATA: lv_break TYPE c VALUE 'X'.
*
*    DO.
*      IF lv_break = ''.
*        EXIT.
*      ENDIF.
*    ENDDO.

    CHECK sy-subrc EQ 0.

    READ TABLE lt_sheet ASSIGNING FIELD-SYMBOL(<fs_sheet>) INDEX 1.

    CHECK <fs_sheet> IS ASSIGNED.

    APPEND INITIAL LINE TO approverlist ASSIGNING FIELD-SYMBOL(<fs_aprov>).

    SELECT SINGLE i_purreq_ite~createdbyuser
    FROM
      i_purchaserequisitionitem AS i_purreq_ite
    WHERE
      i_purreq_ite~purchaserequisition = @<fs_sheet>-purchaserequisition AND
      i_purreq_ite~purchaserequisitionitem = @<fs_sheet>-purchaserequisitionitem
    INTO @<fs_aprov>.



*    IF <fs_sheet>-purchasecontract IS NOT INITIAL. "Regra 1
*
*      SELECT SINGLE correspncinternalreference
*        FROM i_purchasecontractapi01
*       WHERE purchasecontract = @<fs_sheet>-purchasecontract
*        INTO @<fs_aprov>.
*
*    ELSE. "Regra 3
*
*      DATA lv_kostl TYPE kostl.
*
*      CASE <fs_sheet>-accountassignmentcategory.
*        WHEN 'K'.
*          lv_kostl = <fs_sheet>-costcenter.
*          WHEN 'A' OR 'O'.
*        WHEN 'A' OR 'P' OR 'O'.
*
*          DATA: lv_wbselement TYPE c_wbselementbasicinfo-wbselement.
*
*          CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
*            EXPORTING
*              input  = <fs_sheet>-wbselementinternalid
*            IMPORTING
*              output = lv_wbselement.
*
*          SELECT SINGLE responsiblecostcenter
*                   FROM c_wbselementbasicinfo
*                   INTO @lv_kostl
*                  WHERE wbselement EQ @lv_wbselement.
*
*        WHEN 'F'.
*          SELECT SINGLE responsiblecostcenter
*                   FROM i_maintenanceorder
*                   INTO @lv_kostl
*                  WHERE maintenanceorder EQ @<fs_sheet>-orderid.
*        WHEN OTHERS.
*      ENDCASE.
*
*      CHECK lv_kostl IS NOT INITIAL.
*
*      SELECT SINGLE i~costctrresponsibleuser
*        FROM i_costcenter AS i
*       INNER JOIN i_purreqnacctassgmt_api01 AS p
*          ON i~controllingarea = p~controllingarea
*       WHERE i~costcenter = @lv_kostl
*         AND i~validityenddate >= @sy-datum
*         AND i~validitystartdate <= @sy-datum
*        INTO @<fs_aprov>.
*
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
