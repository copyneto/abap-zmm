sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","br/com/trescoracoes/prcargacertaf/model/models"],function(e,t,i){"use strict";return e.extend("br.com.trescoracoes.prcargacertaf.Component",{metadata:{manifest:"json"},init:function(){e.prototype.+
init.apply(this,arguments);this.getRouter().initialize();this.setModel(i.createDeviceModel(),"device")}})});                                                                                                                                                   