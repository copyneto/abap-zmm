@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_DF_MOTORISTA
  as select from    but000       as Pessoa
    inner join but0id as _but0id on _but0id.partner = Pessoa.partner
                                and _but0id.type    = 'HCM001'  
    left outer join dfkkbptaxnum as _Cnpj on  _Cnpj.partner = Pessoa.partner
                                          and _Cnpj.taxtype = 'BR1'
    left outer join dfkkbptaxnum as _Cpf  on  _Cpf.partner = Pessoa.partner
                                          and _Cpf.taxtype = 'BR2'
    left outer join dfkkbptaxnum as _Ie   on  _Ie.partner = Pessoa.partner
                                          and _Ie.taxtype = 'BR3'
    left outer join dfkkbptaxnum as _Im   on  _Im.partner = Pessoa.partner
                                          and _Im.taxtype = 'BR4'
{
      @EndUserText.label: 'Parceiro de negócios'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Pessoa.partner as Parceiro,
      @EndUserText.label: 'Nome completo'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      case
        when length( Pessoa.name1_text ) < 1
         then concat_with_space(Pessoa.name_first, Pessoa.name_last, 1 )
        else Pessoa.name1_text
      end            as Nome,
      @EndUserText.label: 'CNPJ'
      @UI.hidden: true
      _Cnpj.taxnum   as CNPJ,
      @EndUserText.label: 'CNPJ'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      case when _Cnpj.taxnum is initial then ''
           else concat( substring(_Cnpj.taxnum, 1, 2),
                concat( '.',
                concat( substring(_Cnpj.taxnum, 3, 3),
                concat( '.',
                concat( substring(_Cnpj.taxnum, 6, 3),
                concat( '/',
                concat( substring(_Cnpj.taxnum, 9, 4),
                concat( '-',  substring(_Cnpj.taxnum, 13, 2) ) ) ) ) ) ) ) )
      end            as CNPJText,
      @EndUserText.label: 'CPF'
      @UI.hidden: true
      _Cpf.taxnum    as CPF,
      @EndUserText.label: 'CPF'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      case when _Cpf.taxnum is initial then ''
           else concat( substring(_Cpf.taxnum, 1, 3),
                concat( '.',
                concat( substring(_Cpf.taxnum, 4, 3),
                concat( '.',
                concat( substring(_Cpf.taxnum, 7, 3),
                concat( '-', substring(_Cpf.taxnum, 10, 2) ) ) ) ) ) )
           end       as CPFText,
      @EndUserText.label: 'Inscrição Estadual'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Ie.taxnum     as InscricaoEstadual,
      @EndUserText.label: 'Inscrição Municipal'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Im.taxnum     as InscricaoMunicipal
}
where
  Pessoa.bpkind = '0011'
