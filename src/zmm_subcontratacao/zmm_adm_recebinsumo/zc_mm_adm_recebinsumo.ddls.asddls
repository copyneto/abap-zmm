@EndUserText.label: 'ADM Recebimento de Insumo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ADM_RECEBINSUMO
  as projection on ZI_MM_ADM_RECEBINSUMO
{
//        @ObjectModel.text.element: ['LifnrCodeName']
  key   LifnrCode,
//        @ObjectModel.text.element: ['WerksCodeName']
  key   WerksCode,
  key   Cfop,
  key   Nnf, 
  key   XML,
  key   BR_NotaFiscal,
        DataEmissao,
        Credat,
        @ObjectModel.text.element: ['Descricao']
        Status,
        _STATUS.Descricao    as Descricao,
        StatusCriticality,
        _LIFNR.LifnrCodeName as LifnrCodeName,
        _WERKS.WerksCodeName as WerksCodeName,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_J1B3N_CREATE_URL' }
virtual url_j1b3n : eso_longtext
        //      Docnum2,
        //      Docsta,
        //      Scssta,
        //      Conting,
        //      Cancel,
        //      Code,
        //      Regio,
        //      Nfyear,
        //      Nfmonth,
        //      Stcd1,
        //      Model,
        //      Serie,
        //      Nfnum9,
        //      Docnum9,
        //      Cdv,
        //      Authcod,
        //      Credat2,
        //      ActionDate,
        //      ActionTime,
        //      ActionUser,
        //      Bukrs,
        //      Branch,
        //      Vstel,
        //      Parid,
        //      Partyp,
        //      Direct,
        //      Refnum,
        //      Form,
        //      ActionRequ,
        //      Printd,
        //      ContingS,
        //      Msstat,
        //      Reason,
        //      Reason1,
        //      Reason2,
        //      Reason3,
        //      Reason4,
        //      Crenam,
        //      Callrfc,
        //      Tpamb,
        //      SefazActive,
        //      ScanActive,
        //      Checktmpl,
        //      Authdate,
        //      Authtime,
        //      Tpemis,
        //      ReasonConting,
        //      ReasonConting1,
        //      ReasonConting2,
        //      ReasonConting3,
        //      ReasonConting4,
        //      ContingDate,
        //      ContingTime,
        //      ContinTimeZone,
        //      CancelAllowed,
        //      Source,
        //      CancelPa,
        //      EventFlag,
        //      ActiveService,
        //      SvcSpActive,
        //      SvcRsActive,
        //      SvcActive,
        //      Rps,
        //      NfseNumber,
        //      NfseCheckCode,
        //      CodeDescription,
        //      Cmsg,
        //      Xmsg,
        //      CloudGuid,
        //      CloudExtensFlag,
        //      ReplacementStatus
}
