//
//  LoginViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-28.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:72/255.0 green:145/255.0 blue:234/255.0 alpha:1];
    
    UIImageView *bgImage;
    if(ScreenHeight >= 568){
        bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginBG-R4"]];
    }else{
        bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginBG@2x"]];
    }
    bgImage.tag = 101;
    float sys = WXHLOSVersion();
    if(sys >= 7.0f){
        bgImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }else{
        bgImage.frame = CGRectMake(0, -20, ScreenWidth, ScreenHeight);
    }
    bgImage.userInteractionEnabled = NO;
   
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake((ScreenWidth - 239) /2 , ScreenHeight - 200, 239, 48);
    loginBtn.tag = 102;
    loginBtn.alpha = 0;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [loginBtn addTarget:self action:@selector(loginWeibo) forControlEvents:UIControlEventTouchUpInside];
    UILabel *copyright = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-300)/2, ScreenHeight - 50, 300, 20)];
    copyright.backgroundColor = [UIColor colorWithRed:72/255.0 green:145/255.0 blue:234/255.0 alpha:1];
    copyright.text = @"Copyright (C) 2014 TesliaSoft";
    copyright.textAlignment = NSTextAlignmentCenter;
    copyright.textColor = [UIColor whiteColor];
    copyright.font = [UIFont systemFontOfSize: 12.0];
    [self.view addSubview:bgImage];
    [self.view addSubview:loginBtn];
    [self.view addSubview:copyright];
    [self performSelector:@selector(start) withObject:nil afterDelay:1];
}

-(void)loginWeibo{
   WBAuthorizeRequest *request = [WBAuthorizeRequest request];
   request.redirectURI = kRedirectURI;
   request.scope = @"all";
   [WeiboSDK sendRequest:request];
}

-(void)start{
    UIImageView *bgImage = (UIImageView *)[self.view viewWithTag:101];
    UIButton *login = (UIButton *)[self.view viewWithTag:102];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0]; //延迟
    [UIView setAnimationDuration:.5]; //持续时间
    bgImage.frame = CGRectMake(0, -ScreenHeight/4, bgImage.frame.size.width, bgImage.frame.size.height);
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:.5]; //延迟
    [UIView setAnimationDuration:1]; //持续时间
    login.alpha = 1;
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
