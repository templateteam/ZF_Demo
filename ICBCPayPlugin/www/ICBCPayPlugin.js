var exec = require('cordova/exec');

exports.callJHBank = function (arg0, success, error) {
    exec(success, error, 'ICBCPayPlugin', 'callJHBank', [arg0]);
};
var exec = require('cordova/exec');
