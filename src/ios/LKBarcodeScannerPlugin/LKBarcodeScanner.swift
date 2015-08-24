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
    func scan(command: CDVInvokedUrlCommand) {
        var message = command.arguments[0] as! String
        
        println("Hey guys")
        
        message = message.uppercaseString // Prove the plugin is actually doing something
        
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
        commandDelegate.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
}