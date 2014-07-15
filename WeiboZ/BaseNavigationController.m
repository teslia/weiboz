//
//  BaseNavigationController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"


@interface BaseNavigationController ()
{

}
@end

@implementation BaseNavigationController
static BOOL _lock;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotifcation object:nil];
        self.delegate = self;
    }
    return self;
}
+(void)lock{
    _lock = YES;
}
+(void)unlock{
    _lock = NO;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [BaseNavigationController lock];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [BaseNavigationController unlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadThemeImage];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipGesture];

}

-(void)swipAction:(UISwipeGestureRecognizer *)swipGesture{
    if(self.viewControllers.count > 1 && swipGesture.direction ==UISwipeGestureRecognizerDirectionRight && !_lock){
        [self popViewControllerAnimated:YES];
    }
}


#pragma mark - NSNOtification actions
-(void)themeNotification:(NSNotification *)notification{
    [self loadThemeImage];
}

-(void)loadThemeImage{
    UIImage *image = [[ThemeManager shareInstance]getThemeImage:@"navigationbar_background.png"];
    float version = WXHLOSVersion();
    if(version >= 5.0){
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationBar setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
