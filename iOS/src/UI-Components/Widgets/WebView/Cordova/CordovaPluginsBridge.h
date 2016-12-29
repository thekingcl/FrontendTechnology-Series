//
//  CordovaPluginsBridge.h
//  iOSBoilerplate
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 WXChevalier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CordovaPluginsBridge : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;

@end
