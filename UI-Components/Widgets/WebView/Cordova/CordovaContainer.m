//
//  CordovaService.m
//  LiveForest
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#import "CordovaContainer.h"

@implementation CordovaContainer

#pragma mark 获取CordovaContainer实例
+ (CordovaContainer*)getSingletonInstance{
    
    static CordovaContainer *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
            //初始化当前cordovaViewController
    }
    return instance;
    
}

#pragma mark 根据输入的页面名启动页面
- (void)startPage:(NSString*)pageName fromViewController:(UIViewController*)fromViewController{
    
    //初始化Cordova容器
    if(!self.cordovaViewController){
        
        self.cordovaViewController = [CDVViewController new];
        
    }
    
    //设置当前的fromViewController
    self.fromViewController = fromViewController;
    
    //设置启动页面
    self.cordovaViewController.startPage = pageName;
    
    //Optional 添加一个返回按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 50, 40)];//构造一个返回按钮
    
    [btn setImage:[UIImage imageNamed:@"ic_arrow_back_white_48dp.png"] forState:UIControlStateNormal];//设置按钮的背景图片
    
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];//为按钮添加响应事件
    
    [self.cordovaViewController.view addSubview:btn];
    
    //以Present方式跳转到该页面
    [fromViewController presentViewController:self.cordovaViewController animated:YES completion:^{
        NSLog(@"进入Cordova");
    }];
    

}

#pragma mark - Event Listener
- (void)goBack{
    [self.cordovaViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"");
    }];
}

@end
