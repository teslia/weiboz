//
//  BaseViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"

#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if(viewControllers.count > 1 && self.isBackButton){
        UIButton *button = [UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, 24, 24);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// ZmskyExt Add
-(AppDelegate *)appDelegate{
     AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    return myDelegate;
}

-(void)showHUDMessage:(NSString *)text{
    [ProgressHUD show:text];
}
-(void)showHUDOK:(NSString *)text{
    [ProgressHUD showSuccess:text];
}

-(void)showHUDError:(NSString *)text{
    [ProgressHUD showError:text];
}

-(void)hideHUD{
    [ProgressHUD dismiss];
}

//状态栏提升
-(void)showStatusTip:(BOOL)show title:(NSString *)title{
    if(_tipWindow == nil){
        _tipWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.tag = 2014;
        [_tipWindow addSubview:tipLabel];
        
        UIImageView *progress = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queue_statusbar_progress"]];
        progress.frame = CGRectMake(0,20-6, 100, 6);
        progress.tag = 2013;
        [_tipWindow addSubview:progress];
      }
    UILabel *tipLabel = (UILabel *)[_tipWindow viewWithTag:2014];
    UIImageView *progress = (UIImageView *) [_tipWindow viewWithTag:2013];
    
    tipLabel.text = title;
    if(show){
        _tipWindow.hidden = NO;
        progress.left = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        progress.left = ScreenWidth;
        [UIView commitAnimations];
    }else{
        progress.hidden = YES;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:3];
    }
}

-(void)removeTipWindow{
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}


@end
