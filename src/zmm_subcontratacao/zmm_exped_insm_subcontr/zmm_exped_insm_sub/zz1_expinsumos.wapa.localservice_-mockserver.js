sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="br/com/trescoracoes/br/com/trescoracoes/mmexpinsumos/",a=r+"localService/mockdata";return{init:function(){var s=jQuery.sap.getUriParameters(),o=jQuery.sap.getModulePath(a),n=+
jQuery.sap.getModulePath(r+"manifest",".json"),i="zc_mm_rkpf_reserva",u=s.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(n).data,l=p["sap.app"].dataSources,f=l.mainService,d=jQuery.sap.getModulePath(r+f.settings.localUri.replace(".x+
ml",""),".xml"),m=/.*\/$/.test(f.uri)?f.uri:f.uri+"/",g=f.settings.annotations;t=new e({rootUri:m});e.config({autoRespond:true,autoRespondAfter:s.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:o,bGenerateMissingMockData:true});var y=t.getReques+
ts(),h=function(e,t,r){r.response=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(s.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(functio+
n(e){if(e.path.toString().indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(g&&g.length>0){g.forEach(function(t){var a=l[t],s=a.uri,o=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");ne+
w e({rootUri:s,requests:[{method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:o,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},+
getMockServer:function(){return t}}});                                                                                                                                                                                                                         