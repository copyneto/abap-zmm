sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="br/com/trescoracoes/visaoremessaretorno/",a=r+"localService/mockdata";return{init:function(){var o=jQuery.sap.getUriParameters(),s=jQuery.sap.getModulePath(a),n=jQuery.sap.ge+
tModulePath(r+"manifest",".json"),i="visao_remessa_retorno",u=o.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(n).data,l=p["sap.app"].dataSources,f=l.mainService,d=jQuery.sap.getModulePath(r+f.settings.localUri.replace(".xml",""),".+
xml"),g=/.*\/$/.test(f.uri)?f.uri:f.uri+"/",m=f.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:o.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:s,bGenerateMissingMockData:true});var y=t.getRequests(),h=fun+
ction(e,t,r){r.response=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(o.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){if(e.+
path.toString().indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var a=l[t],o=a.uri,s=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");new e({rootU+
ri:o,requests:[{method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:s,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMockSer+
ver:function(){return t}}});                                                                                                                                                                                                                                   