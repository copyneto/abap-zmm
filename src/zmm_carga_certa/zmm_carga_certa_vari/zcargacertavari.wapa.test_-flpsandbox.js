sap.ui.define(["sap/base/util/ObjectPath","sap/ushell/services/Container"],function(a){"use strict";a.set(["sap-ushell-config"],{defaultRenderer:"fiori2",bootstrapPlugins:{RuntimeAuthoringPlugin:{component:"sap.ushell.plugins.rta",config:{validateAppVers+
ion:false}},PersonalizePlugin:{component:"sap.ushell.plugins.rta-personalize",config:{validateAppVersion:false}}},renderers:{fiori2:{componentData:{config:{enableSearch:false,rootIntent:"Shell-home"}}}},services:{LaunchPage:{adapter:{config:{groups:[{til+
es:[{tileType:"sap.ushell.ui.tile.StaticTile",properties:{title:"Carga Certa - Variantes",targetURL:"#cargacertavarifcargacertavarif-display"}}]}]}}},ClientSideTargetResolution:{adapter:{config:{inbounds:{"cargacertavarifcargacertavarif-display":{semanti+
cObject:"cargacertavarifcargacertavarif",action:"display",description:"Carga Certa - Cadastro de Variantes",title:"Carga Certa - Variantes",signature:{parameters:{}},resolutionResult:{applicationType:"SAPUI5",additionalInformation:"SAPUI5.Component=carga+
certavarif.cargacertavarif",url:sap.ui.require.toUrl("cargacertavarif/cargacertavarif")}}}}}},NavTargetResolution:{config:{enableClientSideTargetResolution:true}}}});var e={init:function(){if(!this._oBootstrapFinished){this._oBootstrapFinished=sap.ushell+
.bootstrap("local");this._oBootstrapFinished.then(function(){sap.ushell.Container.createRenderer().placeAt("content")})}return this._oBootstrapFinished}};return e});                                                                                          