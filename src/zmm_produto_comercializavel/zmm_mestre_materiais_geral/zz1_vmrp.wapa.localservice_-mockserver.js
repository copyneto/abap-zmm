sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="br/com/trescoracoes/visaomrp/",a=r+"localService/mockdata";return{init:function(){var n=jQuery.sap.getUriParameters(),o=jQuery.sap.getModulePath(a),s=jQuery.sap.getModulePath+
(r+"manifest",".json"),i="ZC_MM_VISAO_MRP",u=n.get("errorType"),p=u==="badRequest"?400:500,c=jQuery.sap.syncGetJSON(s).data,l=c["sap.app"].dataSources,f=l.mainService,d=jQuery.sap.getModulePath(r+f.settings.localUri.replace(".xml",""),".xml"),g=/.*\/$/.t+
est(f.uri)?f.uri:f.uri+"/",m=f.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:n.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:o,bGenerateMissingMockData:true});var y=t.getRequests(),h=function(e,t,r){r.re+
sponse=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(n.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){if(e.path.toString().i+
ndexOf(i)>-1){h(p,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var a=l[t],n=a.uri,o=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");new e({rootUri:n,requests:[{m+
ethod:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:o,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMockServer:function(){re+
turn t}}});                                                                                                                                                                                                                                                    