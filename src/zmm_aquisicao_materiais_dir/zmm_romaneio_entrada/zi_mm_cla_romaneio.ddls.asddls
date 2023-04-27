@AbapCatalog.sqlViewName: 'ZVIMMCLAROMANIN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Romaneio de Entrada x Pedido de Compra'
define view ZI_MM_CLA_ROMANEIO
  as select from ztmm_control_cla as _Cla
    inner join   ztmm_romaneio_in as _Romaneio on  _Cla.ebeln = _Romaneio.ebeln
                                               and _Cla.ebelp = _Romaneio.ebelp
{
  key sequence          as Sequence,
      vbeln             as Vbeln,
      posnr             as Posnr,
      _Romaneio.ebeln   as Ebeln,
      _Romaneio.ebelp   as Ebelp,
      nfnum             as Nfnum,
      placa             as Placa,
      motorista         as Motorista,
      dt_entrada        as DtEntrada,
      dt_chegada        as DtChegada,
//      charg             as Charg,
      qtde              as Qtde,
      status_ordem      as StatusOrdem,
      status_armazenado as StatusArmazenado,
      status_compensado as StatusCompensado,
      destination       as Destination,
      peso_dif_ori      as PesoDifOri,
      qtde_dif_ori      as QtdeDifOri,
      calc_dif_peso     as CalcDifPeso,
      calc_dif_qtde     as CalcDifQtde
}
