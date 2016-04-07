//
//  CordovaPluginsBridge.m
//  iOSBoilerplate
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 WXChevalier. All rights reserved.
//

#import "CordovaPluginsBridge.h"

@implementation CordovaPluginsBridge

- (void)echo:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CordovaPluginsBridge-Echo");
    
    CDVPluginResult* pluginResult = nil;
    
    NSString* echo = [command.arguments objectAtIndex:0];
    
    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


@end
