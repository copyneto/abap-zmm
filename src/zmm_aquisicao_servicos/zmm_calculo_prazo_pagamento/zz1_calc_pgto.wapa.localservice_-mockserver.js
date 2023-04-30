sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,a="br/com/trescoracoes/mmcalcprazopgto/",r=a+"localService/mockdata";return{init:function(){var o=jQuery.sap.getUriParameters(),n=jQuery.sap.getModulePath(r),s=jQuery.sap.getMod+
ulePath(a+"manifest",".json"),i="zc_mm_calculo_prazo_pagamento",u=o.get("errorType"),c=u==="badRequest"?400:500,p=jQuery.sap.syncGetJSON(s).data,l=p["sap.app"].dataSources,f=l.mainService,d=jQuery.sap.getModulePath(a+f.settings.localUri.replace(".xml",""+
),".xml"),g=/.*\/$/.test(f.uri)?f.uri:f.uri+"/",m=f.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:o.get("serverDelay")||1e3});t.simulate(d,{sMockdataBaseUrl:n,bGenerateMissingMockData:true});var y=t.getRequests(),h+
=function(e,t,a){a.response=function(a){a.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(o.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){i+
f(e.path.toString().indexOf(i)>-1){h(c,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(m&&m.length>0){m.forEach(function(t){var r=l[t],o=r.uri,n=jQuery.sap.getModulePath(a+r.settings.localUri.replace(".xml",""),".xml");new e({r+
ootUri:o,requests:[{method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:n,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMoc+
kServer:function(){return t}}});                                                                                                                                                                                                                               