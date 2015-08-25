//
//  LKBarcodeScanner.swift
//  LKBarcodeScannerPlugin
//
//  Created by Christian West on 8/20/15.
//  Copyright (c) 2015 Christian West. All rights reserved.
//

import Foundation

@objc(LKBarcodeScanner)
class LKBarcodeScanner: CDVPlugin {
    var callbackContext: String?
    
    func scan(command: CDVInvokedUrlCommand) {
        callbackContext = command.callbackId
        
        let viewController = LKScannerViewController()
        viewController.lkBarcodeScanner = self
        self.viewController.presentViewController(viewController, animated: true, completion: nil)
        commandDelegate.runInBackground {
            var pluginResult: CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_NO_RESULT)
            pluginResult.setKeepCallbackAsBool(true)
            self.commandDelegate.sendPluginResult(pluginResult, callbackId:command.callbackId)
        }
    }
    
    func foundCode(data: String) {
        if let callbackContext = callbackContext {
            var pluginResult:CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: ["scanned": true, "data": data])
            pluginResult.setKeepCallbackAsBool(false)
            commandDelegate.sendPluginResult(pluginResult, callbackId:callbackContext)
        }
    }
    
    func cancelScan() {
        if let callbackContext = callbackContext {
            var pluginResult:CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: ["scanned": false])
            pluginResult.setKeepCallbackAsBool(false)
            commandDelegate.sendPluginResult(pluginResult, callbackId:callbackContext)
        }
    }
}