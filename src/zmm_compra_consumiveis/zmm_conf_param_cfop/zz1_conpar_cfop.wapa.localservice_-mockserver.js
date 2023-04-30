sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="br/com/trescoracoes/confparamcfop/",a=r+"localService/mockdata";return{init:function(){var n=jQuery.sap.getUriParameters(),o=jQuery.sap.getModulePath(a),s=jQuery.sap.getModul+
ePath(r+"manifest",".json"),i="ZC_MM_CONF_PARAM_CFOP",u=n.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(s).data,f=p["sap.app"].dataSources,l=f.mainService,d=jQuery.sap.getModulePath(r+l.settings.localUri.replace(".xml",""),".xml"),+
g=/.*\/$/.test(l.uri)?l.uri:l.uri+"/",m=l.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:n.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:o,bGenerateMissingMockData:true});var y=t.getRequests(),h=function(+
e,t,r){r.response=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(n.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){if(e.path.t+
oString().indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var a=f[t],n=a.uri,o=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");new e({rootUri:n,r+
equests:[{method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:o,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMockServer:fu+
nction(){return t}}});                                                                                                                                                                                                                                         