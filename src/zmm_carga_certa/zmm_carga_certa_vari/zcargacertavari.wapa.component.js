sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","cargacertavarif/cargacertavarif/model/models"],function(e,t,a){"use strict";return e.extend("cargacertavarif.cargacertavarif.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init+
.apply(this,arguments);this.getRouter().initialize();this.setModel(a.createDeviceModel(),"device")}})});                                                                                                                                                       