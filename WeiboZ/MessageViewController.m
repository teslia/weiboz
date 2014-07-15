//
//  MessageViewController.m
//  WeiboZ
//
//  Created by Zmsky on 14-4-24.
//  Copyright (c) 2014年 Zmsky. All rights reserved.
//

#import "MessageViewController.h"
#import "Zmsky-ScrollView.h"
#import "UIFactory.h"
#import "AppDelegate.h"
#import "JSONKit.h"


@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self loadAtWeiboData];
}

-(void)initViews{
    _weiboTable = [[WeiboTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49) style:UITableViewStylePlain];
    _weiboTable.eventDelegate = self;
    _weiboTable.hidden = YES;
    _weiboTable.refreshHeader = NO;
    [self.view addSubview:_weiboTable];
    
    
    NSArray *messageButton = [NSArray arrayWithObjects:@"navigationbar_comments.png",
                              @"navigationbar_mentions.png",
                              @"navigationbar_messages.png",
                              @"navigationbar_notice.png",
                              nil];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    for (int i = 0; i < messageButton.count; i++) {
        NSString *imageName = [messageButton objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:imageName];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(50*i+15, 10, 22, 22);
        [button addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [titleView addSubview:button];
    }
    self.navigationItem.titleView = titleView;
    
}

-(void)messageAction:(UIButton *)button{
    int tag = button.tag;
    switch (tag) {
        case 100:
            [self loadAtWeiboData];
            break;
        case 101:
            [self loadAtWeiboData];
            break;
        case 102:
            [self loadAtWeiboData];
            break;
        case 103:
            [self loadAtWeiboData];
            break;
        default:
            break;
    }
}

-(void)loadAtWeiboData{
    [self showHUDMessage:@"正在加载..."];
    NSDictionary *param = @{@"count":@"100"};
    [WBHttpRequest requestWithAccessToken:self.appDelegate.wb_token url:@"https://api.weibo.com/2/statuses/mentions.json" httpMethod:@"GET" params:param delegate:self withTag:@"loadAtWeiboDataFinish"];
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

-(void)loadAtWeiboDataFinish:(NSDictionary *)result{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for(NSDictionary *statesDic in statues){
        WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:statesDic];
        [weibos addObject:weibo];
    }
    
    //刷新UI
    [self hideHUD];
    _weiboTable.hidden = NO;
    _weiboTable.data = weibos;
    [_weiboTable reloadData];
}
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    [self showHUDError:@"加载失败!"];
}

//下拉
-(void)pullDown:(BaseTableView *)tableView{
    [self loadAtWeiboData];
}
//上拉
-(void)pullUp:(BaseTableView *)tableView{
    [self loadAtWeiboData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
