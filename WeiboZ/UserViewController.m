//
//  UserViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-10.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "WeiboModel.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    _userInfo = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.tableView.refreshHeader = NO;
    
    [self loadUserData];
    [self loadWeiboData];
    if(_HideBack){
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.backBarButtonItem.accessibilityFrame = CGRectZero;
    }
}

-(void)loadUserData{
    
    if(_UID != nil){
        NSDictionary *param = @{@"access_token":self.appDelegate.wb_token,@"uid":_UID};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadUserDataFinish"];
    }else{
        if(self.userName.length == 0){
            NSLog(@"Error:用户为空!");
            return;
        }
        NSDictionary *param = @{@"access_token":self.appDelegate.wb_token,@"screen_name":self.userName};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadUserDataFinish"];
    }
    

}

- (void)loadUserDataFinish:(NSString *)result
{
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    UserModel *userModel = [[UserModel alloc]initWithDataDic:resultDict];
    self.userInfo.user = userModel;
    self.tableView.tableHeaderView = _userInfo;
}

-(void)loadWeiboData{
    if(_UID != nil){
        NSDictionary *param = @{@"access_token":self.appDelegate.wb_token,@"uid":_UID};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/user_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadWeiboDataFinish"];

    }else{
        if(self.userName.length == 0){
            NSLog(@"Error:用户名为空！");
            return;
        }
        NSDictionary *param = @{@"access_token":self.appDelegate.wb_token,@"screen_name":self.userName};
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/public_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadWeiboDataFinish"];
    }
}

-(void)loadWeiboDataFinish:(NSString *)result{
    NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [jsonData objectFromJSONData];
    NSArray *statuses = [resultDict objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    for(NSDictionary *dic in statuses){
        WeiboModel *weiboModel = [[WeiboModel alloc]initWithDataDic:dic];
        [weibos addObject:weiboModel];
    }
    self.tableView.data = weibos;
    if(weibos.count>20){
        self.tableView.isMore = YES;
    }else{
        self.tableView.isMore = NO;
    }
    [self.tableView reloadData];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *tag = [NSString stringWithFormat:@"%@:",request.tag];
    SEL selName = NSSelectorFromString(tag);
    if([self respondsToSelector:selName]){
        [self performSelector:selName withObject:result];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
