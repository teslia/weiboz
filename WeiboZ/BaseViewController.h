//
//  BaseViewController.h
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class ProgressHUD;
@interface BaseViewController : UIViewController{
    UIWindow *_tipWindow;
}

@property(nonatomic,assign) BOOL isBackButton;
@property (nonatomic) BOOL doNotHideTabBar;

-(AppDelegate *)appDelegate;

-(void)showHUDMessage:(NSString *)text;
-(void)showHUDOK:(NSString *)text;
-(void)showHUDError:(NSString *)text;
-(void)hideHUD;

//状态栏提升
-(void)showStatusTip:(BOOL)show title:(NSString *)title;

@end
