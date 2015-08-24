/**
 * cordova is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 */

console.log("Am I even getting here?");

var exec = require("cordova/exec");

/**
 * Constructor.
 *
 * @returns {BarcodeScanner}
 */
function LKBarcodeScanner() {
};

/**
 * Read code from scanner.
 *
 * @param {Function} successCallback This function will recieve a result object: {
 *        text : '12345-mock',    // The code that was scanned.
 *        cancelled : true/false, // Was canceled.
 *    }
 * @param {Function} errorCallback
 */
LKBarcodeScanner.prototype.scan = function (successCallback, errorCallback, config) {

    if(config instanceof Array) {
        // do nothing
    } else {
        if(typeof(config) === 'object') {
            config = [ config ];
        } else {
            config = [];
        }
    }

    if (errorCallback == null) {
        errorCallback = function () {
        };
    }

    if (typeof errorCallback != "function") {
        console.log("LKBarcodeScanner.scan failure: failure parameter not a function");
        return;
    }

    if (typeof successCallback != "function") {
        console.log("LKBarcodeScanner.scan failure: success callback parameter must be a function");
        return;
    }

    exec(successCallback, errorCallback, 'LKBarcodeScanner', 'scan', config);
};

//-------------------------------------------------------------------
//LKBarcodeScanner.prototype.encode = function (type, data, successCallback, errorCallback, options) {
//    if (errorCallback == null) {
//        errorCallback = function () {
//        };
//    }
//
//    if (typeof errorCallback != "function") {
//        console.log("LKBarcodeScanner.encode failure: failure parameter not a function");
//        return;
//    }
//
//    if (typeof successCallback != "function") {
//        console.log("LKBarcodeScanner.encode failure: success callback parameter must be a function");
//        return;
//    }
//
//    exec(successCallback, errorCallback, 'LKBarcodeScanner', 'encode', [
//        {"type": type, "data": data, "options": options}
//    ]);
//};

var lkBarcodeScanner = new LKBarcodeScanner();
module.exports = lkBarcodeScanner;
