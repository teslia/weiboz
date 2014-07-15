//
//  AppDelegate.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "LoginViewController.h"
#import "ProgressHUD.h"
#import "WebViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //从UserDefault读取是否登录过
    NSDictionary *sinaWeiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    if([sinaWeiboInfo objectForKey:@"AccessTokenKey"] && [sinaWeiboInfo objectForKey:@"ExpirationDateKey"] && [sinaWeiboInfo objectForKey:@"UserIDKey"]){
        self.wb_token =[sinaWeiboInfo objectForKey:@"AccessTokenKey"];
        self.wb_exp = [sinaWeiboInfo objectForKey:@"ExpirationDateKey"];
        self.wb_uid = [sinaWeiboInfo objectForKey:@"UserIDKey"];
        self.isLogin = YES;
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if(!self.isLogin){
    LoginViewController *login = [[LoginViewController alloc]init];
        [self.window addSubview:login.view];
        self.window.rootViewController = login;
    }else{
        self.mvc = [[MainViewController alloc]init];
        _menu = [[DDMenuController alloc]initWithRootViewController:self.mvc];
       
        self.window.rootViewController = _menu;
    
        LeftViewController *lvc = [[LeftViewController alloc]init];
        RightViewController *rvc = [[RightViewController alloc]init];
    
        _menu.leftViewController = lvc;
        _menu.rightViewController = rvc;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)loginOK{
    self.window.rootViewController = nil;
    self.mvc = [[MainViewController alloc]init];
    _menu = [[DDMenuController alloc]initWithRootViewController:self.mvc];
    
    self.window.rootViewController = _menu;
    
    LeftViewController *lvc = [[LeftViewController alloc]init];
    RightViewController *rvc = [[RightViewController alloc]init];
    
    _menu.leftViewController = lvc;
    _menu.rightViewController = rvc;
    [self performSelector:@selector(loginOKTips) withObject:nil afterDelay:0.5];
}
-(void)loginOKTips{
    [ProgressHUD showSuccess:@"登录成功"];
}
-(void)loginOut{
    self.window.rootViewController = nil;
    self.mvc = nil;
    
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.window addSubview:login.view];
    self.window.rootViewController = login;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
      /**  NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
       **/
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wb_token = [(WBAuthorizeResponse *)response accessToken];
        self.wb_exp = [(WBAuthorizeResponse *)response expirationDate];
        self.wb_uid = [(WBAuthorizeResponse *)response userID];
        if(self.wb_token != nil){
            //将Token信息保存成字典写入UserDefault
            NSDictionary *SinaWeiboAuthData = @{@"AccessTokenKey":self.wb_token,@"ExpirationDateKey":self.wb_exp,@"UserIDKey":self.wb_uid};
            [[NSUserDefaults standardUserDefaults] setObject:SinaWeiboAuthData forKey:@"SinaWeiboAuthData"];
            self.isLogin = YES;
            [self loginOK];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取授权失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {

    }
}

-(void)openWeb:(NSString *)url{
     WebViewController *web = [[WebViewController alloc]initWithURL:url];
    [self.mvc presentViewController:web animated:YES completion:nil];
}

@end
