//
//  AppDelegate.h
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@class DDMenuController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wb_token;
@property (strong,nonatomic) NSString *wb_uid;
@property (strong,nonatomic) NSDate *wb_exp;
@property (nonatomic,strong) MainViewController<WBHttpRequestDelegate> *mvc;
@property (nonatomic,strong) DDMenuController *menu;
@property (nonatomic) BOOL isLogin;

-(void)loginOut;
-(void)openWeb:(NSString *)url;
@end
