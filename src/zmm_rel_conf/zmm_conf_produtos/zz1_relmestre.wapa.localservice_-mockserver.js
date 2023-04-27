sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="br/com/trescoracoes/relmestre/",a=r+"localService/mockdata";return{init:function(){var n=jQuery.sap.getUriParameters(),s=jQuery.sap.getModulePath(a),o=jQuery.sap.getModulePat+
h(r+"manifest",".json"),i="ZC_MM_CONF_PROD",u=n.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(o).data,l=p["sap.app"].dataSources,f=l.mainService,d=jQuery.sap.getModulePath(r+f.settings.localUri.replace(".xml",""),".xml"),g=/.*\/$/.+
test(f.uri)?f.uri:f.uri+"/",m=f.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:n.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:s,bGenerateMissingMockData:true});var y=t.getRequests(),h=function(e,t,r){r.r+
esponse=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(n.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){if(e.path.toString().+
indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var a=l[t],n=a.uri,s=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");new e({rootUri:n,requests:[{+
method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:s,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMockServer:function(){r+
eturn t}}});                                                                                                                                                                                                                                                   