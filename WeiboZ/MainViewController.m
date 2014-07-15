//
//  MainViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-21.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "JSONKit.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initSystemSet];
    [self _initViewController];
    [self _initTabbarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化系统设定
-(void)_initSystemSet{
    NSString *sysThemeName = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeSetKey"];
    if(sysThemeName != nil){
        [[ThemeManager shareInstance]setThemeName:sysThemeName];
    }
}

//初始化子控制器
-(void)_initViewController{
    HomeViewController *home = [[HomeViewController alloc]init];
    MessageViewController *message = [[MessageViewController alloc]init];
    ProfileViewController *profile = [[ProfileViewController alloc]init];
    DiscoverViewController *discover = [[DiscoverViewController alloc]init];
    MoreViewController *more = [[MoreViewController alloc]init];
    
    NSArray *views = @[home,message,profile,discover,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for(BaseViewController *viewController in views){
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:viewController];
        if(!viewController.doNotHideTabBar){
            nav.delegate = self;
        }
        [viewControllers addObject: nav];
    }
    self.viewControllers = viewControllers;
}

//创建自定义的tabbar
-(void)_initTabbarView{
    
    float version = WXHLOSVersion();
    if(version >= 7.0){
        //7.0 默认可以使用状态栏那20高的位置
        _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49, 320, 49)];
    }else{
        _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49-20, 320, 49)];
    }
    
    [self.view addSubview:_tabbarView];
   // _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background" ]];
    UIImageView *tabbarGroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    tabbarGroundImage.frame = _tabbarView.bounds;
    [_tabbarView addSubview:tabbarGroundImage];
    NSArray *background = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for(int i = 1 ; i <= background.count ; i ++){
        NSString *backImage = background[i-1];
        NSString *heightImage = heightBackground[i-1];
        
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //ThemeButton *button = [[ThemeButton alloc]initWithImage:backImage highlighted:heightImage];
        UIButton *button = [UIFactory createButton:backImage highlighted:heightImage];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake((64-30)/2+((i-1)*64), (49-30)/2, 30, 30);
        button.tag = i;
        if(i == 1){
            button.selected = YES;  //默认home高亮
        }
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
}

-(void)selectedTab:(UIButton *)button{
    for(int i=1;i<=5;i++){
            UIButton *buttons = (UIButton *)[self.view viewWithTag:i];
            buttons.selected = NO;
    }
    button.selected = YES;
    if(button.tag == self.selectedIndex+1 && button.tag == 1){
        UINavigationController *homeNav = [self.viewControllers objectAtIndex:0];
        HomeViewController *homeCtrl = [homeNav.viewControllers objectAtIndex:0];
        [homeCtrl refreshWeibo];
        [homeCtrl.navigationController popToRootViewControllerAnimated:YES];
    }
    self.selectedIndex = button.tag-1;
}

-(void)timerAction:(NSTimer *)timer{
    [self loadUnReadData];
}

-(void)loadUnReadData{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *param = @{@"access_token":myDelegate.wb_token,@"uid":myDelegate.wb_uid};
    [WBHttpRequest requestWithURL:@"https://rm.api.weibo.com/2/remind/unread_count.json" httpMethod:@"GET" params:param delegate:self withTag:@"refreshUnReadView"];
}

-(void)showBadge:(BOOL)show{
    _badgeView.hidden = !show;
}

-(void)showTabBar:(BOOL)show{
    float os = WXHLOSVersion();
    [UIView animateWithDuration:0.3 animations:^{
        if(show){
            if(os>=7.0f){
                _tabbarView.bottom = ScreenHeight;
            }else{
                _tabbarView.bottom = ScreenHeight -20;
            }
            _tabbarView.alpha = 1;
        }else{
            _tabbarView.bottom = ScreenHeight + 50;
            _tabbarView.alpha = 0;
        }
    }];
    
    if(os< 7.0f){
        [self _resizeView:show];
    }
}

-(void)_resizeView:(BOOL)show{
    for(UIView *subView in self.view.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITransitionView")]){
            if(show){
                subView.height = ScreenHeight - 49 - 20;
            }else{
                subView.height = ScreenHeight  - 20;
            }
        }
    }
}

-(void)refreshUnReadView:(NSString *)result{
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    NSNumber *status = [resultDict objectForKey:@"status"];
    if(_badgeView == nil){
        _badgeView = [UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake(64-25, 5, 20, 20);
        [_tabbarView addSubview:_badgeView];
        UILabel *badgeLabel = [[UILabel alloc]initWithFrame:_badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor purpleColor];
        badgeLabel.tag = 200;
        [_badgeView addSubview:badgeLabel];
    }
    int n = [status intValue];
    UINavigationController *homeNav = [self.viewControllers objectAtIndex:0];
    HomeViewController *homeCtrl = [homeNav.viewControllers objectAtIndex:0];
    homeCtrl.unreadCount = n;
    if(n > 0){
        UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:200];
        if(n > 99){
            n = 99;
        }
        badgeLabel.text = [NSString stringWithFormat:@"%d",n];
        _badgeView.hidden = NO;
        [UIApplication sharedApplication].applicationIconBadgeNumber = n;
    }else{
        _badgeView.hidden = YES;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *tag = [NSString stringWithFormat:@"%@:",request.tag];
    SEL selName = NSSelectorFromString(tag);
    if([self respondsToSelector:selName]){
        [self performSelector:selName withObject:result];
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:@"网络连接失败！"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

#pragma mark - navigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [BaseNavigationController lock];
        int count  = navigationController.viewControllers.count;
    if(count == 1){
        [self showTabBar:YES];
    }else{
        [self showTabBar:NO];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [BaseNavigationController unlock];
}

@end
