sap.ui.define([],function(){"use strict";return{onActionParameter:function(a){sap.ushell.Container.getService("CrossApplicationNavigation").isNavigationSupported([{target:{shellHash:"Z_PARAM-manage?Modulo='MM'"}}]).done(function(a){a.map(function(a,e){if+
(a.supported===true){var i=sap.ushell&&sap.ushell.Container&&sap.ushell.Container.getService("CrossApplicationNavigation").hrefForExternal({target:{semanticObject:"Z_PARAM",action:"manage"},params:{Modulo:"MM"}});sap.m.URLHelper.redirect(i,false)}else{al+
ert("Usuário sem permissão para acessar o link")}})}).fail(function(){alert("Falha ao acessar o link")})}}});                                                                                                                                                  