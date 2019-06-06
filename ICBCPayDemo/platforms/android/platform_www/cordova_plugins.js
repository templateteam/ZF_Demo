cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "com.pay.ICBCPayPlugin.ICBCPayPlugin",
      "file": "plugins/com.pay.ICBCPayPlugin/www/ICBCPayPlugin.js",
      "pluginId": "com.pay.ICBCPayPlugin",
      "clobbers": [
        "ICBCPayPlugin"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-whitelist": "1.3.3",
    "com.pay.ICBCPayPlugin": "0.0.1"
  };
});