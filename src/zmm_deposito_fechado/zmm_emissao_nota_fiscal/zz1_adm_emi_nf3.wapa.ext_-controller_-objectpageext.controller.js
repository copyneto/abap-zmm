sap.ui.define([],function(){"use strict";return{onActionCreateSeries:function(e){var t=this;var n=e.getSource().getBindingContext();var i=new sap.ui.layout.VerticalLayout({width:"100%",content:[new sap.m.MultiInput("inSeries",{showValueHelp:false})]});va+
r r=new sap.m.Button({type:sap.m.ButtonType.Emphasized,text:"Adicionar",press:function(){var e=sap.ui.getCore().byId("inSeries").getTokens();var t=e.map(function(e){return e.getKey()}).join(";");a.close();var i=this;var r=function(){return new Promise(fu+
nction(e,r){i.extensionAPI.invokeActions("/adicionarSerie",n,{SerialNoList:t}).then(function(t){e();i.oView.getController().extensionAPI.refresh()})}.bind(this))}.bind(this);var s={dataloss:false};this.extensionAPI.securedExecution(r,s)}.bind(this)});var+
 a=new sap.m.Dialog({type:"Message",title:"Informar as séries",resizable:true,draggable:true,titleAlignment:sap.m.TitleAlignment.Center,content:i,beginButton:r,endButton:new sap.m.Button({text:"Cancelar",press:function(){a.close()}}),afterClose:function(+
){a.destroy()}});a.open();var s=sap.ui.getCore().byId("inSeries");var o=function(e){var t=e.text;return new sap.m.Token({key:t,text:t})};s.addValidator(o)}}});                                                                                                