var version=sap.ui.version.split(".");if(parseInt(version[0])<=1&&parseInt(version[1])<78){sap.ui.getCore().loadLibraries(["sap/ui/fl"]);sap.ui.require(["sap/ui/fl/FakeLrepConnector"],function(e){jQuery.extend(e.prototype,{create:function(e){return Promi+
se.resolve()},stringToAscii:function(e){if(!e||e.length===0){return""}var n="";for(var t=0;t<e.length;t++){n+=e.charCodeAt(t)+","}if(n!==null&&n.length>0&&n.charAt(n.length-1)===","){n=n.substring(0,n.length-1)}return n},loadChanges:function(){var n={cha+
nges:[],settings:{isKeyUser:true,isAtoAvailable:false,isProductiveSystem:false}};var t=[];var o="/sap-ui-cachebuster-info.json";var a=[/^localhost$/,/^.*.applicationstudio.cloud.sap$/];var r=new URL(window.location.toString());var c=a.some(e=>e.test(r.ho+
stname));return new Promise(function(a,i){if(!c)i(console.log("cannot load flex changes: invalid host"));$.ajax({url:r.origin+o,type:"GET",cache:false}).then(function(e){var n=Object.keys(e).filter(function(e){return e.endsWith(".change")});$.each(n,func+
tion(e,n){if(n.indexOf("changes")===0){if(!c)i(console.log("cannot load flex changes: invalid host"));t.push($.ajax({url:r.origin+"/"+n,type:"GET",cache:false}).then(function(e){return JSON.parse(e)}))}})}).always(function(){return Promise.all(t).then(fu+
nction(o){return new Promise(function(e,n){if(o.length===0){if(!c)n(console.log("cannot load flex changes: invalid host"));$.ajax({url:r.origin+"/changes/",type:"GET",cache:false}).then(function(o){var a=/(\/changes\/[^"]*\.[a-zA-Z]*)/g;var i=a.exec(o);w+
hile(i!==null){if(!c)n(console.log("cannot load flex changes: invalid host"));t.push($.ajax({url:r.origin+i[1],type:"GET",cache:false}).then(function(e){return JSON.parse(e)}));i=a.exec(o)}e(Promise.all(t))}).fail(function(n){e(o)})}else{e(o)}}).then(fun+
ction(t){var o=[],r=[];t.forEach(function(n){var t=n.changeType;if(t==="addXML"||t==="codeExt"){var a=t==="addXML"?n.content.fragmentPath:t==="codeExt"?n.content.codeRef:"";var c=a.match(/webapp(.*)/);var i="/"+c[0];o.push($.ajax({url:i,type:"GET",cache:+
false}).then(function(o){if(t==="addXML"){n.content.fragment=e.prototype.stringToAscii(o.documentElement.outerHTML);n.content.selectedFragmentContent=o.documentElement.outerHTML}else if(t==="codeExt"){n.content.code=e.prototype.stringToAscii(o);n.content+
.extensionControllerContent=o}return n}))}else{r.push(n)}});if(o.length>0){return Promise.all(o).then(function(e){e.forEach(function(e){r.push(e)});r.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=r;var t={changes:n,compo+
nentClassName:"br.com.trescoracoes.operacaoargo"};a(t)})}else{r.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=r;var c={changes:n,componentClassName:"br.com.trescoracoes.operacaoargo"};a(c)}})})})})}});e.enableFakeConnect+
or()})}                                                                                                                                                                                                                                                        