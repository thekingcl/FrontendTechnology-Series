//
//  CordovaService.h
//  LiveForest
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "CDVPlugin.h"
#import <Cordova/CDVViewController.h>

@interface CordovaContainer : CDVPlugin

#pragma mark - 公有变量

/**跳转到Cordova的ViewController对象*/
@property(nonatomic,strong) UIViewController* fromViewController;

/**当前Cordova的ViewController*/
@property(nonatomic,strong) CDVViewController* cordovaViewController;


#pragma mark - 公有静态方法

#pragma mark 获取类的单例
+ (CordovaContainer*)getSingletonInstance;

#pragma mark - 公有类方法
- (void)startPage:(NSString*)pageName fromViewController:(UIViewController*)fromViewController;

@end
