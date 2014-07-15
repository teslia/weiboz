//
//  FirendshipViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-6-29.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "FirendshipViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "UserModel.h"

@interface FirendshipViewController ()

@end

@implementation FirendshipViewController

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
    // Do any additional setup after loading the view from its nib.
    self.data = [NSMutableArray array];
    [self loadAtData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *tag = [NSString stringWithFormat:@"%@:",request.tag];
    SEL selName = NSSelectorFromString(tag);
    if([self respondsToSelector:selName]){
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [jsonData objectFromJSONData];
        [self performSelector:selName withObject:resultDict];
    }
}


-(void)loadAtData{
    if(self.userID.length == 0){
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userID forKey:@"uid"];
    [WBHttpRequest requestWithAccessToken:self.appDelegate.wb_token url:@"https://api.weibo.com/2/friendships/friends.json" httpMethod:@"GET" params:params delegate:self withTag:@"loadAtDataFinish"];
}

-(void)loadAtDataFinish:(NSDictionary *)result{
    NSArray *usersArray = [result objectForKey:@"users"];
    NSMutableArray *array2D = nil;
    for (int i = 0; i < usersArray.count; i++) {
        if(i % 3 == 0){
            array2D = [NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        NSDictionary *userDic = [usersArray objectAtIndex:i];
        UserModel *user = [[UserModel alloc]initWithDataDic:userDic];
        [array2D addObject:user];
    }
    self.tableView.data = self.data;
    //[self.tableView reloadData];
#warning Zmsky警告：微博API限制了查询其他用户的资料。
    [self showHUDError:@"接口升级中，暂时无法查询。"];
}

@end
